//
//  BoardModel.swift
//  BoardModule
//
//  Created by 乐哥 on 2018/6/14.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

@objcMembers
class BoardModel: NSObject {
    /* 个人总汇*/
    
    //本年月均实动率
    var actualAgentRateY: String = ""
    
    //本日实动人力
    var activiAgentCntD: String = ""
    
    //本月活动率
    var activiAgentRateM: String = ""
    
    //本月实动率
    var actualAgentRateM: String = ""

    //本日活动人力
    var actualAgentCntD: String = ""

    //本年月均活动率
    var activiAgentRateY: String = ""

    //本日规保（总汇）   规模保费_本日（明细） 规模保费_本日（排名）
    var scalePremD: String = ""

    //本年规保（总汇）   规模保费_累计（明细）  规模保费_本年（排名） 规模保费_本年（产品结构）
    var scalePremY: String = ""

    //本年规保达成率
    var achievRateY: String = ""

    //本月规保  规模保费_本月（排名）   规模保费_本月（产品结构）
    var scalePremM: String = ""

    
    /* 个人明细*/
    
    //（5天）未生效保费
    var effectPremY5: String = ""

    //规模件数_本日
    var scaleCountD: String = ""

    //规模件数_昨日
    var scaleCountLastD: String = ""

    //规模件数_累计
    var scaleCountY: String = ""

    //规模保费_昨日
    var scalePremLastD: String = ""

    //暂收件数_本日
    var tmpCountD: String = ""

    //暂收件数_昨日
    var tmpCountLastD: String = ""

    //暂收件数_累计
    var tmpCountY: String = ""

    //暂收保费_本日
    var tmpSumD: String = ""

    //暂收保费_昨日
    var tmpSumLastD: String = ""
 
    //暂收保费_累计
    var tmpSumY: String = ""
 
    
    /* 排名*/
    
    //机构名称
    var branchName: String = ""

    //规保排名_本日
    var scalePremRankD: String = ""

    //规保排名_本月
    var scalePremRankM: String = ""

    //规保排名_本年
    var scalePremRankY: String = ""

    
    /* 产品结构*/
    
    //产品名称
    var productName: String = ""
 
    //产品占比_本月
    var productRateM: String = ""

    //产品占比_本年
    var productRateY: String = ""
    
    
    class func dictToModel(dic:[String: AnyObject]) -> BoardModel {
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
        if key == "actualAgentRateY" {
            print("actualAgentRateY---\(value ?? "00001")")
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("---forUndefinedKey---\(key)值为空")
    }
    
    //MARK:- 数组转model
    class func listToModel(list:[[String: AnyObject]]) -> [BoardModel] {
        
        var models = [BoardModel]()
        for dict in list {
            models.append(BoardModel(dict: dict))
        }
        return models
    }

//    var properties = ["actualAgentRateM","actualAgentCntD","activiAgentRateY"]
//    // 输出的是对象的地址，重写此方法，打印各属性
//    override var description: String {
//        let dict = dictionaryWithValues(forKeys: properties)
//        return "properties=\(dict)"
//    }
}
