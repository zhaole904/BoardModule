//
//  OABoardTableViewCell.swift
//  BoardModule
//
//  Created by 赵乐 on 2018/6/15.
//  Copyright © 2018年 乐哥. All rights reserved.
//

import UIKit

enum boardVCtype: NSInteger {
    case pipPerformance
    case gbRank
    case productMix
}

class OABoardTableViewCell: UITableViewCell {

    var titleLab: UILabel?
    var contentLab: UILabel?
    var lineLab: UILabel?
    var midLab: UILabel?
    static var typeNum: NSInteger = 0

    /// 自定义cell的类型
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - styleNum: boardVCtype--cell的类型
    /// - Returns: 返回的cell
    class func cellWithTableView(tableView:UITableView, styleNum:NSInteger) -> OABoardTableViewCell {
        let str = NSStringFromClass(OABoardTableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: str)
        typeNum = styleNum
        
        if cell == nil {
            cell = OABoardTableViewCell.init(style: .default, reuseIdentifier: str)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        return cell! as! OABoardTableViewCell
    }
    
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
        let w = (SCREEN_W-20-20*2)/3
        self.contentView.frame = CGRect(x: 0, y: 0, width: SCREEN_W-20, height: 0)
        titleLab = UILabel.init(frame: CGRect(x: 20, y: 0, width: w*2, height: 49))
        titleLab?.font = UIFont.systemFont(ofSize: 16)
        titleLab?.textColor = ColorFromRGB(r: 51, g: 51, b: 51)
        self.contentView.addSubview(titleLab!)
        
        contentLab = UILabel.init(frame: CGRect(x: 20+2*w, y: 0, width: w, height: 49))
        contentLab?.font = UIFont.systemFont(ofSize: 16)
        contentLab?.textColor = ColorFromRGB(r: 51, g: 51, b: 51)
        contentLab?.textAlignment = .right
        self.contentView.addSubview(contentLab!)
        
        lineLab = UILabel.init(frame: CGRect(x: 20, y: 0, width: self.contentView.frame.size.width - 40, height: 1))
        lineLab?.backgroundColor = ColorFromRGB(r: 245, g: 245, b: 245)
        self.contentView.addSubview(lineLab!)
        
        if OABoardTableViewCell.typeNum != boardVCtype.pipPerformance.rawValue {
           
            titleLab?.width = w
            midLab = UILabel.init(frame: CGRect(x: (titleLab?.rightX)!, y: 0, width: w, height: 49))
            midLab?.font = UIFont.systemFont(ofSize: 16)
            midLab?.textColor = ColorFromRGB(r: 51, g: 51, b: 51)
            midLab?.textAlignment = .center
            self.contentView.addSubview(midLab!)
            
            contentLab?.frame = CGRect(x: self.contentView.frame.size.width-20-40, y: 0, width: 40, height: 49)
            contentLab?.textAlignment = .center
        }
    }
    
    func refreshModel(model: OABoardModel, indexPath: IndexPath, btnTag: NSInteger, isDetail: Bool) -> () {
        if (OABoardTableViewCell.typeNum == boardVCtype.gbRank.rawValue) {  /// 规保排名
            if (indexPath.section == 0) {
                self.setDataToRowViewWith(title: model.branchName, content: model.scalePremRankD, midContent: model.scalePremD)
            } else if (indexPath.section == 1) {
                self.setDataToRowViewWith(title: model.branchName, content: model.scalePremRankM, midContent: model.scalePremM)
            } else if (indexPath.section == 2) {
                self.setDataToRowViewWith(title: model.branchName, content: model.scalePremRankY, midContent: model.scalePremY)
            }
        } else if (OABoardTableViewCell.typeNum == boardVCtype.productMix.rawValue) { /// 产品结构
            if (indexPath.section == 0 ) {
                self.setDataToRowViewWith(title: model.productName, content: model.productRateM, midContent: model.scalePremM)
            } else if (indexPath.section == 1) {
                self.setDataToRowViewWith(title: model.productName, content: model.productRateY, midContent: model.scalePremY)
            }
            
        } else {
            if (isDetail) {  /// 个险明细
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        self.setDataToRowViewWith(title: "规保保费", content: model.scalePremD, unit: "万")
                    } else if (indexPath.row == 1) {
                        self.setDataToRowViewWith(title: "规保件数", content: model.scaleCountD, unit: "件")
                    } else if (indexPath.row == 2) {
                        self.setDataToRowViewWith(title: "暂收保费", content: model.tmpSumD, unit: "万")
                    } else if (indexPath.row == 3) {
                        self.setDataToRowViewWith(title: "暂收件数", content: model.tmpCountD, unit: "件")
                    }
                } else if (indexPath.section == 1) {
                    if (indexPath.row == 0) {
                        self.setDataToRowViewWith(title: "规保保费", content: model.scalePremLastD, unit: "万")
                    } else if (indexPath.row == 1) {
                        self.setDataToRowViewWith(title: "规保件数", content: model.scaleCountLastD, unit: "件")
                    } else if (indexPath.row == 2) {
                        self.setDataToRowViewWith(title: "暂收保费", content: model.tmpSumLastD, unit: "万")
                    } else if (indexPath.row == 3) {
                        self.setDataToRowViewWith(title: "暂收件数", content: model.tmpCountLastD, unit: "件")
                    }
                } else {
                    if (indexPath.row == 0) {
                        self.setDataToRowViewWith(title: "规保保费", content: model.scalePremY, unit: "万")
                    } else if (indexPath.row == 1) {
                        self.setDataToRowViewWith(title: "规保件数", content: model.scaleCountY, unit: "件")
                    } else if (indexPath.row == 2) {
                        self.setDataToRowViewWith(title: "暂收保费", content: model.tmpSumY, unit: "万")
                    } else if (indexPath.row == 3) {
                        self.setDataToRowViewWith(title: "暂收件数", content: model.tmpCountY, unit: "件")
                    } else if (indexPath.row == 4) {
                        self.setDataToRowViewWith(title: "（5天）未生效保费", content: model.effectPremY5, unit: "万")
                    }
                }
            } else {  /// 个险总汇
                if (OABoardTableViewCell.typeNum == boardVCtype.pipPerformance.rawValue) {
                    
                    if (indexPath.row == 0) {
                        self.titleLab?.text = "本年规保达成率"
                        self.contentLab?.text = String(format: "%@%%", model.achievRateY)
                    } else if (indexPath.row == 1) {
                        self.titleLab?.text = "本日规保"
                        self.contentLab?.text = String(format: "%@万", model.scalePremD.isEmpty ? "0" : model.scalePremD)
                    } else if (indexPath.row == 2) {
                        if (btnTag < 2) {
                            self.titleLab?.text = "本日实动人力"
                            self.contentLab?.text = String(format: "%@人", model.actualAgentCntD.isEmpty ? "0" : model.actualAgentCntD)
                        } else {
                            self.titleLab?.text = "本日活动人力";
                            self.contentLab?.text = String(format: "%@人", model.activiAgentCntD.isEmpty ? "0" : model.activiAgentCntD)
                            
                        }
                        
                    } else if (indexPath.row == 3) {
                        self.titleLab?.text = "本月规保"
                        self.contentLab?.text = String(format: "%@万", model.scalePremM.isEmpty ? "0" : model.scalePremM)
    
                    } else if (indexPath.row == 4) {
                        if (btnTag < 2) {
                            self.titleLab?.text = "本月实动率"
                            self.contentLab?.text = String(format: "%@%%", model.actualAgentRateM.isEmpty ? "0" : model.actualAgentRateM)
                        } else {
                            self.titleLab?.text = "本年规保"
                            self.contentLab?.text = String(format: "%@万", model.scalePremY.isEmpty ? "0" : model.scalePremY)
                        }
                        
                    } else if (indexPath.row == 5) {
                        if (btnTag < 2) {
                            self.titleLab?.text = "本年规保"
                            self.contentLab?.text = String(format: "%@万", model.scalePremY.isEmpty ? "0" : model.scalePremY)
                        }
                    } else if (indexPath.row == 6) {
                        if (btnTag < 2) {
                            self.titleLab?.text = "本年月均实动率"
                            self.contentLab?.text = String(format: "%@%%", model.actualAgentRateY.isEmpty ? "0" : model.actualAgentRateY)
                        }
                    }
                }
            }
        }
    }
    
    /// 个险明细
    func setDataToRowViewWith(title: String, content: String, unit:String) -> () {
        self.titleLab?.text = title
        
        var contentt = content
        if (content == unit || content.count == 0) {
            contentt = "0";
        }
        
        if (unit.count > 0) {
            self.contentLab?.text = String(format: "%@%@", contentt,unit)
        } else {
            self.contentLab?.text = String(format: "%@%%", contentt)
        }
    }
    
    /// 规保排名 产品结构
    func setDataToRowViewWith(title: String, content: String, midContent: String) -> () {
        let contentt = (content == "%" ? "0%" : content)
        self.titleLab?.text = title
        self.midLab?.text = midContent
        
        if (OABoardTableViewCell.typeNum == boardVCtype.gbRank.rawValue) {
            self.contentLab?.text = contentt
        } else {
            self.contentLab?.text = contentt + "%"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
