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
        
        let promptController = UIAlertController(title: "业绩看板", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if (usernameTextField?.text)!.count == 0 || (passwordTextField?.text)!.count == 0 {
                self.loginRequestData(name: "zhangs", password: "Rhl@201805")
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
    
    func loginRequestData(name: String, password: String) -> () {
        RequestTool.sharedInstance.loginRequestData(user: name, password: password, deviceId: "") { (resultData) in
            if (resultData.result)! {
                self.navigationController?.pushViewController(OABoardViewController(), animated: true)
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

