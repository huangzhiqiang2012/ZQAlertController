//
//  ZQAlertTools.swift
//  ZQAlertController
//
//  Created by Darren on 2019/1/12.
//  Copyright © 2019 Darren. All rights reserved.
//

import Foundation

// MARK:自定义log打印
// Swift没有宏的概念,所以得在TARGET -> Build Setting -> Other Swift Flags的Debug状态加一个 -D DEBUG
public func ZQLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fName = ((fileName as NSString).pathComponents.last!)
    print("\(fName).\(methodName)[\(lineNumber)]: \(message)")
    #endif
}

// MARK:自定义颜色
public func ZQColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
}

// MARK: UIWindow extension
public extension UIWindow {
    public func zq_topViewController() -> UIViewController? {
        var topViewController = self.rootViewController
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController
    }
}

// MARK: UIImage extension
public extension UIImage {
    public class func zq_createImage(withColor color:UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: String extension
public extension String {
    public static func zq_isEmpty(str:String?) -> Bool {
        if let content = str {
            return content.isEmpty
        } else {
            return true
        }
    }
}

// MARK: NSAttributedString extension
public extension NSAttributedString {
    public func zq_sizeWidth(withMaxWidth maxWidth:CGFloat) -> CGSize {
        if self.length == 0 {
            return CGSize.zero
        }
        let rect = self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
        return CGSize(width:CGFloat(ceilf(Float(rect.size.width))), height: CGFloat(ceilf(Float(rect.size.height))))
    }
}

// MARK: UIView extension
public extension UIView {
    public var zq_x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    public var zq_y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    public var zq_width:CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var zq_height:CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var zq_centX:CGFloat {
        get {
            return self.center.x
        }
        set(newCentX) {
            var center = self.center
            center.x = newCentX
            self.center = center
        }
    }
    
    public var zq_centY:CGFloat {
        get {
            return self.center.y
        }
        set(newCentY) {
            var center = self.center
            center.y = newCentY
            self.center = center
        }
    }
}

// MARK:UI相关
let ZQScreenW = UIScreen.main.bounds.size.width

let ZQScreenH = UIScreen.main.bounds.size.height

let ZQDefaultTextColor = ZQColor(red: 0, green: 0, blue: 0)

public typealias ZQAlertButtonClick = () -> ()
