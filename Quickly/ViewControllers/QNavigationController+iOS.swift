//
//  Quickly
//

#if os(iOS)

    open class QNavigationController : UINavigationController, IQBaseViewController {

        private lazy var proxy: Proxy = Proxy(viewController: self)

        open override weak var delegate: UINavigationControllerDelegate? {
            set(value) { self.proxy.delegate = value }
            get { return (self.proxy.delegate != nil) ? self.proxy.delegate : self.proxy }
        }
        open override var prefersStatusBarHidden: Bool {
            get {
                if let viewController = self.topViewController {
                    return viewController.prefersStatusBarHidden
                }
                return super.prefersStatusBarHidden
            }
        }
        open override var preferredStatusBarStyle: UIStatusBarStyle {
            get {
                if let viewController = self.topViewController {
                    return viewController.preferredStatusBarStyle
                }
                return super.preferredStatusBarStyle
            }
        }
        open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            get {
                if let viewController = self.topViewController {
                    return viewController.preferredStatusBarUpdateAnimation
                }
                return super.preferredStatusBarUpdateAnimation
            }
        }
        open override var shouldAutorotate: Bool {
            get {
                if let viewController = self.topViewController {
                    return viewController.shouldAutorotate
                }
                return super.shouldAutorotate
            }
        }
        open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get {
                if let viewController = self.topViewController {
                    return viewController.supportedInterfaceOrientations
                }
                return super.supportedInterfaceOrientations
            }
        }

        public init() {
            super.init(nibName: nil, bundle: nil)
            self.setup()
        }

        public override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
            self.setup()
        }

        public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
            super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
            self.setup()
        }

        public override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        public func setup() {
            super.delegate = self.proxy
        }

        open func willPresent(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).willPresent(animated: \(animated))")
            #endif
        }

        open func didPresent(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).didPresent(animated: \(animated))")
            #endif
        }

        open func willDismiss(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).willDismiss(animated: \(animated))")
            #endif
        }

        open func didDismiss(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).didDismiss(animated: \(animated))")
            #endif
        }

        open func removeViewController(_ viewController: UIViewController, animated: Bool) {
            if let topViewController = self.topViewController {
                if viewController != topViewController {
                    var viewControllers = self.viewControllers
                    if let index = viewControllers.index(of: viewController) {
                        viewControllers.remove(at: index)
                        self.setViewControllers(viewControllers, animated: false)
                    }
                } else {
                    _ = self.popViewController(animated: animated)
                }
            }
        }

        private class Proxy: NSObject, UINavigationControllerDelegate {

            public weak var viewController: QNavigationController?
            public weak var delegate: UINavigationControllerDelegate?
            private var previousViewController: UIViewController?

            public init(viewController: QNavigationController?) {
                self.viewController = viewController
            }

            public override func responds(to selector: Selector!) -> Bool {
                if super.responds(to: selector) {
                    return true
                }
                if let delegate = self.delegate {
                    if delegate.responds(to: selector) {
                        return true
                    }
                }
                return false
            }

            public override func forwardingTarget(for selector: Selector!) -> Any? {
                if super.responds(to: selector) {
                    return self
                }
                if let delegate = self.delegate {
                    if delegate.responds(to: selector) {
                        return delegate
                    }
                }
                return nil
            }

            public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
                if self.previousViewController != viewController {
                    if let vc = self.previousViewController as? IQBaseViewController {
                        vc.willDismiss(animated: animated)
                    }
                    if let vc = viewController as? IQBaseViewController {
                        vc.willPresent(animated: animated)
                    }
                }
                if let delegate = self.delegate {
                    if let selector = delegate.navigationController(_:willShow:animated:) {
                        selector(navigationController, viewController, animated)
                    }
                }
            }

            public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
                if self.previousViewController != viewController {
                    if let vc = self.previousViewController as? IQBaseViewController {
                        vc.didDismiss(animated: animated)
                    }
                    self.previousViewController = viewController
                    if let vc = viewController as? IQBaseViewController {
                        vc.didPresent(animated: animated)
                    }
                }
                if let delegate = self.delegate {
                    if let selector = delegate.navigationController(_:didShow:animated:) {
                        selector(navigationController, viewController, animated)
                    }
                }
            }

        }

    }

#endif
