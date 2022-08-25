//
//  Quickly
//

// MARK: IQWindowSecurityView

public protocol IQWindowSecurityView : IQView {
    
    func show(_ complete: @escaping (_ completed: Bool) -> Void)
    func hide(_ complete: @escaping (_ completed: Bool) -> Void)
    
}

// MARK: QWindowSecurityViewType

public typealias QWindowSecurityViewType = UIView & IQWindowSecurityView

// MARK: QWindow

open class QWindow : UIWindow, IQView, IQApplicationStateObserver {

    open var contentViewController: IQViewController {
        set(value) { self._viewController.contentViewController = value }
        get { return self._viewController.contentViewController }
    }
    open var securityView: QWindowSecurityViewType? {
        set(value) { self._viewController.securityView = value }
        get { return self._viewController.securityView }
    }
    
    private var _viewController: RootViewController
    private var _applicationState: QApplicationState
    
    public required init() {
        fatalError("init(coder:) has not been implemented")
    }

    public init(_ contentViewController: IQViewController) {
        self._viewController = RootViewController(contentViewController)
        self._applicationState = QApplicationState()
        super.init(frame: UIScreen.main.bounds)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self._applicationState.remove(observer: self)
    }

    open func setup() {
        self.backgroundColor = UIColor.black
        
        self.rootViewController = self._viewController
        
        self._applicationState.add(observer: self, priority: 0)
    }
    
    // MARK: Private

    private class RootViewController : UIViewController, IQViewControllerDelegate {

        var contentViewController: IQViewController {
            willSet {
                if self.isViewLoaded == true {
                    self.contentViewController.willDismiss(animated: false)
                    self.contentViewController.didDismiss(animated: false)
                    if self.contentViewController.isLoaded == true {
                        self.contentViewController.view.removeFromSuperview()
                    }
                }
            }
            didSet {
                self.contentViewController.delegate = self
                if self.isViewLoaded == true {
                    self.contentViewController.view.frame = self.view.bounds
                    if self._isShowedSecurityView == true {
                        if let securityView = self.securityView {
                            self.view.insertSubview(self.contentViewController.view, belowSubview: securityView)
                        } else {
                            self.view.addSubview(self.contentViewController.view)
                        }
                    } else {
                        self.view.addSubview(self.contentViewController.view)
                    }
                    self.contentViewController.willPresent(animated: false)
                    self.contentViewController.didPresent(animated: false)
                }
            }
        }
        var securityView: QWindowSecurityViewType? {
            willSet {
                if self.isViewLoaded == true && self._isShowedSecurityView == true {
                    if let securityView = self.securityView {
                        securityView.removeFromSuperview()
                    }
                }
            }
            didSet {
                if self.isViewLoaded == true && self._isShowedSecurityView == true {
                    if let securityView = self.securityView {
                        securityView.frame = self.view.bounds
                        self.view.addSubview(securityView)
                    }
                }
            }
        }

        override var prefersStatusBarHidden: Bool {
            get { return self.contentViewController.preferedStatusBarHidden() }
        }
        override var preferredStatusBarStyle: UIStatusBarStyle {
            get { return self.contentViewController.preferedStatusBarStyle() }
        }
        override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            get { return self.contentViewController.preferedStatusBarAnimation() }
        }
        override var shouldAutorotate: Bool {
            get { return true }
        }
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get { return self.contentViewController.supportedOrientations() }
        }
        
        private var _isShowedSecurityView: Bool

        init(_ contentViewController: IQViewController) {
            self.contentViewController = contentViewController
            self._isShowedSecurityView = false
            super.init(nibName: nil, bundle: nil)
            self.setup()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup() {
            self.contentViewController.delegate = self
        }

        override func loadView() {
            self.view = QTransparentView(frame: UIScreen.main.bounds)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            self.contentViewController.view.frame = self.view.bounds
            self.view.addSubview(self.contentViewController.view)
            self.contentViewController.willPresent(animated: false)
            self.contentViewController.didPresent(animated: false)
            
            if self._isShowedSecurityView == true {
                if let securityView = self.securityView {
                    securityView.frame = self.view.bounds
                    self.view.addSubview(securityView)
                }
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
            self.contentViewController.view.frame = self.view.bounds
            
            if let securityView = self.securityView {
                if securityView.superview == self.view {
                    securityView.frame = self.view.bounds
                }
            }
        }

        override func viewSafeAreaInsetsDidChange() {
            self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animate(alongsideTransition: { [unowned self] _ in
                self.contentViewController.willTransition(size: size)
            }, completion: { [unowned self] _ in
                self.contentViewController.didTransition(size: size)
            })
        }
        
        // MARK: Internal

        internal func _currentAdditionalEdgeInsets() -> UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaInsets
            } else {
                return UIEdgeInsets(
                    top: self.topLayoutGuide.length,
                    left: 0,
                    bottom: self.bottomLayoutGuide.length,
                    right: 0
                )
            }
        }
        
        internal func _showSecurityView() {
            if self.isViewLoaded == true && self._isShowedSecurityView == false {
                if let securityView = self.securityView {
                    self._isShowedSecurityView = true
                    securityView.frame = self.view.bounds
                    self.view.addSubview(securityView)
                    securityView.show({ (completed) in
                    })
                }
            }
        }
        
        internal func _hideSecurityView() {
            if self.isViewLoaded == true && self._isShowedSecurityView == true {
                if let securityView = self.securityView {
                    self._isShowedSecurityView = false
                    securityView.hide({ (completed) in
                        securityView.removeFromSuperview()
                    })
                }
            }
        }
        
        // MARK: Private
        
        private func _interfaceOrientation() -> UIInterfaceOrientation {
            let supportedOrientations = self.supportedInterfaceOrientations
            switch UIDevice.current.orientation {
            case .unknown, .portrait, .faceUp, .faceDown:
                if supportedOrientations.contains(.portrait) == true {
                    return .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    return .portraitUpsideDown
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    return .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    return .landscapeRight
                }
                break
            case .portraitUpsideDown:
                if supportedOrientations.contains(.portraitUpsideDown) == true {
                    return .portraitUpsideDown
                } else if supportedOrientations.contains(.portrait) == true {
                    return .portrait
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    return .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    return .landscapeRight
                }
                break
            case .landscapeLeft:
                if supportedOrientations.contains(.landscapeLeft) == true {
                    return .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    return .landscapeRight
                } else if supportedOrientations.contains(.portrait) == true {
                    return .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    return .portraitUpsideDown
                }
                break
            case .landscapeRight:
                if supportedOrientations.contains(.landscapeRight) == true {
                    return .landscapeRight
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    return .landscapeLeft
                } else if supportedOrientations.contains(.portrait) == true {
                    return .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    return .portraitUpsideDown
                }
                break
            @unknown default:
                break
            }
            return .unknown
        }

        // MARK: IQViewControllerDelegate

        func requestUpdateStatusBar(viewController: IQViewController) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        func requestUpdateOrientation(viewController: IQViewController) {
            let interfaceOrientation = self._interfaceOrientation()
            var deviceOrientation = UIDevice.current.orientation
            switch interfaceOrientation {
            case .portrait: deviceOrientation = UIDeviceOrientation.portrait
            case .portraitUpsideDown: deviceOrientation = UIDeviceOrientation.portraitUpsideDown
            case .landscapeLeft: deviceOrientation = UIDeviceOrientation.landscapeLeft
            case .landscapeRight: deviceOrientation = UIDeviceOrientation.landscapeRight
            case .unknown: break
            @unknown default: break
            }
            if deviceOrientation != UIDevice.current.orientation {
                UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
            }
        }

    }
    
    // MARK: IQApplicationStateObserver
    
    open func didReceiveMemoryWarning(_ applicationState: QApplicationState) {
    }
    
    open func didFinishLaunching(_ applicationState: QApplicationState) {
    }
    
    open func didEnterBackground(_ applicationState: QApplicationState) {
    }
    
    open func willEnterForeground(_ applicationState: QApplicationState) {
    }
    
    open func didBecomeActive(_ applicationState: QApplicationState) {
        self._viewController._hideSecurityView()
    }
    
    open func willResignActive(_ applicationState: QApplicationState) {
        self._viewController._showSecurityView()
    }
    
    open func willTerminate(_ applicationState: QApplicationState) {
    }

}
