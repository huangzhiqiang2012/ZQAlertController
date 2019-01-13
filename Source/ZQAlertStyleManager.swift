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
    case normal    ///< 普通
    case cacel     ///< 取消
}

/*****************ZQAlertAnimationdStyle***********************/
// MARK: 弹窗动画样式模型
public class ZQAlertAnimationdStyle: NSObject {
    
    /// 动画弹出位置
    public var animationFrom:ZQAlertAnimationFrom = .center
    
    /// 动画时间
    public var duration = 0.25
}

/*****************ZQAlertBackgroundBlurStyle***********************/
// MARK: 弹窗背景模糊样式模型
public class ZQAlertBackgroundBlurStyle: NSObject {
    
    /// 半径
    public var radius:CGFloat = 4
    
    /// 色彩饱和度
    public var saturationDeltaFactor: Double = 1
    
    /// 渲染颜色
    public var tintColor:UIColor = UIColor.clear
    
    /// 遮罩图片
    public var maskImage:UIImage?
}

/*****************ZQAlertBackgroundStyle***********************/
// MARK: 弹窗背景样式模型
public class ZQAlertBackgroundStyle: NSObject {
    
    /// 遮罩背景颜色
    public var maskColor:UIColor = UIColor.black.withAlphaComponent(0.5)
    
    /// 是否模糊
    public var blur:Bool = false
    
    /// 模糊类型,只有当 blur = true时,设置才有效
    public var blurStyle:ZQAlertBackgroundBlurStyle = ZQAlertBackgroundBlurStyle()
    
    /// 点击背景是否dismiss
    public var canDismiss:Bool = true
}

/*****************ZQAlertContentViewStyle***********************/
// MARK: 弹窗内容视图样式模型
public class ZQAlertContentViewStyle: NSObject {
    
    /// 遮罩视图,如果只是颜色改变,直接设置ZQAlertBackgroundStyle里面的maskColor即可
    public var containerView:UIView?
    
    /// 宽,只有当containerView == nil时才有效
    public var width:CGFloat = ZQScreenW == 320 ? 260 : 280
    
    /// 最大的高,只有当containerView == nil时才有效
    public var maxHeight:CGFloat = ZQScreenH - 120
    
    /// 背景颜色,只有当containerView == nil时才有效
    public var backgroundColor:UIColor = UIColor.white
    
    /// 倒圆角,只有当containerView == nil时才有效
    public var cornerRadius:CGFloat = 8
}

/*****************ZQAlertTextStyle***********************/
// MARK: 弹窗文本样式模型
public class ZQAlertTextStyle: NSObject {
    
    /// 有标题和内容时的标题/内容边距
    public var insets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// 字体
    public var font:UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /// 背景颜色
    public var backgroundColor:UIColor = UIColor.clear
    
    /// 文字颜色
    public var textColor:UIColor = ZQDefaultTextColor
    
    /// 文字对齐方式
    public var textAlignment:NSTextAlignment = .center
}

/*****************ZQAlertTitleStyle***********************/
// MARK: 弹窗标题样式模型
public class ZQAlertTitleStyle: ZQAlertTextStyle {
    
    /// 只有标题时的标题边距
    public var onlyTitleInsets:UIEdgeInsets = UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20)
}

/*****************ZQAlertContentStyle***********************/
// MARK: 弹窗内容样式模型
public class ZQAlertContentStyle: ZQAlertTextStyle {
    
    /// 只有内容时的内容边距
    public var onlyContentInsets:UIEdgeInsets = UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20)
}

/*****************ZQAlertBaseButtonStyle***********************/
// MARK: 弹窗基础按钮样式模型
public class ZQAlertBaseButtonStyle: NSObject {
    
    /// 高
    public var hight:CGFloat = 44
    
    /// 字体
    public var font:UIFont = UIFont.systemFont(ofSize: 17)
    
    /// 背景颜色
    public var backgroundColor:UIColor = UIColor.clear
    
    /// 普通状态文字颜色
    public var textColor:UIColor = ZQDefaultTextColor
    
    /// 长按状态文字颜色
    public var highlightTextColor:UIColor = ZQDefaultTextColor
    
    /// 长按背景颜色
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
    
    /// 宽
    public var width:CGFloat = 0.5
    
    /// 颜色
    public var color:UIColor = ZQColor(red: 200, green: 200, blue: 205)
}

/*****************ZQAlertStyleManager***********************/
// MARK: 弹窗类型管理器,单例,方便设置全局弹窗样式
public class ZQAlertStyleManager: NSObject {
    
    /// 动画样式
    public var animationStyle:ZQAlertAnimationdStyle = ZQAlertAnimationdStyle()
    
    /// 背景样式
    public var backgroundStyle:ZQAlertBackgroundStyle = ZQAlertBackgroundStyle()
    
    /// 内容视图样式
    public var contentViewStyle:ZQAlertContentViewStyle = ZQAlertContentViewStyle()
    
    /// 标题样式
    public var titleStyle:ZQAlertTitleStyle = ZQAlertTitleStyle()
    
    /// 内容样式
    public var contentStyle:ZQAlertContentStyle = ZQAlertContentStyle()
    
    /// 普通按钮样式
    public var normalButtonStyle:ZQAlertNormalButtonStyle = ZQAlertNormalButtonStyle()
    
    /// 取消按钮样式
    public var cancelButtonStyle:ZQAlertCancelButtonStyle = ZQAlertCancelButtonStyle()
    
    /// 分割线样式
    public var separatorStyle:ZQAlertSeparatorStyle = ZQAlertSeparatorStyle()

    /// 单例
    public static let `default` = ZQAlertStyleManager()
}
