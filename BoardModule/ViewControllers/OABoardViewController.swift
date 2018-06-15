//
//  OABoardViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/12.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit
import Foundation
import MJRefresh
import MJExtension
import MBProgressHUD

enum childVCType: NSInteger {
    case gbRank = 1
    case productMix
}

class OABoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr: NSMutableArray = []
    var childVCnum: NSInteger = 0
    var tempBtn:UIButton?
    var isRequestSuccess: Bool = false
    var btnTag: NSInteger = 0
    private var tableView: UITableView?
    
    var scrollView: UIScrollView?
    var segmentedControl: UISegmentedControl?
    var segCtitleArr: NSArray?
    var deptTypeParams: NSArray?
    var isOpenArr: NSMutableArray = []
    var channelArr: NSArray = []
    
    var hud: MBProgressHUD?
    var timeLab: UILabel?
    var unitLab: UILabel?
    var titleLab: UILabel?
    var bottomLeftView: UIView?
    var bottomRightView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    var failureView: UIView?
    
    var branchCode: String?
    
    
    private var isDetail: Bool = false
    var isOPEN_today: Bool = false
    var isOPEN_tomorary: Bool = false
    var isOPEN_total: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "切换机构", style: .plain, target: self, action: #selector(switchMechanism))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = ColorFromRGB(r: 245, g: 245, b: 245)
        //            UIRectEdge(rawValue: 0)
        
        let dic = ["isOPEN_today":true,"isOPEN_tomorary":false,"isOPEN_total":false]
        let isOpendic = NSMutableDictionary.init(dictionary: dic)
        isOpenArr = NSMutableArray.init(array: [isOpendic, isOpendic, isOpendic, isOpendic])
        
        channelArr = ["个险","传统","招证","经代"];
        segCtitleArr = ["个险总汇", "个险明细", "传统总汇", "传统明细", "招证总汇", "招证明细", "经代总汇", "经代明细"]
        self.creatSubViews()
        
    }
    
    func creatSubViews() -> () {
        titleLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        titleLab?.textAlignment = .center
        titleLab?.textColor = UIColor.white
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 30))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        timeLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 30))
        timeLab?.font = UIFont.systemFont(ofSize: 11 * ADAPTATION_WITH_WIDTH)
        timeLab?.textAlignment = .center
        topView.addSubview(timeLab!)
        
        let unitlab = UILabel.init(frame: CGRect(x: SCREEN_W-65, y: 0, width: 65, height: 30))
        unitlab.font = UIFont.systemFont(ofSize: 11 * ADAPTATION_WITH_WIDTH)
        unitlab.textAlignment = .right
        topView.addSubview(unitlab)
        
        /// 适配iPhoneX
        if (SCREEN_H == 812) {
            let bottomSafeView = UIView.init(frame: CGRect(x: 0, y: SCREEN_H - safeBottomH - safeNavH, width: SCREEN_W, height: 34))
            bottomSafeView.backgroundColor = UIColor.white
            self.view.addSubview(bottomSafeView)
        }
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: bottom(object: topView), width: SCREEN_W, height: SCREEN_H-safeNavH-height(object: topView)-safeBottomH))
        self.view.addSubview(scrollView!)
//        scrollView?.backgroundColor = UIColor.orange
        
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadPageData))
        scrollView?.mj_header = header
        
        let norImageArr: NSArray = ["BoardUI.bundle/pip","BoardUI.bundle/tradition","BoardUI.bundle/zhaoZ","BoardUI.bundle/jingD"]
        let selectImgArr: NSArray = ["BoardUI.bundle/pip_sel","BoardUI.bundle/tradition_sel","BoardUI.bundle/zhaoZ_sel","BoardUI.bundle/jingD_sel"]
        
        let btnView = self.creatButtonWithNomalImage(nomImgArr: norImageArr, selImgArr: selectImgArr)
        btnView.tag = 999;
        scrollView?.addSubview(btnView)
        
        let segControlView = UIView.init(frame: CGRect(x: 0, y: bottom(object: btnView)-5, width: SCREEN_W, height: 70*ADAPTATION_WITH_WIDTH))
        segControlView.backgroundColor = UIColor.white
        
        segmentedControl = UISegmentedControl.init(items: ["个险总汇","个险明细"])
        segmentedControl?.frame = CGRect(x: 20*ADAPTATION_WITH_WIDTH, y: 18, width: SCREEN_W-20*2*ADAPTATION_WITH_WIDTH, height: 40*ADAPTATION_WITH_WIDTH)
        segControlView.addSubview(segmentedControl!)
        
        segmentedControl?.tintColor = UIColor.white
        segmentedControl?.backgroundColor = ColorFromRGB(r: 0xF1, g: 0xF1, b: 0xF1)
        segmentedControl?.layer.masksToBounds = true
        segmentedControl?.layer.cornerRadius = 20;
        segmentedControl?.layer.borderWidth = 1.5;
        segmentedControl?.layer.borderColor = ColorFromRGB(r: 0xF1, g: 0xF1, b: 0xF1).cgColor;
        
        ///  设置分段名的字体
        segmentedControl?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ColorFromRGB(r: 0x33, g: 0x33, b: 0x33), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        segmentedControl?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ColorFromRGB(r: 0x5B, g: 0x5B, b: 0x5B), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: .selected)
        segmentedControl?.selectedSegmentIndex = 0;
        segmentedControl?.addTarget(self, action: #selector(selectItem(segControl:)), for: .valueChanged)
        
        tableView = UITableView.init(frame: CGRect(x: 10, y: bottom(object: segControlView)+10, width: SCREEN_W-20, height: bottom(object: scrollView!)-bottom(object: segControlView)-20-bottom(object: topView)-50))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.rowHeight = 50;
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none;
        tableView?.showsVerticalScrollIndicator = false
        scrollView?.addSubview(tableView!)
        
        if childVCnum > 0 {
            let rowView = UIView.init(frame: CGRect(x: 0, y: bottom(object: btnView)-5, width: SCREEN_W, height: 15))
            rowView.backgroundColor = UIColor.white
            scrollView?.addSubview(rowView)
            
            tableView?.frame = CGRect(x: 10, y: bottom(object: rowView)+10, width: SCREEN_W-20, height: SCREEN_H-safeNavH-safeBottomH-bottom(object: rowView)-height(object: topView)-20)
            
            if childVCnum == childVCType.gbRank.rawValue {
                titleLab?.text = OABoardBranchInfoManager.sharedBranchInfoManager.gbRankBranchDic["branchName"] as? String
                
            } else if childVCnum == childVCType.productMix.rawValue{
                titleLab?.text =  OABoardBranchInfoManager.sharedBranchInfoManager.productMixBranchDic["branchName"] as? String
            }
            
            /// ----------------
                        if (titleLab?.text)! == "" || OABoardBranchInfoManager.sharedBranchInfoManager.isGborProduct {
//            titleLab?.text = "sdasd"
//                                OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic["branchName"] as? String
            
                        }
            
            self.navigationItem.titleView = titleLab
            self.loadPageData()
        } else {
            activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
            self.view.addSubview(activityIndicator!)
            activityIndicator?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            activityIndicator?.backgroundColor = UIColor.white
            activityIndicator?.startAnimating()
            self.navigationItem.titleView = self.activityIndicator;
            scrollView?.addSubview(segControlView)
            
            bottomLeftView = self.creatBtnViewWithImageName(imageName: "BoardUI.bundle/gbRankings", title: "规保排名", x: 0, y: SCREEN_H-safeNavH-50-safeBottomH, w: SCREEN_W/2.0, h: 50)
            self.view.addSubview(bottomLeftView!)
            
            bottomRightView = self.creatBtnViewWithImageName(imageName: "BoardUI.bundle/productMix", title: "产品结构", x: SCREEN_W/2.0, y: SCREEN_H-safeNavH-50-safeBottomH, w: SCREEN_W/2.0, h: 50)
            self.view.addSubview(bottomRightView!)
            
            self.loadUserLimitBranchData()
        }
    }
    
    func creatBtnViewWithImageName(imageName: String, title: String, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> (UIView) {
        let subView = UIView.init(frame: CGRect(x: x, y: y, width: w, height: h))
        subView.backgroundColor = UIColor.white
        
        let imageV_x = (w-(30+8+75))/2.0;
        let imageV = UIImageView.init(frame: CGRect(x: imageV_x, y: 10, width: 30, height: 30))
        imageV.image = UIImage.init(named: imageName)
        subView.addSubview(imageV)
        
        let lab = UILabel.init(frame: CGRect(x: right(object: imageV)+8, y: 0, width: 75, height: h))
        lab.text = title;
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = ColorFromRGB(r: 0x56, g: 0x56, b: 0x56);
        subView.addSubview(lab)
        subView.restorationIdentifier = title;
        subView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(btnViewClick(tap:))))
        
        return subView;
    }
    
    @objc func btnViewClick(tap: UITapGestureRecognizer) -> () {
        OABoardBranchInfoManager.sharedBranchInfoManager.isGborProduct = true
        if tap.view?.restorationIdentifier == "规保排名" {
            self.navigationController?.pushViewController(BoardGBRankViewController.init(), animated: true)
        } else {
            self.navigationController?.pushViewController(BoardProductMixViewController.init(), animated: true)
        }
    }
    
    func creatButtonWithNomalImage(nomImgArr: NSArray, selImgArr: NSArray) -> (UIView) {
        let h = (SCREEN_W-10*ADAPTATION_WITH_WIDTH*2-5*3)/4.0;
        let btnView = UIView.init(frame: CGRect(x: 0, y: 10, width: SCREEN_W, height: h))
        for n in 0..<4 {
            let btn = UIButton.init(frame: CGRect(x: 10+(h+5)*(CGFloat(n)), y: 0, width: h, height: h))
            btn.setImage(UIImage.init(named: nomImgArr[n] as! String), for: .normal)
            btn.setImage(UIImage.init(named: selImgArr[n] as! String), for: .selected)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.tag = n
            btnView.addSubview(btn)
            
            if n == 0 {
                btn.isSelected = true
                tempBtn = btn
            }
        }
        return btnView
    }
    
    @objc func selectItem(segControl: UISegmentedControl) {
        self.isDetail = segControl.selectedSegmentIndex == 0 ? false : true
        if (self.isDetail) {
            self.bottomLeftView?.removeFromSuperview()
            self.bottomRightView?.removeFromSuperview()
            self.tableView?.frame = CGRect(x: originx(object: tableView!), y: originy(object: tableView!), width: width(object: tableView!), height: height(object: tableView!)+50)
        } else {
            self.view.addSubview(self.bottomLeftView!)
            self.view.addSubview(self.bottomRightView!)
            self.tableView?.frame = CGRect(x: originx(object: tableView!), y: originy(object: tableView!), width: width(object: tableView!), height: height(object: tableView!)-50)
        }
        
        self.dataArr.removeAllObjects()
        
        self.loadPageData()
    }
    
    @objc func btnClick(btn: UIButton) {
        if btn == tempBtn {
            return
        }
        
        segmentedControl?.selectedSegmentIndex = 0
        if isDetail == true {
            isDetail = false
            view.addSubview(bottomLeftView!)
            view.addSubview(bottomRightView!)
            tableView?.frame = CGRect(x: originx(object: tableView!), y: originy(object: tableView!), width: width(object: tableView!), height: height(object: tableView!)-50)
        }
        
        tempBtn?.isSelected = false
        btn.isSelected = true
        tempBtn = btn
        
        segmentedControl?.setTitle(segCtitleArr![2*btn.tag] as? String, forSegmentAt: 0)
        segmentedControl?.setTitle(segCtitleArr![2*btn.tag + 1] as? String, forSegmentAt: 1)
        
        btnTag = btn.tag
        loadPageData()
        
    }
    
    @objc func switchMechanism() -> () {
        
    }
    
    func loadUserLimitBranchData() -> () {
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .indeterminate
        
        if failureView != nil {
            failureView?.removeFromSuperview()
            failureView = nil
        }
        
        let key = "userLimitBranch"
                RequestTool.sharedInstance.getInsuranceperformanceDataWithKey(key: key, params: ["brancePara":"-1"]) { (resultData: HttpResultModel) in
        
                    if resultData.result! {
                        if KgetResultFlag(data: resultData.data as! NSDictionary) {
                            self.dataArr.removeAllObjects()
        
                            let dataDic = KgetResultParam(data: resultData.data!, key: key)
                            if dataDic.allKeys.count == 0 || dataDic["body"] == nil {
//        self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1", userLimit: false)
        self.tableView?.reloadData()
        self.scrollView?.mj_header.endRefreshing()
        return
                            }
                            
                            let code: String = dataDic["code"] as! String
                            if (code == "Y") {
                                self.hud?.hide(animated: true)
                                self.hud = nil;
                                let bodyDic = dataDic["body"] as! NSDictionary
                                let branchCode = bodyDic["branchCode"] as! String
                                OABoardBranchInfoManager.sharedBranchInfoManager.firstBranchCode = branchCode
                                OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic.setValue(branchCode, forKey: "branchCode")
                                
                                OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic.setValue(bodyDic["branchName"] as! String, forKey: "branchName")
                                OABoardBranchInfoManager.sharedBranchInfoManager.gbRankBranchDic.setValue(branchCode, forKey: "branchCode")
                                OABoardBranchInfoManager.sharedBranchInfoManager.productMixBranchDic.setValue(branchCode, forKey: "branchCode")
        self.activityIndicator?.stopAnimating()
                                self.activityIndicator?.removeFromSuperview()
                                
                                self.titleLab?.text = bodyDic["branchName"] as? String
                                self.navigationItem.titleView = self.titleLab
                                self.loadPageData()
        
                            } else { //code=N;
                            self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "BoardUI.bundle/NoData1", userLimit: false)
                  
                            }
                       
                        } else { //flag=N;
                            self.showRequestFailureViewWithTitle(title: KgetResultMessage(data: resultData.data as! NSDictionary), imageName: "BoardUI.bundle/NoNetwork", userLimit: false)
                        }
                    
                    } else {  //result=nil;
                        self.showRequestFailureViewWithTitle(title: resultData.message!, imageName: "BoardUI.bundle/NoNetwork", userLimit: false)
                    }
    }
    }
    
    @objc func loadPageData() -> () {
        
        if (failureView != nil) {
            failureView?.removeFromSuperview()
            failureView = nil;
        }
        
        if ((scrollView?.mj_offsetY)! > -10) { //下拉刷新时 mj_offsetY = -54
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
        }
        
        isRequestSuccess = false
        if (childVCnum == 0) {
            branchCode = OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic["branchCode"] as! String
        } else if (childVCnum == childVCType.gbRank.rawValue) {
            branchCode = OABoardBranchInfoManager.sharedBranchInfoManager.gbRankBranchDic["branchCode"] as? String
        } else if (childVCnum == childVCType.productMix.rawValue) {
            branchCode = OABoardBranchInfoManager.sharedBranchInfoManager.productMixBranchDic["branchCode"] as? String
        }
       
        if OABoardBranchInfoManager.sharedBranchInfoManager.isGborProduct {
            branchCode = OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic["branchCode"] as? String
        }
        
        let branchName = OABoardBranchInfoManager.sharedBranchInfoManager.defaultBranchDic["branchName"] as? String
        
        if (branchCode == "" || branchName == "") {

            self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1", userLimit: false)

            self.tableView?.reloadData()
            self.scrollView?.mj_header.endRefreshing()
            return;
        }
     
        //  01 - 传统 40 - 招证 41 - 经代 A - 个险
        deptTypeParams = ["A","01","40","41"];
        
        var key = self.isDetail == true ? "getBranchDetailData" : "getBranchSumData";
        if (self.childVCnum == childVCType.gbRank.rawValue) {
            key = "scaleRank";
        } else if (self.childVCnum == childVCType.productMix.rawValue) {
            key = "product";
        }
        
        let deptTypePara = deptTypeParams![(tempBtn?.tag)!];
        
        let params = ["brancePara" : self.branchCode!, "flagPara" : "1", "deptTypePara" : deptTypePara]
        
        RequestTool.sharedInstance.getInsuranceperformanceDataWithKey(key: key, params: params as NSDictionary) { (resultData: HttpResultModel) in
            if resultData.result! {
                if KgetResultFlag(data: resultData.data as! NSDictionary) {
                    self.dataArr.removeAllObjects()
                    
                    let dataDic = KgetResultParam(data: resultData.data!, key: key)
                    let bodyArr = dataDic["body"] as! [[String: AnyObject]]

                    if dataDic.allKeys.count == 0 || bodyArr.count == 0 {
                        self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1", userLimit: true)
                        self.tableView?.reloadData()
                        self.scrollView?.mj_header.endRefreshing()
                        return
                    }
                    
                    let code: String = dataDic["code"] as! String
                    if (code == "Y") {
                        // ------------ //
//                        let models = BoardModel.listToModel(list: bodyArr)
                        
                        for dict in bodyArr {
                            let model = BoardModel.dictToModel(dic: dict)
                            self.dataArr.add(model)
                        }
                        
                        
                       // ------------ //
                        let bodyDic = bodyArr[0]
                        let unit: String = (self.childVCnum > 0) ? "单位:万元" : ""
                        self.timeLab?.text = String(format: "数据为%@渠道 更新时间为%@", self.channelArr[self.btnTag] as! String, bodyDic["updatedDate"] as! String)
                        self.unitLab?.text = unit

                        self.isRequestSuccess = true
                        self.hud?.hide(animated: true)
                        self.hud = nil;
                    } else {  //code=N
                        self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1", userLimit: true)
                    }
                    
                } else { //flag=N
                    
                    self.showRequestFailureViewWithTitle(title: KgetResultMessage(data: resultData.data as! NSDictionary), imageName: "OAUIKit.bundle/NoNetwork", userLimit: true)
                }
            } else { //result=nil;
                self.showRequestFailureViewWithTitle(title: resultData.message!, imageName: "OAUIKit.bundle/NoNetwork", userLimit: true)
            }
            
            self.tableView?.reloadData()
            self.scrollView?.mj_header.endRefreshing()
        }
        
    }
    
    func showRequestFailureViewWithTitle(title: String, imageName: String, userLimit:Bool) -> () {
                if userLimit == false {
                    let alertActionView = UIAlertController.init(title: "温馨提示", message: "此用户没有权限", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                        (UIAlertAction) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
        
                    alertActionView.addAction(okAction)
                    self.present(alertActionView, animated: true, completion: nil)
                    }
        
        activityIndicator?.stopAnimating()
        hud?.hide(animated: true)
        hud = nil
        
        let btnView = scrollView?.viewWithTag(999)
        var y = bottom(object: btnView!)
        if (childVCnum == 0) {
            y = y + 70 * ADAPTATION_WITH_WIDTH;
        }
        
        failureView = UIView(frame: CGRect(x: 0, y: y+84, width: SCREEN_W, height: 150*ADAPTATION_WITH_WIDTH), title: title, imageName: imageName)
        
        scrollView?.addSubview(failureView!)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isRequestSuccess == false {
            return 0
        } else {
            return self.isDetail ? 3 : 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRequestSuccess == false {
            return 0
        } else {
            if isDetail == true {
                let dic = self.isOpenArr[self.btnTag] as! NSDictionary
                self.isOPEN_today = dic["isOPEN_today"] as! Bool
                self.isOPEN_tomorary = dic["isOPEN_tomorary"] as! Bool
                self.isOPEN_total = dic["isOPEN_total"] as! Bool
                
                if (section == 0) {
                    return self.isOPEN_today ? 4 : 0
                } else if (section == 1) {
                    return self.isOPEN_tomorary ? 4 : 0
                } else {
                    return self.isOPEN_total ? 5 : 0
                }
            } else {
                return (self.btnTag > 1) ? 5 : 7
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.isDetail ? 50 : 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 3 {
            return 0.0001
        } else {
            return self.isDetail ? 10 : 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.isDetail == false) {
            return nil;
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W-20, height: 50))
        headerView.backgroundColor = UIColor.white
        
        let titleLab = UILabel(frame: CGRect(x: 20, y: 0, width: 50, height: 49))
        titleLab.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(titleLab)

        
        let btn = UIButton(frame: CGRect(x: width(object: headerView)-60, y: 0, width: 60, height: 50))
        btn.tag = section
        btn.addTarget(section, action: #selector(sectionBtnClick(btn:)), for: .touchUpInside)
        headerView.addSubview(btn)
        
        let btnImageV = UIImageView(frame: CGRect(x: 15, y: 20, width: 30, height: 10))
        btnImageV.image = UIImage.init(named: "BoardUI.bundle/pip_more")
        btnImageV.contentMode = .scaleAspectFit;
        
        if (section == 0 && self.isOPEN_today) {
            btnImageV.image = UIImage.init(named: "BoardUI.bundle/pip_less")
        } else if (section == 1 && self.isOPEN_tomorary) {
            btnImageV.image = UIImage.init(named: "BoardUI.bundle/pip_less")
        } else if (section == 2 && self.isOPEN_total) {
            btnImageV.image = UIImage.init(named: "BoardUI.bundle/pip_less")
        }
        btn.addSubview(btnImageV)
        
        if (section == 0) {
            titleLab.text = "本日"
        } else if (section == 1) {
            titleLab.text = "昨日"
        } else {
            titleLab.text = "累计"
        }
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView.init();
        footView.backgroundColor = UIColor.clear
        return footView;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardTableViewCell.cellWithTableView(tableView: tableView, styleNum: boardVCtype.pipPerformance.rawValue)
        if self.dataArr.count > 0 {
            let model = self.dataArr.firstObject as! BoardModel
            cell.refreshModel(model: model, indexPath: indexPath, btnTag: self.btnTag, isDetail: self.isDetail)
        }
        
        return cell
    }
    
    @objc func sectionBtnClick(btn: UIButton) -> () {
        btn.isSelected = !btn.isSelected
        if (btn.tag == 0) {
            self.isOPEN_today = !self.isOPEN_today
        } else if (btn.tag == 1) {
            self.isOPEN_tomorary = !self.isOPEN_tomorary
        } else {
            self.isOPEN_total = !self.self.isOPEN_total
        }

        let dic = NSMutableDictionary.init(dictionary: self.isOpenArr[btn.tag] as! NSDictionary)
        dic.setValue(self.isOPEN_today, forKey: "isOPEN_today")
        dic.setValue(self.isOPEN_tomorary, forKey: "isOPEN_tomorary")
        dic.setValue(self.isOPEN_total, forKey: "isOPEN_total")
        self.isOpenArr.replaceObject(at: self.btnTag, with: dic)
        
        self.tableView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
