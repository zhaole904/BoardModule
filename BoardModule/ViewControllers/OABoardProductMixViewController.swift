//
//  OABoardProductMixViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/15.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

class OABoardProductMixViewController: OABoardViewController {

    private var isOPEN_month: Bool = false
    private var isOPEN_year: Bool = false
    private var isOPEN_total: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.childVCnum = childVCType.productMix.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isRequestSuccess = false
        let dic = ["isOPEN_month": true, "isOPEN_year": true]
        let isOpendic = NSMutableDictionary.init(dictionary: dic)
        self.isOpenArr = NSMutableArray.init(array: [isOpendic, isOpendic, isOpendic, isOpendic])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (!self.isRequestSuccess) {
            return 0;
        } else {
            return 2;
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!self.isRequestSuccess) {
            return 0;
        } else {
            let dic = self.isOpenArr[self.btnTag] as! NSDictionary
            self.isOPEN_month = dic["isOPEN_month"] as! Bool
            self.isOPEN_year = dic["isOPEN_year"] as! Bool
            
            if (section == 0) {
                return self.isOPEN_month ? self.dataArr.count+1 : 0
            } else {
                return self.isOPEN_year ? self.dataArr.count+1 : 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 0
        } else {
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView.init();
        footView.backgroundColor = UIColor.clear
        return footView;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W-20, height: 50))
        headerView.backgroundColor = UIColor.white
        
        let titleLab = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 49))
        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        headerView.addSubview(titleLab)
        
        let btn = UIButton(frame: CGRect(x: headerView.width - 60, y: 0, width: 60, height: 50))
        btn.tag = section
        btn.addTarget(self, action: #selector(sectionBtnClickProduct(btn:)), for: .touchUpInside)
        headerView.addSubview(btn)
        
        let btnImageV = UIImageView(frame: CGRect(x: 15, y: 20, width: 30, height: 10))
        btnImageV.image = UIImage.init(named: "OABoardUI.bundle/pip_more")
        btnImageV.contentMode = .scaleAspectFit;
        
        if (section == 0 && self.isOPEN_month) {
            btnImageV.image = UIImage.init(named: "OABoardUI.bundle/pip_less")
        } else if (section == 1 && self.isOPEN_year) {
            btnImageV.image = UIImage.init(named: "OABoardUI.bundle/pip_less")
        }
        btn.addSubview(btnImageV)
        
        if (section == 0) {
            titleLab.text = "当月规保"
        } else if (section == 1) {
            titleLab.text = "当年规保"
        }

        return headerView;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OABoardTableViewCell.cellWithTableView(tableView: tableView, styleNum: boardVCtype.productMix.rawValue)
        cell.contentLab?.frame = CGRect(x: tableView.width-20-100, y: 0, width: 100, height: 49)
        cell.contentLab?.textAlignment = .right
        
        if ( indexPath.row == 0) {
            cell.titleLab?.text = "产品名称"
            cell.midLab?.text = "规保"
            cell.contentLab?.text = "占比"
            cell.titleLab?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.midLab?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.contentLab?.font = UIFont.boldSystemFont(ofSize: 16)
            
        } else {
            if (self.dataArr.count > 0) {
                if indexPath.section == 0 {
                    let sortDescriptor = NSSortDescriptor.init(key: "productRateM", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
                    self.dataArr .sortedArray(using: [sortDescriptor])
                    
                } else {
                    let sortDescriptor = NSSortDescriptor.init(key: "productRateY", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
                    self.dataArr .sortedArray(using: [sortDescriptor])
                }
                
                let model = self.dataArr[indexPath.row-1]
                cell.titleLab?.numberOfLines = 0
                cell.titleLab?.font = UIFont.systemFont(ofSize: 16)
                cell.midLab?.font = UIFont.systemFont(ofSize: 16)
                cell.contentLab?.font = UIFont.systemFont(ofSize: 16)
                
                cell.refreshModel(model: model as! OABoardModel, indexPath: indexPath, btnTag: 0, isDetail: false)
                
            }
        }
        return cell
    }
    
    @objc func sectionBtnClickProduct(btn: UIButton) -> () {
        btn.isSelected = !btn.isSelected
        if (btn.tag == 0) {
            self.isOPEN_month = !self.isOPEN_month
        } else if (btn.tag == 1) {
            self.isOPEN_year = !self.isOPEN_year
        }
        
        let dic = NSMutableDictionary.init(dictionary: self.isOpenArr[btn.tag] as! NSDictionary)
        dic.setValue(self.isOPEN_month, forKey: "isOPEN_month")
        dic.setValue(self.isOPEN_year, forKey: "isOPEN_year")
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
