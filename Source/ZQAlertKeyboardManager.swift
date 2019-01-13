//
//  ZQAlertKeyboardManager.swift
//  ZQAlertController
//
//  Created by Darren on 2019/1/13.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

// MARK: 弹窗键盘管理器
class ZQAlertKeyboardManager: NSObject {
    
    fileprivate lazy var styleManager:ZQAlertStyleManager = {
        let styleManager:ZQAlertStyleManager = ZQAlertStyleManager.default
        return styleManager
    }()
    
    // MARK: life cycle
    deinit {
        unregisetNotification()
        ZQLog(message: "--__--|| " + NSStringFromClass(self.classForCoder) + " dealloc")
    }
    
    override init() {
        super.init()
        regisetNotification()
    }
    
    public var targetView:UIView?
}

// MARK: private
extension ZQAlertKeyboardManager {
    fileprivate func regisetNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(onUIKeyboardWillShowNotification(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUIKeyboardWillHideNotification(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func unregisetNotification() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: public
extension ZQAlertKeyboardManager {
    public func manager(withTargetView targetView:UIView?) -> Void {
        self.targetView = targetView
    }
}

// MARK: notification
extension ZQAlertKeyboardManager {
    @objc fileprivate func onUIKeyboardWillShowNotification(_ notification:NSNotification) -> Void {
        guard let dic = notification.userInfo else {
            return
        }
        let keyboardHeight:CGFloat = (dic[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration:CGFloat = dic[UIResponder.keyboardAnimationDurationUserInfoKey] as! CGFloat
        styleManager.keyboardStyle.showClosure?(keyboardHeight, duration)
        guard let view = targetView else {
            return
        }
        if view.superview == nil {
            return
        }
        var result:CGFloat = view.frame.maxY + keyboardHeight - ZQScreenH
        if result < 0 {
            return
        }
        result += styleManager.keyboardStyle.gap
        UIView.animate(withDuration: ZQAlertStyleManager.default.animationStyle.duration) {
            view.zq_centY -= result
        }
    }
    
    @objc fileprivate func onUIKeyboardWillHideNotification(_ notification:NSNotification) -> Void {
        guard let dic = notification.userInfo else {
            return
        }
        let duration:CGFloat = dic[UIResponder.keyboardAnimationDurationUserInfoKey] as! CGFloat
        styleManager.keyboardStyle.hideClosure?(duration)
        guard let view = targetView else {
            return
        }
        if view.superview == nil {
            return
        }
        UIView.animate(withDuration: ZQAlertStyleManager.default.animationStyle.duration) {
            view.zq_centY = view.superview!.zq_centY
        }
    }
}
