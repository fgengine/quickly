//
//  Quickly
//

open class QMainViewController : QPlatformViewController, IQBaseViewController {

    public typealias ContentViewControllerType = QPlatformViewController & IQBaseViewController
    public typealias PushContainerViewControllerType = QPlatformViewController & IQBaseViewController & IQPushContainerViewController
    public typealias DialogContainerViewControllerType = QPlatformViewController & IQBaseViewController & IQDialogContainerViewController

    open var contentViewController: ContentViewControllerType? {
        willSet {
            guard let vc: ContentViewControllerType = self.contentViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self.disappearViewController(vc)
        }
        didSet {
            guard let vc: ContentViewControllerType = self.contentViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self.appearViewController(contentViewController: vc)
        }
    }
    open var pushContainerViewController: PushContainerViewControllerType? {
        willSet {
            guard let vc: PushContainerViewControllerType = self.pushContainerViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self.disappearViewController(vc)
        }
        didSet {
            guard let vc: PushContainerViewControllerType = self.pushContainerViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self.appearViewController(pushContainerViewController: vc)
        }
    }
    open var dialogContainerViewController: DialogContainerViewControllerType? {
        willSet {
            guard let vc: DialogContainerViewControllerType = self.dialogContainerViewController, self.isViewLoaded == true else { return }
            vc.willDismiss(animated: false)
            vc.didDismiss(animated: false)
            self.disappearViewController(vc)
        }
        didSet {
            guard let vc: DialogContainerViewControllerType = self.dialogContainerViewController, self.isViewLoaded == true else { return }
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
            self.appearViewController(dialogContainerViewController: vc)
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
            self.appearViewController(contentViewController: vc)
        }
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            self.appearViewController(pushContainerViewController: vc)
        }
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            self.appearViewController(dialogContainerViewController: vc)
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bounds: CGRect = self.view.bounds
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

    private func appearViewController(contentViewController: ContentViewControllerType) {
        self.addChildViewController(contentViewController)
        contentViewController.view.frame = self.view.bounds
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            self.view.insertSubview(contentViewController.view, belowSubview: vc.view)
        } else if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            self.view.insertSubview(contentViewController.view, belowSubview: vc.view)
        } else {
            self.view.addSubview(contentViewController.view)
        }
        #if os(iOS)
            contentViewController.didMove(toParentViewController: self)
        #endif
    }

    private func appearViewController(pushContainerViewController: PushContainerViewControllerType) {
        self.addChildViewController(pushContainerViewController)
        pushContainerViewController.view.frame = self.view.bounds
        if let vc: DialogContainerViewControllerType = self.dialogContainerViewController {
            self.view.insertSubview(pushContainerViewController.view, aboveSubview: vc.view)
        } else if let vc: ContentViewControllerType = self.contentViewController {
            self.view.insertSubview(pushContainerViewController.view, aboveSubview: vc.view)
        } else {
            self.view.addSubview(pushContainerViewController.view)
        }
        #if os(iOS)
            pushContainerViewController.didMove(toParentViewController: self)
        #endif
    }

    private func appearViewController(dialogContainerViewController: DialogContainerViewControllerType) {
        self.addChildViewController(dialogContainerViewController)
        dialogContainerViewController.view.frame = self.view.bounds
        if let vc: PushContainerViewControllerType = self.pushContainerViewController {
            self.view.insertSubview(dialogContainerViewController.view, belowSubview: vc.view)
        } else if let vc: ContentViewControllerType = self.contentViewController {
            self.view.insertSubview(dialogContainerViewController.view, aboveSubview: vc.view)
        } else {
            self.view.addSubview(dialogContainerViewController.view)
        }
        #if os(iOS)
            dialogContainerViewController.didMove(toParentViewController: self)
        #endif
    }

    private func disappearViewController(_ viewController: QPlatformViewController) {
        #if os(iOS)
            viewController.willMove(toParentViewController: nil)
        #endif
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
