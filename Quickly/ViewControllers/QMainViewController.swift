//
//  Quickly
//

open class QMainViewController : QPlatformViewController, IQBaseViewController {

    public typealias ContentViewControllerType = QPlatformViewController & IQBaseViewController
    public typealias PushContainerViewControllerType = QPlatformViewController & IQBaseViewController & IQPushContainerViewController
    public typealias DialogContainerViewControllerType = QPlatformViewController & IQBaseViewController & IQDialogContainerViewController

    #if os(iOS)
    open override var prefersStatusBarHidden: Bool {
        get {
            guard
                let cvc: ContentViewControllerType = self.contentViewController
                else { return super.prefersStatusBarHidden }
            guard
                let dvc: DialogContainerViewControllerType = self.dialogContainerViewController,
                let cdvc: DialogContainerViewControllerType.ViewControllerType = dvc.currentViewController
                else { return cvc.prefersStatusBarHidden }
            return cdvc.prefersStatusBarHidden
        }
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            guard
                let cvc: ContentViewControllerType = self.contentViewController
                else { return super.preferredStatusBarStyle }
            guard
                let dvc: DialogContainerViewControllerType = self.dialogContainerViewController,
                let cdvc: DialogContainerViewControllerType.ViewControllerType = dvc.currentViewController
                else { return cvc.preferredStatusBarStyle }
            return cdvc.preferredStatusBarStyle
        }
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            guard
                let cvc: ContentViewControllerType = self.contentViewController
                else { return super.preferredStatusBarUpdateAnimation }
            guard
                let dvc: DialogContainerViewControllerType = self.dialogContainerViewController,
                let cdvc: DialogContainerViewControllerType.ViewControllerType = dvc.currentViewController
                else { return cvc.preferredStatusBarUpdateAnimation }
            return cdvc.preferredStatusBarUpdateAnimation
        }
    }
    open override var shouldAutorotate: Bool {
        get {
            guard
                let cvc: ContentViewControllerType = self.contentViewController
                else { return super.shouldAutorotate }
            return cvc.shouldAutorotate
        }
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            guard
                let cvc: ContentViewControllerType = self.contentViewController
                else { return super.supportedInterfaceOrientations }
            return cvc.supportedInterfaceOrientations
        }
    }
    #endif
    open var contentViewController: ContentViewControllerType? {
        willSet {
            guard let vc: ContentViewControllerType = self.contentViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self._disappearViewController(vc)
        }
        didSet {
            #if os(iOS)
                defer {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            #endif
            guard let vc: ContentViewControllerType = self.contentViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self._appearViewController(contentViewController: vc)
        }
    }
    open var pushContainerViewController: PushContainerViewControllerType? {
        willSet {
            guard let vc: PushContainerViewControllerType = self.pushContainerViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self._disappearViewController(vc)
        }
        didSet {
            #if os(iOS)
                defer {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            #endif
            guard let vc: PushContainerViewControllerType = self.pushContainerViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self._appearViewController(pushContainerViewController: vc)
        }
    }
    open var dialogContainerViewController: DialogContainerViewControllerType? {
        willSet {
            guard let vc: DialogContainerViewControllerType = self.dialogContainerViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self._disappearViewController(vc)
        }
        didSet {
            #if os(iOS)
                defer {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            #endif
            guard let vc: DialogContainerViewControllerType = self.dialogContainerViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self._appearViewController(dialogContainerViewController: vc)
        }
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

    open func setup() {
    }

    open override func loadView() {
        self.view = QTransparentView()

        if let vc: ContentViewControllerType = self.contentViewController {
            self._appearViewController(contentViewController: vc)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            self._appearViewController(pushContainerViewController: vc)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            self._appearViewController(dialogContainerViewController: vc)
        }
    }

    #if os(macOS)

    open override func viewDidLayout() {
        super.viewDidLayout()
        self._layoutViewControllers(self.view.bounds)
    }

    #elseif os(iOS)

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._layoutViewControllers(self.view.bounds)
    }

    #endif

    open func willPresent(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).willPresent(animated: \(animated))")
        #endif
        if let vc: ContentViewControllerType = self.contentViewController {
            vc.willPresent(animated: animated)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            vc.willPresent(animated: animated)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            vc.willPresent(animated: animated)
        }
    }

    open func didPresent(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).didPresent(animated: \(animated))")
        #endif
        if let vc: ContentViewControllerType = self.contentViewController {
            vc.didPresent(animated: animated)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            vc.didPresent(animated: animated)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            vc.didPresent(animated: animated)
        }
    }

    open func willDismiss(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).willDismiss(animated: \(animated))")
        #endif
        if let vc: ContentViewControllerType = self.contentViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            vc.willDismiss(animated: animated)
        }
    }

    open func didDismiss(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).didDismiss(animated: \(animated))")
        #endif
        if let vc: ContentViewControllerType = self.contentViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            vc.didDismiss(animated: animated)
        }
    }

    private func _appearViewController(contentViewController: ContentViewControllerType) {
        self.addChildViewController(contentViewController)
        contentViewController.view.frame = self.view.bounds
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(contentViewController.view, positioned: .below, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(contentViewController.view, belowSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(contentViewController.view)
            }
        } else if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(contentViewController.view, positioned: .below, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(contentViewController.view, belowSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(contentViewController.view)
            }
        } else {
            self.view.addSubview(contentViewController.view)
        }
        #if os(iOS)
            contentViewController.didMove(toParentViewController: self)
        #endif
    }

    private func _appearViewController(pushContainerViewController: PushContainerViewControllerType) {
        self.addChildViewController(pushContainerViewController)
        pushContainerViewController.view.frame = self.view.bounds
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(pushContainerViewController.view, positioned: .above, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(pushContainerViewController.view, aboveSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(pushContainerViewController.view)
            }
        } else if let vc: ContentViewControllerType = self.contentViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(pushContainerViewController.view, positioned: .above, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(pushContainerViewController.view, aboveSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(pushContainerViewController.view)
            }
        } else {
            self.view.addSubview(pushContainerViewController.view)
        }
        #if os(iOS)
            pushContainerViewController.didMove(toParentViewController: self)
        #endif
    }

    private func _appearViewController(dialogContainerViewController: DialogContainerViewControllerType) {
        self.addChildViewController(dialogContainerViewController)
        dialogContainerViewController.view.frame = self.view.bounds
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(dialogContainerViewController.view, positioned: .below, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(dialogContainerViewController.view, belowSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(dialogContainerViewController.view)
            }
        } else if let vc: ContentViewControllerType = self.contentViewController {
            if vc.view.superview == self.view {
                #if os(macOS)
                    self.view.addSubview(dialogContainerViewController.view, positioned: .above, relativeTo: vc.view)
                #elseif os(iOS)
                    self.view.insertSubview(dialogContainerViewController.view, belowSubview: vc.view)
                #endif
            } else {
                self.view.addSubview(dialogContainerViewController.view)
            }
        } else {
            self.view.addSubview(dialogContainerViewController.view)
        }
        #if os(iOS)
            dialogContainerViewController.didMove(toParentViewController: self)
        #endif
    }

    private func _disappearViewController(_ viewController: QPlatformViewController) {
        #if os(iOS)
            viewController.willMove(toParentViewController: nil)
        #endif
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    private func _layoutViewControllers(_ bounds: CGRect) {
        if let vc: ContentViewControllerType = self.contentViewController {
            vc.view.frame = bounds
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            vc.view.frame = bounds
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            vc.view.frame = bounds
        }
    }

}
