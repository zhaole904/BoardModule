//
//  BoardModel.swift
//  BoardModule
//
//  Created by 乐哥 on 2018/6/14.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

class BoardModel: NSObject {
    /* 个人总汇*/
    
    //本年月均实动率
    var actualAgentRateY: NSString = ""
    
    //本日实动人力
    var activiAgentCntD: NSString = ""
    
    //本月活动率
    var activiAgentRateM: NSString = ""
    
    //本月实动率
    var actualAgentRateM: NSString = ""

    //本日活动人力
    var actualAgentCntD: NSString = ""

    //本年月均活动率
    var activiAgentRateY: NSString = ""

    //本日规保（总汇）   规模保费_本日（明细） 规模保费_本日（排名）
    var scalePremD: NSString = ""

    //本年规保（总汇）   规模保费_累计（明细）  规模保费_本年（排名） 规模保费_本年（产品结构）
    var scalePremY: NSString = ""

    //本年规保达成率
    var achievRateY: NSString = ""

    //本月规保  规模保费_本月（排名）   规模保费_本月（产品结构）
    var scalePremM: NSString = ""

    
    /* 个人明细*/
    
    //（5天）未生效保费
    var effectPremY5: NSString = ""

    //规模件数_本日
    var scaleCountD: NSString = ""

    //规模件数_昨日
    var scaleCountLastD: NSString = ""

    //规模件数_累计
    var scaleCountY: NSString = ""

    //规模保费_昨日
    var scalePremLastD: NSString = ""

    //暂收件数_本日
    var tmpCountD: NSString = ""

    //暂收件数_昨日
    var tmpCountLastD: NSString = ""

    //暂收件数_累计
    var tmpCountY: NSString = ""

    //暂收保费_本日
    var tmpSumD: NSString = ""

    //暂收保费_昨日
    var tmpSumLastD: NSString = ""
 
    //暂收保费_累计
    var tmpSumY: NSString = ""
 
    
    /* 排名*/
    
    //机构名称
    var branchName: NSString = ""

    //规保排名_本日
    var scalePremRankD: NSString = ""

    //规保排名_本月
    var scalePremRankM: NSString = ""

    //规保排名_本年
    var scalePremRankY: NSString = ""

    
    /* 产品结构*/
    
    //产品名称
    var productName: NSString = ""
 
    //产品占比_本月
    var productRateM: NSString = ""

    //产品占比_本年
    var productRateY: NSString = ""
    
    
    class func dictToModel(dic:[String: Any]) -> BoardModel {
        let model = BoardModel(dict: dic)
        return model
    }
    
    //MARK:- KVC
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
//        if key == "id" {
//            ID = value as! Int
//        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //MARK:- 数组转model
    class func listToModel(list:[[String: AnyObject]]) -> [BoardModel] {
        
        var models = [BoardModel]()
        for dict in list {
            models.append(BoardModel(dict: dict))
        }
        return models
    }
}
