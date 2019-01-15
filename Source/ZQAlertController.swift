//
//  ZQAlertController.swift
//  ZQAlertControllerDemo
//
//  Created by Darren on 2019/1/12.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

// MARK: 弹窗控制器
public class ZQAlertController: ZQAlertBaseController {
    
    fileprivate var alertTitle:String?
    
    fileprivate var alertMessage:String?
    
    fileprivate var leftButton:UIButton?
    
    fileprivate var leftButtonClick:ZQAlertButtonClick?
    
    fileprivate var rightButton:UIButton?
    
    fileprivate var rightButtonClick:ZQAlertButtonClick?
    
    fileprivate lazy var styleManager:ZQAlertStyleManager = {
        let styleManager:ZQAlertStyleManager = ZQAlertStyleManager.default
        return styleManager
    }()
    
    fileprivate lazy var buttonArr:NSMutableArray = {
        let buttonArr:NSMutableArray = NSMutableArray()
        return buttonArr
    }()
    
    public lazy var contentView:UIView = {
        let contentViewStyle:ZQAlertContentViewStyle = styleManager.contentViewStyle
        let contentView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: contentViewStyle.width, height: 0))
        contentView.backgroundColor = contentViewStyle.backgroundColor
        contentView.layer.cornerRadius = contentViewStyle.cornerRadius
        contentView.layer.masksToBounds = true
        return contentView
    }()
    
    /// 兼容一行或者多行时可以滚动,所以用UITextView
    fileprivate lazy var titleTextView:UITextView = {
        let titleStyle:ZQAlertTitleStyle = styleManager.titleStyle
        let titleTextView:UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: styleManager.contentViewStyle.width, height: 0))
        titleTextView.backgroundColor = titleStyle.backgroundColor
        guard let attStr = titleStyle.attributedStr else {
            titleTextView.font = titleStyle.font
            titleTextView.textColor = titleStyle.textColor
            titleTextView.textAlignment = titleStyle.textAlignment
            return titleTextView
        }
        titleTextView.attributedText = attStr
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        return titleTextView
    }()
    
    /// 兼容一行或者多行时可以滚动,所以用UITextView
    fileprivate lazy var contentTextView:UITextView = {
        let contentStyle:ZQAlertContentStyle = styleManager.contentStyle
        let contentTextView:UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: styleManager.contentViewStyle.width, height: 0))
        contentTextView.backgroundColor = contentStyle.backgroundColor
        guard let attStr = contentStyle.attributedStr else {
            contentTextView.font = contentStyle.font
            contentTextView.textColor = contentStyle.textColor
            contentTextView.textAlignment = contentStyle.textAlignment
            return contentTextView
        }
        contentTextView.isEditable = false
        contentTextView.isSelectable = false
        return contentTextView
    }()
    
    fileprivate lazy var keyboardManager:ZQAlertKeyboardManager = {
        let keyboardManager:ZQAlertKeyboardManager = ZQAlertKeyboardManager()
        return keyboardManager
    }()
    
    // MARK: life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutSubViews()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        styleManager.keyboardStyle.showClosure = nil
        styleManager.keyboardStyle.hideClosure = nil
    }
    
    /// contentView的frame发生改变 以及 view.addSubview(contentView),都会触发该方法,因此不要在这里执行计算和布局
//    public override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        ZQLog(message: "--__--|| 走了几次")
//    }
}

// MARK: private
public extension ZQAlertController {
    fileprivate class func showException(withReason reason:String?) -> Void {
        let exception = NSException.init(name:NSExceptionName(rawValue: "ZQAlertControllerException"), reason: reason, userInfo: nil)
        exception.raise()
    }
    
    fileprivate func setupButton(withTitle title:String, type:ZQAlertButtonStyle, click:ZQAlertButtonClick? = nil) -> Void {
        var buttonStyle:ZQAlertBaseButtonStyle = styleManager.normalButtonStyle
        if type == .cancel {
            buttonStyle = styleManager.cancelButtonStyle
        }
        let button:UIButton = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: styleManager.contentViewStyle.width * 0.5, height: min(styleManager.normalButtonStyle.hight, styleManager.cancelButtonStyle.hight))
        button.backgroundColor = buttonStyle.backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(buttonStyle.textColor, for: .normal)
        button.setTitleColor(buttonStyle.highlightTextColor, for: .highlighted)
        button.titleLabel?.font = buttonStyle.font
        button.setBackgroundImage(UIImage.zq_createImage(withColor: buttonStyle.backgroundColor), for: .normal)
        button.setBackgroundImage(UIImage.zq_createImage(withColor: buttonStyle.highlightBackgroundColor), for: .highlighted)
        button.addTarget(self, action: #selector(actionForAlertButton(_:)), for: .touchUpInside)
        if buttonArr.count == 0 {
            leftButton = button
            leftButtonClick = click
        } else {
            rightButton = button
            rightButtonClick = click
        }
        buttonArr.add(button)
        contentView.addSubview(button)
    }
    
    fileprivate func setupView() -> Void {
        if let containerView = styleManager.contentViewStyle.containerView {
            let containInputView:Bool = containerView.zq_containInputView()
            if containInputView {
                keyboardManager.manager(withTargetView: containerView)
            }
            return
        }
        view.addSubview(contentView)
        if !String.zq_isEmpty(str: alertTitle) || !NSAttributedString.zq_isEmpty(str: styleManager.titleStyle.attributedStr) {
            contentView.addSubview(titleTextView)
        }
        if !String.zq_isEmpty(str: alertMessage) || !NSAttributedString.zq_isEmpty(str: styleManager.contentStyle.attributedStr) {
            contentView.addSubview(contentTextView)
        }
    }
    
    /// 每次调用addSubview都会执行系统的viewDidLayoutSubviews,如果在viewDidLayoutSubviews方法里执行计算,不合理
    /// 但是如果在这里计算,此时view的frame都是0
    fileprivate func layoutSubViews() -> Void {
        if let view = styleManager.contentViewStyle.containerView {
            view.center = UIApplication.zq_topWindow()?.center ?? CGPoint.zero
            return
        }
        let titleStyle:ZQAlertTitleStyle = styleManager.titleStyle
        let contentViewStyle:ZQAlertContentViewStyle = styleManager.contentViewStyle
        let contentStyle:ZQAlertContentStyle = styleManager.contentStyle
        let normalButtonStyle:ZQAlertNormalButtonStyle = styleManager.normalButtonStyle
        let cancelButtonStyle:ZQAlertCancelButtonStyle = styleManager.cancelButtonStyle
        
        let buttonCount = buttonArr.count
        let buttonHeight:CGFloat = buttonCount > 0 ? max(normalButtonStyle.hight, cancelButtonStyle.hight) : 0
        var maxHeight:CGFloat = contentViewStyle.maxHeight - buttonHeight
        var contentHeight:CGFloat = 0
        
        /// 有标题
        if titleTextView.superview != nil {
            var titleInsets:UIEdgeInsets = titleStyle.insets
            
            /// 没内容, 只有标题
            if contentTextView.superview == nil {
                titleInsets = titleStyle.onlyTitleInsets
                layoutTitleTextView(titleInsets: titleInsets)
                
                /// 超出最大高度,按最大高度显示,且可以滚动
                if titleTextView.zq_height > maxHeight {
                    titleTextView.zq_height = maxHeight
                    titleTextView.isScrollEnabled = true
                }
                contentHeight = titleTextView.zq_height
                layouButton(buttonHeight: buttonHeight, contentHeight: contentHeight)
            }
            
            /// 标题 + 内容
            else {
                layoutTitleTextView(titleInsets: titleInsets)
                
                /// 标题已经超出最大高度,按最大高度显示,且可以滚动,这时就不显示内容
                if titleTextView.zq_height > maxHeight {
                    contentTextView.removeFromSuperview()
                    titleTextView.zq_height = maxHeight
                    titleTextView.isScrollEnabled = true
                    contentHeight += titleTextView.zq_height
                    layouButton(buttonHeight: buttonHeight, contentHeight: contentHeight)
                    return
                }
                
                else {
                    contentHeight += titleTextView.zq_height
                    layoutContentTextView(contentInsets: contentStyle.insets)
                    contentTextView.zq_y = titleTextView.zq_height
                    maxHeight -= titleTextView.zq_height
                    
                    /// 超出最大高度,按最大高度显示,且可以滚动
                    if contentTextView.zq_height > maxHeight {
                        contentTextView.zq_height = maxHeight
                        contentTextView.isScrollEnabled = true
                    }
                    contentHeight += contentTextView.zq_height
                    layouButton(buttonHeight: buttonHeight, contentHeight: contentHeight)
                    return
                }
                
            }
        }
        
        /// 没标题
        else {
            layoutContentTextView(contentInsets: contentStyle.insets)
            
            /// 内容已经超出最大高度,按最大高度显示,且可以滚动
            if contentTextView.zq_height > maxHeight {
                contentTextView.zq_height = maxHeight
                contentTextView.isScrollEnabled = true
            }
            contentHeight = contentTextView.zq_height
            layouButton(buttonHeight: buttonHeight, contentHeight: contentHeight)
        }
        
        /// 显示完,移除标题和内容,不然下次还会显示
        styleManager.titleStyle.attributedStr = nil
        styleManager.contentStyle.attributedStr = nil
    }
    
    fileprivate func layoutTextView(textView:UITextView) -> Void {
        let attStr:NSAttributedString = NSAttributedString.init(string: textView.text, attributes: [NSAttributedString.Key.font:textView.font ?? UIFont.systemFont(ofSize: 17)])
        let insets:UIEdgeInsets = textView.textContainerInset
        let strSize:CGSize = attStr.zq_sizeWidth(withMaxWidth: styleManager.contentViewStyle.width - insets.left - insets.right)
        let strHeight:CGFloat = strSize.height + insets.top + insets.bottom
        textView.zq_height = strHeight
        textView.zq_height = max(textView.zq_height, textView.contentSize.height)
        textView.isScrollEnabled = false
    }
    
    fileprivate func layoutTitleTextView(titleInsets:UIEdgeInsets) -> Void {
        titleTextView.textContainerInset = titleInsets
        if let attributedText = styleManager.titleStyle.attributedStr {
            titleTextView.attributedText = attributedText
        }
        else {
            titleTextView.text = alertTitle
        }
        layoutTextView(textView: titleTextView)
    }
    
    fileprivate func layoutContentTextView(contentInsets:UIEdgeInsets) -> Void {
        contentTextView.textContainerInset = contentInsets
        if let attributedText = styleManager.contentStyle.attributedStr {
            contentTextView.attributedText = attributedText
        }
        else {
            contentTextView.text = alertMessage
        }
        layoutTextView(textView: contentTextView)
    }
    
    fileprivate func layoutContentView(contentHeight:CGFloat) -> Void {
        contentView.zq_height = contentHeight
        contentView.center = UIApplication.zq_topWindow()?.center ?? CGPoint.zero
    }
    
    fileprivate func layouButton(buttonHeight:CGFloat, contentHeight:CGFloat) -> Void {
        var totalHeight = contentHeight
        let buttonCount = buttonArr.count
        let contentWidth:CGFloat = styleManager.contentViewStyle.width
        let separatorStyle:ZQAlertSeparatorStyle = styleManager.separatorStyle
        if buttonCount == 0 {
            layoutContentView(contentHeight: totalHeight)
            return
        }
        let separator:UIView = UIView(frame: CGRect(x: 0, y: totalHeight, width: contentWidth, height: separatorStyle.width))
        separator.backgroundColor = separatorStyle.color
        contentView.addSubview(separator)
        totalHeight += separatorStyle.width
        
        /// 只有一个按钮
        if buttonCount == 1 {
            let button:UIButton = buttonArr.firstObject as! UIButton
            button.zq_y = totalHeight
            button.zq_width = contentWidth
            totalHeight += buttonHeight
            layoutContentView(contentHeight: totalHeight)
            return
        }
            
        /// 有两个按钮
        else if buttonCount == 2 {
            let buttonWidth = (contentWidth - separatorStyle.width) * 0.5
            let firstButton:UIButton = buttonArr.firstObject as! UIButton
            firstButton.zq_y = totalHeight
            firstButton.zq_width = buttonWidth
            
            let separator:UIView = UIView(frame: CGRect(x: buttonWidth, y: totalHeight, width: separatorStyle.width, height: buttonHeight))
            separator.backgroundColor = separatorStyle.color
            contentView.addSubview(separator)
            
            let secondButton:UIButton = buttonArr.lastObject as! UIButton
            secondButton.zq_x = separator.frame.maxX
            secondButton.zq_y = totalHeight
            secondButton.zq_width = buttonWidth
            
            totalHeight += buttonHeight
            layoutContentView(contentHeight: totalHeight)
        }
    }
}

// MARK: public
public extension ZQAlertController {
    
    @discardableResult
    public class func alert(withTitle title:String?, message:String?) -> ZQAlertController {
        let styleManager = ZQAlertStyleManager.default
        if String.zq_isEmpty(str: title) && String.zq_isEmpty(str: message) && styleManager.titleStyle.attributedStr == nil && styleManager.contentStyle.attributedStr == nil {
            showException(withReason: "Can not show \(self): need title or message at least one")
        }
        let alert:ZQAlertController = ZQAlertController()
        alert.alertTitle = title
        alert.alertMessage = message
        return alert
    }
    
    @discardableResult
    public class func alert(withContentView contentView:UIView?) -> ZQAlertController {
        if contentView == nil {
            showException(withReason: "Can not show \(self): need a contentView")
        }
        let alert:ZQAlertController = ZQAlertController()
        ZQAlertStyleManager.default.contentViewStyle.containerView = contentView
        return alert
    }
    
    public func addButton(withTitle title:String, type:ZQAlertButtonStyle, click:ZQAlertButtonClick? = nil) -> Void {
        if styleManager.contentViewStyle.containerView != nil {
            ZQAlertController.showException(withReason: "You already has a custom contentView, shouldn't add any button")
        }
        if buttonArr.count >= 2 {
            ZQAlertController.showException(withReason: "You can add 2 buttons at most \(self): already has \(buttonArr.count) buttons")
        }
        setupButton(withTitle: title, type: type, click: click)
    }
}

// MARK: action
public extension ZQAlertController {
    @objc fileprivate func actionForAlertButton(_ sender:UIButton) -> Void {
        if sender.isEqual(leftButton) {
            leftButtonClick?()
        } else if sender.isEqual(rightButton) {
            rightButtonClick?()
        }
    }
}
