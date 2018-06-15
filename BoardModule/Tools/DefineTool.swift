//
//  DefineTool.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/13.
//  Copyright © 2018年 赵乐. All rights reserved.
//

import UIKit

let SCREEN_W = UIScreen.main.bounds.width
let SCREEN_H = UIScreen.main.bounds.height
let safeBottomH: CGFloat = (SCREEN_H == 812.0 ? 34.0 : 0.0)
let safeNavH: CGFloat  = (SCREEN_H == 812.0 ? 88.0 : 64.0)
let ADAPTATION_WITH_WIDTH = SCREEN_W/375


func KgetResultFlag(data: NSDictionary) -> (Bool) {
    if (data["flag"] as! String) == "Y" {
        return true
    } else {
        return false
    }
}

func KgetResultMessage(data: NSDictionary) -> (String) {
    return data["message"] as! String
}

func KgetResultParam(data: AnyObject, key: String) -> (NSDictionary) {
    return (data["param"] as! NSDictionary)[key] as! NSDictionary
}

func ColorFromRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> (UIColor) {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}

func ColorFromRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> (UIColor) {
    return ColorFromRGBA(r: r/255.0, g: g/255.0, b: b/255.0, a: 1.0)
}

func originx(object: UIView) -> CGFloat {
    return object.frame.origin.x
}

func originy(object: UIView) -> CGFloat {
    return object.frame.origin.y
}

func width(object: UIView) -> CGFloat {
    return object.frame.size.width
}

func height(object: UIView) -> CGFloat {
    return object.frame.size.height
}

func top(object: UIView) -> CGFloat {
    return originy(object: object)
}

func bottom(object: UIView) -> CGFloat {
    return height(object: object) + originy(object: object)
}

func left(object: UIView) -> CGFloat {
    return originx(object: object)
}

func right(object: UIView) -> CGFloat {
    return left(object: object) + width(object: object)
}

func centerX(object: UIView) -> CGFloat {
    return object.center.x
}

func centerY(object: UIView) -> CGFloat {
    return object.center.y
}


extension UIView {
    convenience init(frame: CGRect, title: String, imageName: String) {
        self.init()
        let failureView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 150*ADAPTATION_WITH_WIDTH))
        self.addSubview(failureView)
        let imageV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 105*ADAPTATION_WITH_WIDTH))
        imageV.image = UIImage.init(named: imageName)
        imageV.contentMode = .scaleAspectFit
        
        let titleLab = UILabel.init(frame: CGRect(x: 0, y: bottom(object: imageV)+25*ADAPTATION_WITH_WIDTH, width: SCREEN_W, height: 20*ADAPTATION_WITH_WIDTH))
        titleLab.text = title;
        titleLab.textColor =  ColorFromRGB(r: 0xA1, g: 0xA1, b: 0xA1)
        
        titleLab.font = UIFont.systemFont(ofSize: 14*ADAPTATION_WITH_WIDTH)
        titleLab.textAlignment = .center;
        failureView.addSubview(titleLab)
    }
    
    func setOA_width(oa_width: CGFloat) -> () {
        var frame = self.frame
        frame.size.width = oa_width
        self.frame = frame
    }
    
}
