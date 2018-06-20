//
//  ViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/11.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit
//import CMCore

class ViewController: UIViewController {
    
    var isLogin: Bool = false
    var boardVC: UIViewController?
    
    override func viewDidLoad() {
        var usernameTextField: UITextField?
        var passwordTextField: UITextField?
        
        let promptController = UIAlertController(title: "业绩看板", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if (usernameTextField?.text)!.count == 0 || (passwordTextField?.text)!.count == 0 {
                self.loginRequestData(name: "lil002", password: "Abcd1234")
            } else {
                self.loginRequestData(name: (usernameTextField?.text)!, password: (passwordTextField?.text)!)
            }
        })
        
        promptController.addAction(ok)
        promptController.addTextField { (textField) -> Void in
            usernameTextField = textField
        }
        promptController.addTextField { (textField) -> Void in
            passwordTextField = textField
        }
        self.present(promptController, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.isLogin {
            self.navigationController?.pushViewController(self.boardVC!, animated: true)
        }
    }
    
    func loginRequestData(name: String, password: String) -> () {
        // Alamofire
//        RequestTool.sharedInstance.loginRequestData(user: name, password: password, deviceId: "") { (resultData) in
//            if (resultData.result)! {
//                self.navigationController?.pushViewController(OABoardViewController(), animated: true)
//            } else {
//                print("message=\(String(describing: resultData.message))")
//            }
//        }
        
        
        OABoardHTTPManager.shared().loginRequestData(withUser: name, password: password, deviceId: "") { (resultData) in
            if (resultData?.result)! {
                self.isLogin = true
                let service = CMService(OABoardModule.self, OABoardService.self) as! OABoardService
                self.boardVC = service.boardViewController
                self.navigationController?.pushViewController(self.boardVC!, animated: true)
            } else {
                print("loginError=\(String(describing: resultData?.message))")
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

