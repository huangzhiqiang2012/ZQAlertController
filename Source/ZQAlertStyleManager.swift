//
//  ZQAlertStyleManager.swift
//  ZQAlertController
//
//  Created by Darren on 2019/1/12.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

/*****************ZQAlertButtonStyle***********************/
// MARK: 按钮样式枚举
public enum ZQAlertButtonStyle {
    case normal
    case cacel
}

/*****************ZQAlertContentViewStyle***********************/
// MARK: 弹窗内容视图样式模型
public class ZQAlertContentViewStyle: NSObject {
    public var width:CGFloat = ZQScreenW == 320 ? 260 : 280
    
    public var maxHeight:CGFloat = ZQScreenH - 120
    
    public var backgroundColor:UIColor = UIColor.white
    
    public var cornerRadius:CGFloat = 8
}

/*****************ZQAlertTitleStyle***********************/
// MARK: 弹窗标题样式模型
public class ZQAlertTitleStyle: NSObject {
    public var insets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    public var onlyTitleInsets:UIEdgeInsets = UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20)

    public var font:UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    public var backgroundColor:UIColor = UIColor.clear
    
    public var textColor:UIColor = ZQDefaultTextColor
    
    public var textAlignment:NSTextAlignment = .center
}

/*****************ZQAlertContentStyle***********************/
// MARK: 弹窗内容样式模型
public class ZQAlertContentStyle: NSObject {
    public var insets:UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 15, right: 10)
    
    public var onlyContentInsets:UIEdgeInsets = UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20)
    
    public var font:UIFont = UIFont.systemFont(ofSize: 15)
    
    public var backgroundColor:UIColor = UIColor.clear
    
    public var textColor:UIColor = ZQDefaultTextColor
    
    public var textAlignment:NSTextAlignment = .center
}

/*****************ZQAlertBaseButtonStyle***********************/
// MARK: 弹窗基础按钮样式模型
public class ZQAlertBaseButtonStyle: NSObject {
    public var hight:CGFloat = 44
    
    public var font:UIFont = UIFont.systemFont(ofSize: 17)
    
    public var backgroundColor:UIColor = UIColor.clear
    
    public var textColor:UIColor = ZQDefaultTextColor
    
    public var highlightTextColor:UIColor = ZQDefaultTextColor
    
    public var highlightBackgroundColor:UIColor = ZQColor(red: 224, green: 224, blue: 224)
}

/*****************ZQAlertNormalButtonStyle***********************/
// MARK: 弹窗普通按钮样式模型
public class ZQAlertNormalButtonStyle: ZQAlertBaseButtonStyle {}

/*****************ZQAlertCancelButtonStyle***********************/
// MARK: 弹窗取消按钮样式模型
public class ZQAlertCancelButtonStyle: ZQAlertBaseButtonStyle {}

/*****************ZQAlertSeparatorStyle***********************/
// MARK: 弹窗分割线样式模型
public class ZQAlertSeparatorStyle: NSObject {
    public var width:CGFloat = 0.5
    
    public var color:UIColor = ZQColor(red: 200, green: 200, blue: 205)
}

/*****************ZQAlertStyleManager***********************/
// MARK: 弹窗类型管理器,单例,方便设置全局弹窗样式
public class ZQAlertStyleManager: NSObject {
    
    public var contentViewStyle:ZQAlertContentViewStyle = ZQAlertContentViewStyle()
    
    public var titleStyle:ZQAlertTitleStyle = ZQAlertTitleStyle()
    
    public var contentStyle:ZQAlertContentStyle = ZQAlertContentStyle()
    
    public var normalButtonStyle:ZQAlertNormalButtonStyle = ZQAlertNormalButtonStyle()
    
    public var cancelButtonStyle:ZQAlertCancelButtonStyle = ZQAlertCancelButtonStyle()
    
    public var separatorStyle:ZQAlertSeparatorStyle = ZQAlertSeparatorStyle()

    public static let `default` = ZQAlertStyleManager()
}
