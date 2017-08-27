//
//  Quickly
//

import UIKit

open class QStaticViewController : UIViewController, IQContentViewController {

    open var statusBarHidden: Bool = false {
        didSet { self.setNeedsStatusBarAppearanceUpdate() }
    }
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet { self.setNeedsStatusBarAppearanceUpdate() }
    }
    open var statusBarAnimation: UIStatusBarAnimation = .fade {
        didSet { self.setNeedsStatusBarAppearanceUpdate() }
    }
    open var supportedOrientationMask: UIInterfaceOrientationMask = .portrait
    open var navigationBarHidden: Bool = true
    open var toolbarHidden: Bool = true
    open var isAppeared: Bool = false

    public init() {
        super.init(nibName: QStaticViewController.currentNibName(), bundle: QStaticViewController.currentNibBundle())
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

    open class func currentNibName() -> String {
        return String(describing: self)
    }

    open class func currentNibBundle() -> Bundle? {
        return nil
    }

    open func setup() {
        self.edgesForExtendedLayout = []
    }

    open func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        if let navigationController: UINavigationController = self.navigationController {
            navigationController.setNavigationBarHidden(hidden, animated: animated)
        }
        self.navigationBarHidden = hidden
    }

    open func setToolbarHidden(_ hidden: Bool, animated: Bool) {
        if let navigationController: UINavigationController = self.navigationController {
            navigationController.setToolbarHidden(hidden, animated: animated)
        }
        self.toolbarHidden = hidden
    }

    open override var prefersStatusBarHidden: Bool {
        get { return self.statusBarHidden }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return self.statusBarStyle }
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get { return self.statusBarAnimation }
    }

    open override var shouldAutorotate: Bool {
        get { return true }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return self.supportedOrientationMask }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAppeared = true
        if let navigationController: UINavigationController = self.navigationController {
            navigationController.isNavigationBarHidden = self.navigationBarHidden
            navigationController.isToolbarHidden = self.toolbarHidden
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isAppeared = false
    }

}
