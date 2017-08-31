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
    open var navigationBarHidden: Bool = false
    open var toolbarHidden: Bool = true
    open var isAppeared: Bool = false

    public init() {
        super.init(nibName: nil, bundle: nil)
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

    open func currentNibName() -> String {
        if let nibName: String = self.nibName {
            return nibName
        }
        return String(describing: self.classForCoder)
    }

    open func currentNibBundle() -> Bundle {
        if let nibBundle: Bundle = self.nibBundle {
            return nibBundle
        }
        return Bundle.main
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

    open override func loadView() {
        let nibName: String = self.currentNibName()
        let bundle: Bundle = self.currentNibBundle()
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        _ = nib.instantiate(withOwner: self, options: nil)
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
