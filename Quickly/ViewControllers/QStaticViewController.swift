//
//  Quickly
//

open class QStaticViewController : QPlatformViewController, IQViewController {

    #if os(macOS)

    @IBOutlet open var rootView: QPlatformView? {
        set(value) { if let view = value { self.view = view } }
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
        if let nibName = self.nibName {
            return nibName
        }
        return NSNib.Name(rawValue: String(describing: self.classForCoder))
    }

    #elseif os(iOS)

    open func currentNibName() -> String {
        if let nibName = self.nibName {
            return nibName
        }
        return String(describing: self.classForCoder)
    }

    #endif

    open func currentNibBundle() -> Bundle {
        if let nibBundle = self.nibBundle {
            return nibBundle
        }
        return Bundle.main
    }

    open func setup() {
    }

    #if os(iOS)

    open func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.setNavigationBarHidden(hidden, animated: animated)
        }
        self.navigationBarHidden = hidden
    }

    open func setToolbarHidden(_ hidden: Bool, animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.setToolbarHidden(hidden, animated: animated)
        }
        self.toolbarHidden = hidden
    }

    #endif

    open override func loadView() {
        #if os(macOS)
            let nibName = self.currentNibName()
            let bundle = self.currentNibBundle()
            guard let nib = NSNib(nibNamed: nibName, bundle: bundle) else { return }
            nib.instantiate(withOwner: self, topLevelObjects: nil)
        #elseif os(iOS)
            let nibName = self.currentNibName()
            let bundle = self.currentNibBundle()
            let nib = UINib(nibName: nibName, bundle: bundle)
            _ = nib.instantiate(withOwner: self, options: nil)
        #endif
    }

    #if os(iOS)

        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.isAppeared = true
            if let navigationController = self.navigationController {
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

}
