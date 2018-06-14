//
//  BoardInfoModel.swift
//  BoardModule
//
//  Created by 乐哥 on 2018/6/14.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

class BoardBranchsoModel: NSObject {
    var branchName: String = ""
    var branchCode: String = ""
}

class BoardInfoModel: NSObject {
    var branchLevel: String = ""
    var branchs: [BoardBranchsoModel] = []
}
