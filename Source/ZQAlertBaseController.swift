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
    
    fileprivate var transitionAnimator:ZQAlertTransitionAnimator?
    
    fileprivate var viewWillAppear:Bool = false
    
    fileprivate var presentingViewControllerSupportedInterfaceOrientation : UIInterfaceOrientationMask = .portrait
    
    fileprivate lazy var styleManager:ZQAlertStyleManager = {
        let styleManager:ZQAlertStyleManager = ZQAlertStyleManager.default
        return styleManager
    }()
    
    fileprivate lazy var panel:UIControl? = {
        let panel:UIControl = UIControl()
        panel.addTarget(self, action: #selector(actionForPanel), for: .touchUpInside)
        return panel
    }()
    
    public weak var delegate:ZQAlertBaseControllerDelegate?
    
    // MARK: life cycle
    deinit {
        ZQLog(message: "--__--|| " + NSStringFromClass(self.classForCoder) + " dealloc")
    }
    
    public init(animationFrom:ZQAlertAnimationFrom) {
        super.init(nibName: nil, bundle: nil)
        alertInitialize()
        styleManager.animationStyle.animationFrom = animationFrom
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
        UIApplication.zq_topWindow()?.zq_topViewController()?.present(self, animated: true, completion: completion)
    }
    
    public func dismissAlertController(completion: (() -> Swift.Void)? = nil) -> Void {
        dismiss(animated: true, completion: completion)
    }
}

// MARK: private
public extension ZQAlertBaseController {
    fileprivate func alertInitialize() -> Void {
        viewWillAppear = false
        presentingViewControllerSupportedInterfaceOrientation = .portrait
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
}

// MARK: action
public extension ZQAlertBaseController {
    @objc fileprivate func actionForPanel() -> Void {
        if styleManager.backgroundStyle.canDismiss {
            dismissAlertController()
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ZQAlertBaseController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator = ZQAlertTransitionAnimator(animationMode: .present)
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.animationMode = .dismiss
        return transitionAnimator
    }
}

