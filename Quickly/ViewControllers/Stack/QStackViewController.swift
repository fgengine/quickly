//
//  Quickly
//

import UIKit

open class QStackViewController : UINavigationController, IQViewController {

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
    }

    open override var prefersStatusBarHidden: Bool {
        get {
            if let viewController: UIViewController = self.topViewController {
                return viewController.prefersStatusBarHidden
            }
            return super.prefersStatusBarHidden
        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if let viewController: UIViewController = self.topViewController {
                return viewController.preferredStatusBarStyle
            }
            return super.preferredStatusBarStyle
        }
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            if let viewController: UIViewController = self.topViewController {
                return viewController.preferredStatusBarUpdateAnimation
            }
            return super.preferredStatusBarUpdateAnimation
        }
    }

    open override var shouldAutorotate: Bool {
        get {
            if let viewController: UIViewController = self.topViewController {
                return viewController.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if let viewController: UIViewController = self.topViewController {
                return viewController.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }

}
