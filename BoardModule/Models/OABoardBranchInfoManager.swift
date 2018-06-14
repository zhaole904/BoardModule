//
//  OABoardBranchInfoManager.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/14.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit

class OABoardBranchInfoManager: NSObject {

    var branchName: String = ""
    var branchCode: String = ""
    var firstBranchCode: String = ""
    var flagPara: String = ""
    
    var defaultBranchDic: NSMutableDictionary = [:]
    var gbRankBranchDic: NSMutableDictionary = [:]
    var productMixBranchDic: NSMutableDictionary = [:]
    
    var isGborProduct: Bool = false
    
    // 单列
    static let sharedBranchInfoManager = OABoardBranchInfoManager()
}
