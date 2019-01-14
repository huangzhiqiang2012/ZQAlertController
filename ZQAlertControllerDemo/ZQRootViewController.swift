//
//  ZQRootViewController.swift
//  ZQAlertControllerDemo
//
//  Created by Darren on 2018/12/30.
//  Copyright © 2018 Darren. All rights reserved.
//

import UIKit
import ZQAlertController

// MARK: 根控制器
class ZQRootViewController: UIViewController {
    
    // MARK: gett & setter
    fileprivate lazy var titlesArr:[String] = {
        let titlesArr:[String] = ["Normal", "Direction", "Blur background", "Custom ContentView", "Custom Animation"]
        return titlesArr
    }()
    
    fileprivate lazy var datasArr:[[String]] = {
        let titlesArr:[[String]] = [["Only title", "Only content", "Title and one button", "Title and two button", "Title and content", "Title content and one button", "Title content and two button", "AttributeStr", "Title too long", "Content too long"], ["Top", "Bottom", "Left", "Right", "Center"], ["Mask color", "BackGround Image", "Mask image"], ["ContentView with textField"], ["PageUnCurl and pageCurl", "Push and reveal"]]
        return titlesArr
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView:UITableView = UITableView.init(frame: view.bounds, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        return tableView
    }()
    
    fileprivate lazy var styleManager:ZQAlertStyleManager = {
        let styleManager:ZQAlertStyleManager = ZQAlertStyleManager.default
        return styleManager
    }()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: private
extension ZQRootViewController {
    fileprivate func setupView() -> Void {
        view.addSubview(tableView)
    }
    
    fileprivate func showAlertControllerNormal(row:Int) -> Void {
        switch row {
        case 0:
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Only title", message: nil)
            alert.showAlertController()
            
        case 1:
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: nil, message: "Only content")
            alert.showAlertController()
            
        case 2:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.blue
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title and one button", message:nil)
            alert.addButton(withTitle: "One button", type: .normal) {
                ZQLog(message: "--__--|| 点击了按钮")
            }
            alert.showAlertController()
            
        case 3:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.red
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            styleManager.cancelButtonStyle.backgroundColor = UIColor.red
            styleManager.cancelButtonStyle.highlightBackgroundColor = UIColor.blue
            styleManager.normalButtonStyle.textColor = UIColor.brown
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title and two button", message:nil)
            alert.addButton(withTitle: "Cancel", type: .cancel) {
                ZQLog(message: "--__--|| Cancel")
            }
            alert.addButton(withTitle: "OK", type: .normal) {
                ZQLog(message: "--__--|| OK")
            }
            alert.showAlertController()
            
        case 4:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.red
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title", message: "Content")
            alert.showAlertController()
            
        case 5:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.red
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title", message: "Content")
            alert.addButton(withTitle: "One button", type: .normal) {
                ZQLog(message: "--__--|| 点击了按钮")
            }
            alert.showAlertController()
            
        case 6:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.red
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title", message: "Content")
            alert.addButton(withTitle: "Cancel", type: .cancel) {
                ZQLog(message: "--__--|| Cancel")
            }
            alert.addButton(withTitle: "OK", type: .normal) {
                ZQLog(message: "--__--|| OK")
            }
            alert.showAlertController()
            
        case 7:
            let attachment = NSTextAttachment()
            attachment.image = UIImage(imageLiteralResourceName: "fire")
            var font = UIFont.boldSystemFont(ofSize: 20)
            let height = font.lineHeight
            attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            var tempStr:NSAttributedString = NSAttributedString(attachment: attachment)
            var attStr:NSMutableAttributedString = NSMutableAttributedString(string: "AttributedStr", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle])
            attStr.append(tempStr)
            styleManager.titleStyle.attributedStr = (attStr.copy() as! NSAttributedString)
            
            font = UIFont.systemFont(ofSize: 17)
            attStr = NSMutableAttributedString(string: "AttributedStr", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle])
            tempStr = NSAttributedString(string: "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈", attributes: [NSAttributedString.Key.foregroundColor:UIColor.brown, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle, NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue])
            attStr.append(tempStr)
            styleManager.contentStyle.attributedStr = (attStr.copy() as! NSAttributedString)
            
            let alert:ZQAlertController = ZQAlertController.alert(withTitle:"设置了也无效", message: "设置了也无效")
            alert.addButton(withTitle: "Cancel", type: .cancel) {
                ZQLog(message: "--__--|| Cancel")
            }
            alert.addButton(withTitle: "OK", type: .normal) {
                ZQLog(message: "--__--|| OK")
            }
            alert.showAlertController()
            
        case 8:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.titleStyle.textColor = UIColor.red
            styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
            styleManager.contentViewStyle.maxHeight = 300
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog Title too loog ", message: "设置了也无效")
            alert.addButton(withTitle: "Cancel", type: .cancel) {
                ZQLog(message: "--__--|| Cancel")
            }
            alert.addButton(withTitle: "OK", type: .normal) {
                ZQLog(message: "--__--|| OK")
            }
            alert.showAlertController()
            
        case 9:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.contentStyle.textColor = UIColor.blue
            styleManager.contentViewStyle.maxHeight = 300
            let alert:ZQAlertController = ZQAlertController.alert(withTitle: nil, message: "Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog Content too loog ")
            alert.addButton(withTitle: "Cancel", type: .cancel) {
                ZQLog(message: "--__--|| Cancel")
            }
            alert.addButton(withTitle: "OK", type: .normal) {
                ZQLog(message: "--__--|| OK")
            }
            alert.showAlertController()
        default:break
        }
    }
    
    fileprivate func showAlertControllerDirection(row:Int) -> Void {
        styleManager.backgroundStyle.canDismiss = false
        styleManager.titleStyle.textColor = UIColor.red
        styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
        styleManager.contentStyle.textColor = UIColor.blue
        var message = ""
        switch row {
        case 0:
            styleManager.animationStyle.animationFrom = .top
            message = "Top Direction"
            
        case 1:
            styleManager.animationStyle.animationFrom = .bottom
            message = "Bottom Direction"
            
        case 2:
            styleManager.animationStyle.animationFrom = .left
            message = "Left Direction"
            
        case 3:
            styleManager.animationStyle.animationFrom = .right
            message = "Right Direction"
            
        case 4:
            styleManager.animationStyle.animationFrom = .center
            message = "Center Direction"
        default:break
        }
        let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title", message: message)
        alert.addButton(withTitle: "Cancel", type: .cancel) {
            ZQLog(message: "--__--|| Cancel")
        }
        alert.addButton(withTitle: "OK", type: .normal) {
            ZQLog(message: "--__--|| OK")
        }
        alert.showAlertController()
    }
    
    fileprivate func showAlertControllerBlurBackground(row:Int) -> Void {
        styleManager.backgroundStyle.canDismiss = false
        styleManager.titleStyle.textColor = UIColor.red
        styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
        styleManager.contentStyle.textColor = UIColor.blue
        styleManager.backgroundStyle.blur = true
        let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Title", message: "Content")
        switch row {
        case 0:
            styleManager.backgroundStyle.blurStyle.tintColor = UIColor.brown.withAlphaComponent(0.3)
        
        case 1:
            styleManager.backgroundStyle.blurStyle.backGroundImage = UIImage(imageLiteralResourceName: "fire")
            
        case 2:
            styleManager.backgroundStyle.blurStyle.maskImage = UIImage(imageLiteralResourceName: "fire")
        default:break
        }
        alert.addButton(withTitle: "Cancel", type: .cancel) {
            ZQLog(message: "--__--|| Cancel")
        }
        alert.addButton(withTitle: "OK", type: .normal) {
            ZQLog(message: "--__--|| OK")
        }
        alert.showAlertController()
    }
    
    fileprivate func showAlertControllerCustomContentView(row:Int) -> Void {
        switch row {
        case 0:
            styleManager.backgroundStyle.canDismiss = false
            styleManager.keyboardStyle.gap = 70
            let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
            contentView.backgroundColor = UIColor.brown
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            titleLabel.text = "ContentView with textField"
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.blue
            contentView.addSubview(titleLabel)
            let textField:UITextField = UITextField(frame: CGRect(x: 0, y: 120, width: 200, height: 30))
            textField.backgroundColor = UIColor.red
            textField.placeholder = "I'm a textField"
            contentView.addSubview(textField)
            let alertController:ZQAlertController = ZQAlertController.alert(withContentView: contentView)
            styleManager.keyboardStyle.showClosure = {(keyboardHeight:CGFloat, duration:CGFloat) -> () in
                ZQLog(message: "--__--|| keyboardHeight:\(keyboardHeight), duration:\(duration)")
            }
            styleManager.keyboardStyle.hideClosure = {(duration:CGFloat) -> () in
                ZQLog(message: "--__--|| duration:\(duration)")
            }
            alertController.showAlertController()
        default:break
        }
    }
    
    fileprivate func showAlertControllerCustomAnimation(row:Int) -> Void {
        styleManager.backgroundStyle.canDismiss = true
        styleManager.backgroundStyle.blur = true
        styleManager.backgroundStyle.blurStyle.radius = 1
        styleManager.backgroundStyle.blurStyle.backGroundImage = UIImage(imageLiteralResourceName: "fire")
        let presentAnimation = CATransition()
        let dismissAnimation = CATransition()
        var message = ""
        switch row {
        case 0:
            presentAnimation.type = CATransitionType(rawValue: "pageUnCurl")
            dismissAnimation.type = CATransitionType(rawValue: "pageCurl")
            message = "PageUnCurl and PageCurl animation"
        case 1:
            presentAnimation.type = CATransitionType(rawValue: "push")
            dismissAnimation.type = CATransitionType(rawValue: "reveal")
            message = "Push and reveal animation"
        default:break
        }
        presentAnimation.subtype = CATransitionSubtype.fromLeft
        presentAnimation.startProgress = 0
        presentAnimation.endProgress = 1
        presentAnimation.duration = 1
        styleManager.animationStyle.presentAnimation = presentAnimation
        styleManager.animationStyle.presentAnimationKey = "transition";
        
        dismissAnimation.subtype = CATransitionSubtype.fromRight
        dismissAnimation.startProgress = 0
        dismissAnimation.endProgress = 1
        dismissAnimation.duration = 1
        styleManager.animationStyle.dismissAnimation = dismissAnimation
        styleManager.animationStyle.dismissAnimationKey = "transition";
        
        styleManager.titleStyle.textColor = UIColor.red
        styleManager.titleStyle.font = UIFont.boldSystemFont(ofSize: 20)
        styleManager.contentStyle.textColor = UIColor.blue
        styleManager.cancelButtonStyle.backgroundColor = UIColor.red
        styleManager.cancelButtonStyle.highlightBackgroundColor = UIColor.blue
        
        let alert:ZQAlertController = ZQAlertController.alert(withTitle: "Cutom animation", message: message)
        alert.addButton(withTitle: "Cancel", type: .cancel) {
            ZQLog(message: "--__--|| Cancel")
        }
        alert.addButton(withTitle: "OK", type: .normal) {
            ZQLog(message: "--__--|| OK")
        }
        alert.showAlertController()
    }
}

// MARK: UITableView
extension ZQRootViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArr[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlesArr[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        cell?.textLabel?.text = datasArr[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showAlertControllerNormal(row: indexPath.row)
        case 1:
            showAlertControllerDirection(row: indexPath.row)
        case 2:
            showAlertControllerBlurBackground(row: indexPath.row)
        case 3:
            showAlertControllerCustomContentView(row: indexPath.row)
        case 4:
            showAlertControllerCustomAnimation(row: indexPath.row)
        default: break
        }
    }
}

