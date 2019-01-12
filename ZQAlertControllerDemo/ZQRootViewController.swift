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
        button.frame = CGRect.init(x: 0, y: 0, width: 90, height: 30)
        button.center = view.center
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
//        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//        contentView.backgroundColor = UIColor.red
//        let alert:ZQAlertController = ZQAlertController.alert(withContentView: contentView)
//        alert.showAlertController()
        
        ZQAlertStyleManager.default.contentViewStyle.cornerRadius = 15
        ZQAlertStyleManager.default.titleStyle.textColor = UIColor.blue
        ZQAlertStyleManager.default.titleStyle.font = UIFont.systemFont(ofSize: 24)
        ZQAlertStyleManager.default.cancelButtonStyle.backgroundColor = UIColor.red
        let alert:ZQAlertController = ZQAlertController.alert(withTitle:"Title", message: "地方地方大幅度费大幅度发对方答复的方师傅的说法是否第三方士大夫的说法水电费第三方第三方手动")
        alert.animationStyle = .top
        alert.addButton(withTitle: "Cancel", type: .cacel) {
            ZQLog(message: "--__--|| Cancel")
        }
        alert.addButton(withTitle: "OK", type: .normal) {
            ZQLog(message: "--__--|| OK")
        }
        alert.showAlertController()
    }
}

