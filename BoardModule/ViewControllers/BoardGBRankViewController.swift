//
//  BoardGBRankViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/15.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

class BoardGBRankViewController: OABoardViewController {

    var isDetail: Bool = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.childVCnum = childVCType.gbRank.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("isDetail===\(isDetail)")
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView.init();
        footView.backgroundColor = UIColor.clear
        return footView;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardTableViewCell.cellWithTableView(tableView: tableView, styleNum: boardVCtype.pipPerformance.rawValue)
        cell.backgroundColor = UIColor.red
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
