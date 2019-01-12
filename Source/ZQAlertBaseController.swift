//
//  ZQAlertBaseController.swift
//  ZQAlertControllerDemo
//
//  Created by Darren on 2018/12/30.
//  Copyright © 2018 Darren. All rights reserved.
//

import UIKit

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
public extension ZQAlertBaseController {
    public func showAlertController(completion: (() -> Swift.Void)? = nil) -> Void {
        UIApplication.shared.keyWindow?.zq_topViewController()?.present(self, animated: true, completion: completion)
    }
    
    public func dismissAlertController(completion: (() -> Swift.Void)? = nil) -> Void {
        dismiss(animated: true, completion: completion)
    }
}

// MARK: private
public extension ZQAlertBaseController {
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
public extension ZQAlertBaseController {
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

