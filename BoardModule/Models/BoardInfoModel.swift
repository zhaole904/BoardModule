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
    
    class func dictToModel(dic:[String: AnyObject]) -> BoardInfoModel {
        let model = BoardInfoModel(dict: dic)
        return model
    }
    
    //MARK:- KVC
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "actualAgentRateY" {
            print("actualAgentRateY---\(value ?? "00001")")
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("---forUndefinedKey---\(key)值为空")
    }
    
    //MARK:- 数组转model
    class func listToModel(list:[[String: AnyObject]]) -> [BoardInfoModel] {
        
        var models = [BoardInfoModel]()
        for dict in list {
            models.append(BoardInfoModel(dict: dict))
        }
        return models
    }
}
