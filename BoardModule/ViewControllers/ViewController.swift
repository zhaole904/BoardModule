//
//  ViewController.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/11.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.orange;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var usernameTextField: UITextField?
        var passwordTextField: UITextField?
        
        let promptController = UIAlertController(title: "Username", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if (usernameTextField?.text)! == "" || (passwordTextField?.text)! == "" {
                self.loginRequestData(name: "lil002", password: "Abcd1234")
            } else {
                self.loginRequestData(name: (usernameTextField?.text)!, password: (passwordTextField?.text)!)
            }
            
            
        })
        _ = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        promptController.addAction(ok)
        promptController.addTextField { (textField) -> Void in
            usernameTextField = textField
        }
        promptController.addTextField { (textField) -> Void in
            passwordTextField = textField
        }
        self.present(promptController, animated: true, completion: nil)
        
    }
    
    func getUserLimitBranchData(key: String) -> () {
        RequestTool.sharedInstance.getInsuranceperformanceDataWithKey(key: key, params: ["brancePara":"-1"], completion: { (resultData) in
            if (resultData.result)! {
                print("respones1=\(String(describing: resultData.data))")
            } else {
                print("message1=\(String(describing: resultData.message))")
            }
        })
    }
    
    func loginRequestData(name: String, password: String) -> () {
        RequestTool.sharedInstance.loginRequestData(user: name, password: password, deviceId: "") { (resultData) in
            if (resultData.result)! {
                print("respones=\(String(describing: resultData.data))")
                self.navigationController?.pushViewController(OABoardViewController(), animated: true)
                //                self.getUserLimitBranchData(key: "userLimitBranch")
                
            } else {
                print("message=\(String(describing: resultData.message))")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

