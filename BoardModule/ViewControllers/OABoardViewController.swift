//
//  OABoardViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/12.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit

class OABoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView?
    var dataArr: NSMutableArray! = nil
    var scrollView: UIScrollView?
    var segmentedControl: UISegmentedControl?
    var segCtitleArr: NSArray?
    var selectImgArr: NSArray?
    var deptTypeParams: NSArray?
    
    var timeLab: UILabel?
    var unitLab: UILabel?
    var titleLab: UILabel?
    var bottomLeftView: UIView?
    var bottomRightView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    var failureView: UIView?
    var isOpenArr: NSMutableArray! = nil
    var channelArr: NSArray?
    
    var branchCode: String?
    
    
    var isDetail: Bool?
    var isOPEN_today: Bool?
    var isOPEN_tomorary: Bool?
    var isOPEN_total: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
      
        self.edgesForExtendedLayout = UIRectEdge.all
//        self.automaticallyAdjustsScrollViewInsets = false
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "切换机构", style: .plain, target: self, action: #selector(switchMechanism))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange;
        
        self.channelArr = ["个险","传统","招证","经代"];
        self.segCtitleArr = ["个险总汇", "个险明细","传统总汇", "传统明细","招证总汇", "招证明细","经代总汇", "经代明细"];
        
        let dic = ["isOPEN_today":true,"isOPEN_tomorary":false,"isOPEN_total":false];
        let isOpendic = NSMutableDictionary.init(dictionary: dic)
        
        self.isOpenArr = NSMutableArray.init(array: [isOpendic, isOpendic, isOpendic, isOpendic])

        self.creatSubViews()
        
    }
    
    func creatSubViews() -> () {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 500), style: .plain)
        self.view .addSubview(self.tableView!)
    }
    
    @objc func switchMechanism() -> () {
        self.branchCode = "dddd"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
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

