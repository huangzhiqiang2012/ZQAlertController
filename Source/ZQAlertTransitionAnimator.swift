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
        var image:UIImage? = styleManager.backgroundStyle.blurStyle.backGroundImage ?? UIImage.zq_createImage(withColor: UIColor.clear, size: UIScreen.main.bounds.size)
        let blurStyle:ZQAlertBackgroundBlurStyle = styleManager.backgroundStyle.blurStyle
        let blurView:UIImageView = UIImageView(frame: UIScreen.main.bounds)
        
        /// 渲染模糊图片放在子线程
        DispatchQueue.global().async {
            image = image?.zq_applyBlur(WithRadius: blurStyle.radius, tintColor: blurStyle.tintColor, saturationDeltaFactor: blurStyle.saturationDeltaFactor, maskImage: blurStyle.maskImage)
            
            /// 模糊照片,用高斯模糊算法生成,效率也快,但是相比第一种方法,扩展性较差
//            image = image?.zq_blurImage(withBlurLevel: 0.1)
            
            /// 用高斯模糊滤镜生成,相比上面的两种用算法计算,这个方法更加耗时--__--||
//            image = image?.zq_blurImage(WithRadius: blurStyle.radius)
            
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
        
        /// 先禁止用户交互,dismiss时再重新开启
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
        
        if let containerView = styleManager.contentViewStyle.containerView {
            toView?.addSubview(containerView)
        }
        
        /// 自定义present动画
        if let presentAnimation = styleManager.animationStyle.presentAnimation, let key = styleManager.animationStyle.presentAnimationKey {
            transitionContext.completeTransition(true)
            
            /// 确保toView已经显示,不然虽然也能显示,但是视图的所有点击事件无效,因为无父视图
            toView?.frame = CGRect(x: 0, y: 0, width: contentView.zq_width, height: contentView.zq_height)
            
            /// 延迟0.01s,确保contentView已经显示了,再来执行动画,动画才能显示完整
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 0.01) {
                let view = self.styleManager.contentViewStyle.containerView ?? (toController as! ZQAlertController).contentView
                view.layer.removeAllAnimations()
                view.layer.add(presentAnimation, forKey: key)
            }
            return
        }
        
        /// 默认present动画
        let animationStyle = styleManager.animationStyle
        let duration = animationStyle.duration
        let animationFrom = animationStyle.animationFrom
        
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
            toView?.transform = CGAffineTransform.init(scaleX: animationStyle.minScale, y: animationStyle.minScale)
            toView?.alpha = 0
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            toView?.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: animationStyle.springDamping, initialSpringVelocity: animationStyle.springVelocity, options: .allowUserInteraction, animations: {
            switch animationFrom {
            case .top, .bottom, .left, .right:
                toView?.frame = CGRect(x: 0, y: 0, width: contentView.zq_width, height: contentView.zq_height)
            case .center:
                toView?.transform = CGAffineTransform.identity
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
        
        /// 自定义dismiss动画
        if let dismissAnimation = styleManager.animationStyle.dismissAnimation, let key = styleManager.animationStyle.dismissAnimationKey {
            let view = self.styleManager.contentViewStyle.containerView ?? (fromController as! ZQAlertController).contentView
            view.layer.removeAllAnimations()
            view.layer.add(dismissAnimation, forKey: key)
            UIView.animate(withDuration: dismissAnimation.duration, animations: {
                view.alpha = 0
            }) { (finish) in
                self.backgroundView?.removeFromSuperview()
                fromView?.removeFromSuperview()
                
                /// 开启底部视图用户交互,present时并禁用
                toView?.isUserInteractionEnabled = true
                transitionContext.completeTransition(true)
            }
            return
        }
        
        /// 默认dismiss动画
        let animationStyle = styleManager.animationStyle
        let duration = animationStyle.duration
        let animationFrom = animationStyle.animationFrom
        
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
                fromView?.transform = CGAffineTransform.init(scaleX: animationStyle.minScale, y: animationStyle.minScale)
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
