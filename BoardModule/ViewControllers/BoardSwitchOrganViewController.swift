//
//  BoardSwitchOrganViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/15.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit
import MJRefresh

class BoardSwitchOrganViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var branchInfoBlock:((_ model: BoardBranchsoModel)->())?
    var dataArr: NSMutableArray = []
    var titleArr: NSArray = []
    var failureView: UIView?
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = ColorFromRGB(r: 245, g: 245, b: 245)
        self.title = "切换机构"
        self.titleArr = ["一级","二级","三级","四级"]
        
    }

    func creatSubViews() -> () {
        if (SCREEN_H == 812) {
            let bottomSafeView = UIView.init(frame: CGRect(x: 0, y: SCREEN_H - safeBottomH - safeNavH, width: SCREEN_W, height: 34))
            bottomSafeView.backgroundColor = UIColor.white
            self.view.addSubview(bottomSafeView)
        }
        
        tableView = UITableView.init(frame: CGRect(x: 10, y: 10, width: SCREEN_W-20, height: SCREEN_H-safeBottomH-safeNavH-10-10))
        tableView = UITableView.init(frame: CGRect(x: 10, y: 10, width: SCREEN_W-20, height: SCREEN_H-safeBottomH-safeNavH-10-10), style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.rowHeight = 50;
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none;
        tableView?.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView!)
        
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadPageData))
        tableView?.mj_header = header
        self.loadPageData()
    }
    
    @objc func loadPageData() -> () {
        
        if (failureView != nil) {
            failureView?.removeFromSuperview()
            failureView = nil;
        }
        
      
        let branchCode = OABoardBranchInfoManager.sharedBranchInfoManager.firstBranchCode
        
        if (branchCode.count == 0) {
            self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1")
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
            return;
        }
        
        let key = "branchInfo"
        let params = ["brancePara" : branchCode, "flagPara" : "0"]
        
        RequestTool.sharedInstance.getInsuranceperformanceDataWithKey(key: key, params: params as NSDictionary) { (resultData: HttpResultModel) in
            if resultData.result! {
                if KgetResultFlag(data: resultData.data as! NSDictionary) {
                    self.dataArr.removeAllObjects()
                    
                    let dataDic = KgetResultParam(data: resultData.data!, key: key)
                    let bodyArr = dataDic["body"] as! [[String: AnyObject]]
                    
                    if dataDic.allKeys.count == 0 || bodyArr.count == 0 {
                        self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1")
                        self.tableView?.reloadData()
                        self.tableView?.mj_header.endRefreshing()
                        return;
                    }
                    
                    let code: String = dataDic["code"] as! String
                    if (code == "Y") {
                        for dict in bodyArr {
                            let model = BoardInfoModel.dictToModel(dic: dict)
                            self.dataArr.add(model)
                        }
                    
                    } else {  //code=N
                        self.showRequestFailureViewWithTitle(title: "暂无数据", imageName: "OAUIKit.bundle/NoData1")
                    }
                    
                } else { //flag=N
                    
                    self.showRequestFailureViewWithTitle(title: KgetResultMessage(data: resultData.data as! NSDictionary), imageName: "OAUIKit.bundle/NoNetwork")
                }
            } else { //result=nil;
                self.showRequestFailureViewWithTitle(title: resultData.message!, imageName: "OAUIKit.bundle/NoNetwork")
            }
            
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
        }
        
    }
    
    func showRequestFailureViewWithTitle(title: String, imageName: String) -> () {

        failureView = UIView(frame: CGRect(x: 0, y: (SCREEN_H-safeNavH-150*ADAPTATION_WITH_WIDTH)/2.0, width: SCREEN_W, height: 150*ADAPTATION_WITH_WIDTH), title: title, imageName: imageName)
        
        self.view.addSubview(failureView!)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView.init();
        footView.backgroundColor = UIColor.clear
        return footView;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardTableViewCell.cellWithTableView(tableView: tableView, styleNum: boardVCtype.pipPerformance.rawValue)
        cell.contentLab?.isHidden = true
        
        
        let model = self.dataArr[indexPath.section] as! BoardInfoModel
        if indexPath.row == 0 {
            cell.titleLab?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.titleLab?.text = self.titleArr[NSInteger(model.branchLevel)!-1] as? String
            cell.isUserInteractionEnabled = false
        } else {
            cell.titleLab?.font = UIFont.systemFont(ofSize: 16)
            let branchs = model.branchs
            let branchsoModel = branchs[indexPath.row - 1]
            cell.titleLab?.text = branchsoModel.branchName
            cell.titleLab?.setOA_width(oa_width: width(object: tableView)-20)
        }
   
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let model = self.dataArr[indexPath.section] as! BoardInfoModel
            let branchs = model.branchs
            let branchsoModel = branchs[indexPath.row - 1]
            self.branchInfoBlock!(branchsoModel)
            self.navigationController?.popViewController(animated: true)
            
        }
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
