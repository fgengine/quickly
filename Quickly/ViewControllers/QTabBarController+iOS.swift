//
//  Quickly
//

#if os(iOS)

    open class QTabBarController : UITabBarController, IQBaseViewController {

        private lazy var proxy: Proxy = Proxy(viewController: self)

        open override weak var delegate: UITabBarControllerDelegate? {
            set(value) { self.proxy.delegate = value }
            get { return self.proxy.delegate }
        }

        open var currentViewController: UIViewController? {
            set(value) {
                var selectedIndex: Int = 0
                if let currentViewController: UIViewController = value {
                    if let viewControllers: [UIViewController] = self.viewControllers {
                        if let index: Int = viewControllers.index(of: currentViewController) {
                            selectedIndex = index
                        }
                    }
                }
                self.selectedIndex = selectedIndex
            }
            get {
                if let viewControllers: [UIViewController] = self.viewControllers {
                    return viewControllers[self.selectedIndex]
                }
                return nil
            }
        }

        public init(viewControllers: [UIViewController]) {
            super.init(nibName: nil, bundle: nil)
            self.viewControllers = viewControllers
        }

        public override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        open func setup() {
            super.delegate = self.proxy
        }

        open override var prefersStatusBarHidden: Bool {
            get {
                if let viewController: UIViewController = self.currentViewController {
                    return viewController.prefersStatusBarHidden
                }
                return super.prefersStatusBarHidden
            }
        }

        open override var preferredStatusBarStyle: UIStatusBarStyle {
            get {
                if let viewController: UIViewController = self.currentViewController {
                    return viewController.preferredStatusBarStyle
                }
                return super.preferredStatusBarStyle
            }
        }

        open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            get {
                if let viewController: UIViewController = self.currentViewController {
                    return viewController.preferredStatusBarUpdateAnimation
                }
                return super.preferredStatusBarUpdateAnimation
            }
        }

        open override var shouldAutorotate: Bool {
            get {
                if let viewController: UIViewController = self.currentViewController {
                    return viewController.shouldAutorotate
                }
                return super.shouldAutorotate
            }
        }

        open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get {
                if let viewController: UIViewController = self.currentViewController {
                    return viewController.supportedInterfaceOrientations
                }
                return super.supportedInterfaceOrientations
            }
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

        private class Proxy: NSObject, UITabBarControllerDelegate {

            public weak var viewController: QTabBarController?
            public weak var delegate: UITabBarControllerDelegate?
            private var previousViewController: UIViewController?

            public init(viewController: QTabBarController?) {
                self.viewController = viewController
                super.init()
            }

            public override func responds(to selector: Selector!) -> Bool {
                if super.responds(to: selector) {
                    return true
                }
                if let delegate: UITabBarControllerDelegate = self.delegate {
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
                if let delegate: UITabBarControllerDelegate = self.delegate {
                    if delegate.responds(to: selector) {
                        return delegate
                    }
                }
                return nil
            }

            public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                if self.previousViewController != viewController {
                    if let pvc: UIViewController = self.previousViewController {
                        self.previousViewController = pvc
                        if let vc: IQBaseViewController = pvc as? IQBaseViewController {
                            vc.willDismiss(animated: false)
                            vc.didDismiss(animated: false)
                        }
                    }
                    if let vc: IQBaseViewController = viewController as? IQBaseViewController {
                        vc.willPresent(animated: false)
                        vc.didPresent(animated: false)
                    }
                }
                if let delegate: UITabBarControllerDelegate = self.delegate {
                    if let selector = delegate.tabBarController(_:didSelect:) {
                        selector(tabBarController, viewController)
                    }
                }
            }

        }

    }

#endif
