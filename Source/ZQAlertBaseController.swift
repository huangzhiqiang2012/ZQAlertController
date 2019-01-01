//
//  ZQAlertBaseController.swift
//  ZQAlertControllerDemo
//
//  Created by Darren on 2018/12/30.
//  Copyright © 2018 Darren. All rights reserved.
//

import UIKit

/***********自定义相关*************/
// MARK:自定义log打印
// Swift没有宏的概念,所以得在TARGET -> Build Setting -> Other Swift Flags的Debug状态加一个 -D DEBUG
public func ZQLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fName = ((fileName as NSString).pathComponents.last!)
    print("\(fName).\(methodName)[\(lineNumber)]: \(message)")
    #endif
}

// MARK: UIWindow extension
extension UIWindow {
    public func topViewController() -> UIViewController? {
        var topViewController = self.rootViewController
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController
    }
}

// MARK: 动画类型
public enum ZQAlertAnimationMode:Int {
    case present   = 0  ///< 弹出
    case dismiss   = 1  ///< 消失
}

// MARK: 动画弹出位置
public enum ZQAlertAnimationStyle:Int {
    case bottom   = 0  ///< 底部弹出
    case top      = 1  ///< 顶部弹出
    case left     = 2  ///< 左边弹出
    case right    = 3  ///< 右边弹出
    case center   = 4  ///< 中间弹出
}

/***********ZQAlertTransitionAnimator*************/
// MARK: 转场动画
public class ZQAlertTransitionAnimator : NSObject {
    
    fileprivate let duration = 0.25
    
    fileprivate var backgroundView:UIView?
    
    /// 动画类型
    public var animationMode:ZQAlertAnimationMode = .present
    
    /// 动画弹出位置
    public var animationStyle:ZQAlertAnimationStyle = .bottom
    
    /// 设置遮罩视图,如果只是颜色改变,直接设置maskColor即可
    public var containerView:UIView?
    
    /// 设置遮罩背景颜色
    public var maskColor:UIColor = UIColor.black.withAlphaComponent(0.5)
    
    // MARK: public
    public init(animationMode:ZQAlertAnimationMode, animationStyle:ZQAlertAnimationStyle) {
        super.init()
        self.animationMode = animationMode
        self.animationStyle = animationStyle
    }
    
    public class func animator(animationMode:ZQAlertAnimationMode, animationStyle:ZQAlertAnimationStyle) -> ZQAlertTransitionAnimator {
        return ZQAlertTransitionAnimator.init(animationMode: animationMode, animationStyle: animationStyle)
    }
}

// MARK: private
extension ZQAlertTransitionAnimator {
    
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
        backView.backgroundColor = maskColor
        fromView?.addSubview(backView)
        backgroundView = backView
        
        let opacity = CABasicAnimation.init(keyPath: "opacity")
        opacity.fromValue = (0)
        opacity.duration = duration
        backgroundView?.layer.add(opacity, forKey: nil)
        
        switch animationStyle {
        case .top:
            toView?.frame = CGRect(x: 0, y: -contentView.bounds.size.height, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            
        case .bottom:
            toView?.frame = CGRect(x: 0, y: contentView.bounds.size.height, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            
        case .left:
            toView?.frame = CGRect(x: -contentView.bounds.size.width, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            
        case .right:
            toView?.frame = CGRect(x: contentView.bounds.size.width, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            
        case .center:
            toView?.frame = CGRect(x: 0, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            toView?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            toView?.alpha = 0
        }
        if (containerView != nil) {
            toView?.addSubview(containerView!)
        }
        UIView.animate(withDuration: duration, animations: {
            switch self.animationStyle {
            case .top, .bottom, .left, .right:
                toView?.frame = CGRect(x: 0, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
                
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
        
        UIView.animate(withDuration: duration) {
            self.backgroundView?.alpha = 0
        }
        
        UIView.animate(withDuration: duration, animations: {
            switch self.animationStyle {
            case .top:
                fromView?.frame = CGRect(x: 0, y: -contentView.bounds.size.height, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
                
            case .bottom:
                fromView?.frame = CGRect(x: 0, y: contentView.bounds.size.height, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
                
            case .left:
                fromView?.frame = CGRect(x: -contentView.bounds.size.width, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
                
            case .right:
                fromView?.frame = CGRect(x: contentView.bounds.size.width, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height)
                
            case .center:
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
        return duration
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

/***********ZQAlertBaseController*************/
// MARK: ZQAlertBaseControllerDelegate
public protocol ZQAlertBaseControllerDelegate : class, NSObjectProtocol {
    func alertControllerViewDidAppear(alertController : ZQAlertBaseController)
    func alertControllerViewDidDisAppear(alertController : ZQAlertBaseController)
}

// MARK: 弹窗基础控制器
/**
 * 用法:
 * 1 直接替换containerView
 * let alertController = ZQAlertBaseController.init(animationStyle: .bottom)
 * alertController.containerView = UIView
 * alertController.showAlertController()
 *
 * 2 也可以继承该类,然后自己添加控件(推荐该方法)
 *
 */
public class ZQAlertBaseController: UIViewController {
    
    fileprivate var transitionAnimator:ZQAlertTransitionAnimator? = ZQAlertTransitionAnimator(animationMode: .present, animationStyle: .bottom)
    
    fileprivate var viewWillAppear:Bool = false
    
    fileprivate var presentingViewControllerSupportedInterfaceOrientation : UIInterfaceOrientationMask = .portrait
    
    fileprivate lazy var panel:UIControl? = {
        let panel:UIControl = UIControl()
        panel.addTarget(self, action: #selector(actionForPanel), for: .touchUpInside)
        return panel
    }()
    
    fileprivate lazy var backgroundView:UIView? = {
        let backgroundView:UIView = UIView()
        return backgroundView
    }()
    
    /// 动画弹出位置
    public var animationStyle:ZQAlertAnimationStyle = .bottom
    
    /// 设置遮罩视图,如果只是颜色改变,直接设置maskColor即可
    public var containerView:UIView?
    
    /// 设置遮罩背景颜色
    public var maskColor:UIColor = UIColor.black.withAlphaComponent(0.5)
    
    /// 点击背景自动dismiss
    public var autoFall:Bool = true
    
    public weak var delegate:ZQAlertBaseControllerDelegate?
    
    // MARK: life cycle
    deinit {
        ZQLog(message: "--__--|| " + NSStringFromClass(self.classForCoder) + " dealloc")
    }
    
    public init(animationStyle:ZQAlertAnimationStyle) {
        super.init(nibName: nil, bundle: nil)
        alertInitialize()
        self.animationStyle = animationStyle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        alertInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        alertInitialize()
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        self.view = self.panel
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewWillAppear {
            return
        }
        let presentingVC:UIViewController = self.presentingViewController!
        presentingViewControllerSupportedInterfaceOrientation = presentingVC.supportedInterfaceOrientations
        viewWillAppear = true
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.alertControllerViewDidAppear(alertController: self)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return presentingViewControllerSupportedInterfaceOrientation
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
}

// MARK: public
extension ZQAlertBaseController {
    public func showAlertController(completion: (() -> Swift.Void)? = nil) -> Void {
        UIApplication.shared.keyWindow?.topViewController()?.present(self, animated: true, completion: completion)
    }
    
    public func dismissAlertController(completion: (() -> Swift.Void)? = nil) -> Void {
        dismiss(animated: true, completion: completion)
    }
}

// MARK: private
extension ZQAlertBaseController {
    fileprivate func alertInitialize() -> Void {
        autoFall = true
        maskColor = UIColor.black.withAlphaComponent(0.5)
        viewWillAppear = false
        presentingViewControllerSupportedInterfaceOrientation = .portrait
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
}

// MARK: action
extension ZQAlertBaseController {
    @objc fileprivate func actionForPanel() -> Void {
        if autoFall {
            dismissAlertController()
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ZQAlertBaseController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator = ZQAlertTransitionAnimator(animationMode: .present, animationStyle: animationStyle)
        transitionAnimator?.containerView = containerView
        transitionAnimator?.maskColor = maskColor
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.animationMode = .dismiss
        transitionAnimator?.animationStyle = animationStyle
        return transitionAnimator
    }
}

