//
//  RequestTool.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/12.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit
import Alamofire

enum RequestMethod {
    case RequestMethodGET
    case RequestMethodPOST
}

class RequestTool: NSObject {
    
    var baseUrl:String = "https://gw.cmrh.com"
    var baseParams:NSMutableDictionary = [:]
    
    // 单列
    static let sharedInstance = RequestTool()
    
    // 单列
    //    static let tools: RequestTool = {
    //        let tool = RequestTool()
    //        tool.baseUrl = "https://gw.cmrh.com"
    //        return tool
    //    }()
    //
    //    class func sharedInstance() -> RequestTool {
    //        return tools
    //    }
    
    //MARK:获取请求方式
    func getHttpMethod(method:RequestMethod) -> HTTPMethod {
        if method == .RequestMethodPOST {
            return .post
        } else {
            return .get
        }
    }
    
    //MARK:拼接完整的url
    func getcCompleteUrl(url:String) -> String {
        let newUrl = self.baseUrl.appending(url)
        return newUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    //MARK:拼接完整的参数
    func CombinationParams(params:NSDictionary) -> NSDictionary {
        self.baseParams.addEntries(from:params as! [AnyHashable : Any])
        return self.baseParams
    }
    
    func POST(url:String,params:[String: Any],completion:@escaping (HttpResultModel)->()) -> Void {
        print("params==\(params)")
        
        Alamofire.request(url, method:.post, parameters: params, encoding: JSONEncoding.default) .responseJSON { response in
            
            let dataDic = response.result.value as! [String : AnyObject]
            
            switch(response.result) {
            case .success(_):
                
                let httpResult: HttpResultModel =  self.requrstSuccessWithResponse(httpResponse:response.response!, responseObject: dataDic as AnyObject)
                
                if httpResult.result == true {
                    //                    print("Success==\(String(describing: httpResult.data))---\(String(describing: httpResult.statusCode))")
                } else {
                    print("Failure==\(String(describing: httpResult.data))---\(String(describing: httpResult.statusCode))")
                }
                completion(httpResult)
                
            case .failure(_):
                let httpResult = HttpResultModel.init()
                httpResult.response = response.response!;
                httpResult.result = false;
                httpResult.message = "网络异常，请稍后再试";
                httpResult.statusCode = response.response!.statusCode;
                httpResult.data = nil;
                completion(httpResult)
                break
            }
        }
    }
    
    func requrstSuccessWithResponse(httpResponse: HTTPURLResponse, responseObject: AnyObject) -> HttpResultModel {
        let httpResult = HttpResultModel.init()
        httpResult.response = httpResponse
        
        if httpResponse.statusCode == 200 {
            let error: Error? = nil
            if (error != nil) {
                httpResult.result = false;
                httpResult.message = "服务器异常(200)";
                httpResult.statusCode = httpResponse.statusCode;
                httpResult.data = nil;
            } else {
                httpResult.result = true;
                httpResult.message = "请求成功";
                httpResult.statusCode = httpResponse.statusCode;
                httpResult.data = responseObject;
            }
        } else {
            httpResult.result = false;
            httpResult.message = "服务器异常，请稍后再试";
            httpResult.statusCode = httpResponse.statusCode;
            httpResult.data = nil;
        }
        return httpResult
    }
    
    
    func loginRequestData(user:String, password:String, deviceId:String, completion:@escaping (HttpResultModel)->()) -> Void {
        let parameters = [
            "action": "login",
            "params": [
                "RF-DEVICE-ID": deviceId,
                "password": password,
                "username": user]
            ] as [String : Any]
        
        self.POST(url: self.getcCompleteUrl(url: "/login"), params: parameters) { (backResult) in
            completion(backResult)
        }
    }
    
    func getInsuranceperformanceDataWithKey(key:String, params:NSDictionary, completion:@escaping (HttpResultModel)->()) -> Void {
        
        self.POST(url: self.getcCompleteUrl(url: "/RH_MAS/bus/v1.0/stmmp/report/\(key)"), params: params as! [String : Any]) { (backResult) in
            completion(backResult)
        }
    }
}


class HttpResultModel: NSObject {
    var response: HTTPURLResponse?
    var result: Bool?
    var statusCode: NSInteger?
    var message: String?
    var data: AnyObject?
}

