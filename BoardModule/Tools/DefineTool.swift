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


/// 网络请求返回的数据
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



/// UIView的扩展
extension UIView {
    /// 网络请求加载失败的占位图
    convenience init(frame: CGRect, title: String, imageName: String) {
        self.init(frame: frame)
        let failureView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 150*ADAPTATION_WITH_WIDTH))
        self.addSubview(failureView)
        
        let imageV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 105*ADAPTATION_WITH_WIDTH))
        imageV.image = UIImage.init(named: imageName)
        imageV.contentMode = .scaleAspectFit
        failureView.addSubview(imageV)
        
        let titleLab = UILabel.init(frame: CGRect(x: 0, y: imageV.bottomY + 25*ADAPTATION_WITH_WIDTH, width: SCREEN_W, height: 20*ADAPTATION_WITH_WIDTH))
        titleLab.text = title;
        titleLab.textColor =  ColorFromRGB(r: 0xA1, g: 0xA1, b: 0xA1)
        
        titleLab.font = UIFont.systemFont(ofSize: 14*ADAPTATION_WITH_WIDTH)
        titleLab.textAlignment = .center;
        failureView.addSubview(titleLab)
    }
    
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    
    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
}
