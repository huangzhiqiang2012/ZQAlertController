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
    fileprivate lazy var button:UIButton = {
        let button:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.backgroundColor = UIColor.brown
        button.frame = CGRect.init(x: 100, y: 100, width: 90, height: 30)
        button.setTitle("present", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(actionForButton), for: UIControl.Event.touchUpInside)
        return button
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
        view.addSubview(self.button)
    }
}

// MARK: action
extension ZQRootViewController {
    @objc fileprivate func actionForButton() -> Void {
        let manager = ZQAlertStyleManager.default
        manager.backgroundStyle.canDismiss = true
        manager.backgroundStyle.blur = true
        manager.backgroundStyle.blurStyle.radius = 1
        manager.backgroundStyle.blurStyle.backGroundImage = UIImage(imageLiteralResourceName: "fire")
        
        manager.animationStyle.animationFrom = .right
        
        let transitionAni = CATransition()
        transitionAni.type = CATransitionType(rawValue: "pageUnCurl")
        transitionAni.subtype = CATransitionSubtype.fromLeft
        transitionAni.startProgress = 0
        transitionAni.endProgress = 1
        transitionAni.duration = 1
        manager.animationStyle.presentAnimation = transitionAni
        manager.animationStyle.presentAnimationKey = "transition";
        
        let transitionAni1 = CATransition()
        transitionAni1.type = CATransitionType(rawValue: "pageCurl")
        transitionAni1.subtype = CATransitionSubtype.fromRight
        transitionAni1.startProgress = 0
        transitionAni1.endProgress = 1
        transitionAni1.duration = 1
        manager.animationStyle.dismissAnimation = transitionAni1
        manager.animationStyle.dismissAnimationKey = "transition";
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        contentView.backgroundColor = UIColor.brown
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        titleLabel.text = "Title"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.blue
        contentView.addSubview(titleLabel)
        let textField:UITextField = UITextField(frame: CGRect(x: 0, y: 120, width: 200, height: 30))
        textField.backgroundColor = UIColor.red
        contentView.addSubview(textField)
        let alertController:ZQAlertController = ZQAlertController.alert(withContentView: contentView)
        alertController.showAlertController()
        manager.keyboardStyle.showClosure = {(keyboardHeight:CGFloat, duration:CGFloat) -> () in
            ZQLog(message: "--__--|| keyboardHeight:\(keyboardHeight), duration:\(duration)")
        }
        manager.keyboardStyle.hideClosure = {(duration:CGFloat) -> () in
            ZQLog(message: "--__--|| duration:\(duration)")
        }
        return
        
//        let manager = ZQAlertStyleManager.default
//        manager.backgroundStyle.blur = true
//        manager.backgroundStyle.blurStyle.radius = 1
//        manager.backgroundStyle.blurStyle.backGroundImage = UIImage(imageLiteralResourceName: "fire")
//
//        manager.animationStyle.animationFrom = .right
//
//        let transitionAni = CATransition()
//        transitionAni.type = CATransitionType(rawValue: "pageUnCurl")
//        transitionAni.subtype = CATransitionSubtype.fromLeft
//        transitionAni.startProgress = 0
//        transitionAni.endProgress = 1
//        transitionAni.duration = 1
//        manager.animationStyle.presentAnimation = transitionAni
//        manager.animationStyle.presentAnimationKey = "transition";
//
//        let transitionAni1 = CATransition()
//        transitionAni1.type = CATransitionType(rawValue: "pageCurl")
//        transitionAni1.subtype = CATransitionSubtype.fromRight
//        transitionAni1.startProgress = 0
//        transitionAni1.endProgress = 1
//        transitionAni1.duration = 1
//        manager.animationStyle.dismissAnimation = transitionAni1
//        manager.animationStyle.dismissAnimationKey = "transition";
//
//        manager.contentViewStyle.cornerRadius = 15
//        manager.titleStyle.textColor = UIColor.blue
//        manager.titleStyle.font = UIFont.systemFont(ofSize: 24)
//        manager.cancelButtonStyle.backgroundColor = UIColor.red
//        let alert:ZQAlertController = ZQAlertController.alert(withTitle:"Title", message: "地方地方大幅度费大幅度发对方答复的方师傅的说法是否第三方士大夫的说法水电费第三方第三方手动")
//        alert.addButton(withTitle: "Cancel", type: .cacel) {
//            ZQLog(message: "--__--|| Cancel")
//        }
//        alert.addButton(withTitle: "OK", type: .normal) {
//            ZQLog(message: "--__--|| OK")
//        }
//        alert.showAlertController()
    }
}

