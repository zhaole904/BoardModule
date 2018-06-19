//
//  BoardInfoModel.swift
//  BoardModule
//
//  Created by 乐哥 on 2018/6/14.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

@objcMembers
class BoardBranchsoModel: NSObject {
    var branchName: String = ""
    var branchCode: String = ""
    
    //MARK:- KVC
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("----soModel--forUndefinedKey---\(key)值为空")
    }
    
}

@objcMembers
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
//        setValuesForKeys(dict)
       
        self.branchLevel = dict["branchLevel"] as! String
        if let list = dict["branchs"] as? [[String : Any]] {
            for obj in list {
                let soModel = (BoardBranchsoModel(dict: obj))
                self.branchs.append(soModel)
            }
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("---InfoModel--forUndefinedKey---\(key)值为空")
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
