//
//  Quickly
//

open class QStaticViewController : QPlatformViewController, IQViewController {

    #if os(macOS)

        @IBOutlet open var rootView: QPlatformView? {
            set(view) { if let view: QPlatformView = view { self.view = view } }
            get { return self.view }
        }

    #elseif os(iOS)

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

    #endif

    open var isAppeared: Bool = false

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    #if os(macOS)

        public override init(nibName: NSNib.Name?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            self.setup()
        }

    #elseif os(iOS)

        public override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            self.setup()
        }

    #endif

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    #if os(macOS)

        open func currentNibName() -> NSNib.Name {
            if let nibName: NSNib.Name = self.nibName {
                return nibName
            }
            return NSNib.Name(rawValue: String(describing: self.classForCoder))
        }

    #elseif os(iOS)

        open func currentNibName() -> String {
            if let nibName: String = self.nibName {
                return nibName
            }
            return String(describing: self.classForCoder)
        }

    #endif

    open func currentNibBundle() -> Bundle {
        if let nibBundle: Bundle = self.nibBundle {
            return nibBundle
        }
        return Bundle.main
    }

    open func setup() {
        #if os(iOS)
            self.edgesForExtendedLayout = []
        #endif
    }

    #if os(iOS)

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

    #endif

    open override func loadView() {
        #if os(macOS)
            let nibName: NSNib.Name = self.currentNibName()
            let bundle: Bundle = self.currentNibBundle()
            guard let nib: NSNib = NSNib(nibNamed: nibName, bundle: bundle) else {
                return
            }
            nib.instantiate(withOwner: self, topLevelObjects: nil)
        #elseif os(iOS)
            let nibName: String = self.currentNibName()
            let bundle: Bundle = self.currentNibBundle()
            let nib: UINib = UINib(nibName: nibName, bundle: bundle)
            _ = nib.instantiate(withOwner: self, options: nil)
        #endif
    }

    #if os(iOS)

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

    #endif

    open func willPresent(animated: Bool) {
    }

    open func didPresent(animated: Bool) {
    }

    open func willDismiss(animated: Bool) {
    }

    open func didDismiss(animated: Bool) {
    }

}
