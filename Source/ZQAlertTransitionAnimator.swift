//
//  ZQAlertTransitionAnimator.swift
//  ZQAlertController
//
//  Created by Darren on 2019/1/12.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

// MARK: 动画类型
public enum ZQAlertAnimationMode:Int {
    case present   = 0  ///< 弹出
    case dismiss   = 1  ///< 消失
}

// MARK: 动画弹出位置
public enum ZQAlertAnimationFrom:Int {
    case bottom   = 0  ///< 底部弹出
    case top      = 1  ///< 顶部弹出
    case left     = 2  ///< 左边弹出
    case right    = 3  ///< 右边弹出
    case center   = 4  ///< 中间弹出
}

// MARK: 转场动画
public class ZQAlertTransitionAnimator : NSObject {
    
    fileprivate var backgroundView:UIView?
    
    fileprivate lazy var styleManager:ZQAlertStyleManager = {
        let styleManager:ZQAlertStyleManager = ZQAlertStyleManager.default
        return styleManager
    }()
    
    /// 不用UIVisualEffectView做模糊效果,自定性较差
//    fileprivate lazy var blurView:UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = UIScreen.main.bounds
//        blurView.backgroundColor = styleManager.backgroundStyle.blurStyle.tintColor
//        return blurView
//    }()
    
    fileprivate lazy var blurView:UIImageView = {
        var image:UIImage? = UIImage.zq_createImage(withColor: UIColor.clear, size: UIScreen.main.bounds.size)
        let blurStyle:ZQAlertBackgroundBlurStyle = styleManager.backgroundStyle.blurStyle
        let blurView:UIImageView = UIImageView(frame: UIScreen.main.bounds)
        DispatchQueue.global().async {
            image = image?.zq_applyBlur(WithRadius: blurStyle.radius, tintColor: blurStyle.tintColor, saturationDeltaFactor: blurStyle.saturationDeltaFactor, maskImage: blurStyle.maskImage)
            DispatchQueue.main.async {
                blurView.image = image
            }
        }
        return blurView
    }()
    
    /// 动画类型
    public var animationMode:ZQAlertAnimationMode = .present
    
    // MARK: public
    public init(animationMode:ZQAlertAnimationMode) {
        super.init()
        self.animationMode = animationMode
    }
    
    public class func animator(animationMode:ZQAlertAnimationMode) -> ZQAlertTransitionAnimator {
        return ZQAlertTransitionAnimator.init(animationMode: animationMode)
    }
}

// MARK: private
public extension ZQAlertTransitionAnimator {
    
    fileprivate func presentTransition(transitionContext:UIViewControllerContextTransitioning) -> Void {
        let contentView = transitionContext.containerView
        
        let fromController = transitionContext.viewController(forKey: .from)
        let fromView = fromController?.view
        fromView?.tintAdjustmentMode = .normal
        fromView?.isUserInteractionEnabled = false
        
        let toController = transitionContext.viewController(forKey: .to)
        let toView = toController?.view
        contentView.addSubview(toView!)
        
        let backView = UIView.init(frame: (fromView?.bounds)!)
        backView.backgroundColor = styleManager.backgroundStyle.maskColor
        fromView?.addSubview(backView)
        
        if styleManager.backgroundStyle.blur {
            backView.addSubview(blurView)
        }
        backgroundView = backView
        
        let duration = styleManager.animationStyle.duration
        let animationFrom = styleManager.animationStyle.animationFrom
        let opacity = CABasicAnimation.init(keyPath: "opacity")
        opacity.fromValue = (0)
        opacity.duration = duration
        backgroundView?.layer.add(opacity, forKey: nil)
        
        switch animationFrom {
        case .top:
            toView?.frame = CGRect(x: 0, y: -contentView.zq_height, width: contentView.zq_width, height: contentView.zq_height)
            
        case .bottom:
            toView?.frame = CGRect(x: 0, y: contentView.zq_height, width: contentView.zq_width, height: contentView.zq_height)
            
        case .left:
            toView?.frame = CGRect(x: -contentView.zq_width, y: 0, width: contentView.zq_width, height: contentView.zq_height)
            
        case .right:
            toView?.frame = CGRect(x: contentView.zq_width, y: 0, width: contentView.zq_width, height: contentView.zq_height)
            
        case .center:
            toView?.frame = CGRect(x: 0, y: 0, width: contentView.zq_width, height: contentView.zq_height)
            toView?.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
            toView?.alpha = 0
        }
        if let containerView = styleManager.contentViewStyle.containerView {
            toView?.addSubview(containerView)
        }
        UIView.animate(withDuration: duration, animations: {
            switch animationFrom {
            case .top, .bottom, .left, .right:
                toView?.frame = CGRect(x: 0, y: 0, width: contentView.zq_width, height: contentView.zq_height)
                
            case .center:
                toView?.transform = CGAffineTransform.identity
                toView?.alpha = 1
            }
        }) { (finish) in
            transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissTransition(transitionContext:UIViewControllerContextTransitioning) -> Void {
        let contentView = transitionContext.containerView
        
        let fromController = transitionContext.viewController(forKey: .from)
        let fromView = fromController?.view
        
        let toController = transitionContext.viewController(forKey: .to)
        let toView = toController?.view
        toView?.tintAdjustmentMode = .normal
        toView?.isUserInteractionEnabled = false
        
        let duration = styleManager.animationStyle.duration
        let animationFrom = styleManager.animationStyle.animationFrom
        UIView.animate(withDuration: duration) {
            self.backgroundView?.alpha = 0
        }
        
        UIView.animate(withDuration: duration, animations: {
            switch animationFrom {
            case .top:
                fromView?.frame = CGRect(x: 0, y: -contentView.zq_height, width: contentView.zq_width, height: contentView.zq_height)
                
            case .bottom:
                fromView?.frame = CGRect(x: 0, y: contentView.zq_height, width: contentView.zq_width, height: contentView.zq_height)
                
            case .left:
                fromView?.frame = CGRect(x: -contentView.zq_width, y: 0, width: contentView.zq_width, height: contentView.zq_height)
                
            case .right:
                fromView?.frame = CGRect(x: contentView.zq_width, y: 0, width: contentView.zq_width, height: contentView.zq_height)
                
            case .center:
                fromView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                fromView?.alpha = 0
            }
        }) { (finish) in
            self.backgroundView?.removeFromSuperview()
            fromView?.removeFromSuperview()
            toView?.isUserInteractionEnabled = true
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension ZQAlertTransitionAnimator : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return styleManager.animationStyle.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationMode {
        case .present:
            presentTransition(transitionContext: transitionContext)
            
        case .dismiss:
            dismissTransition(transitionContext: transitionContext)
        }
    }
}
