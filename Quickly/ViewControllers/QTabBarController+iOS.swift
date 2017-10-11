//
//  Quickly
//

#if os(iOS)

    import UIKit

    open class QTabBarController : UITabBarController, IQViewController {

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

    }

#endif
