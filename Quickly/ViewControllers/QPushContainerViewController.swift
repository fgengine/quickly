//
//  Quickly
//

open class QPushContainerViewController : QPlatformViewController, IQPushContainerViewController {

    public typealias PushViewControllerType = QPlatformViewController & IQPushViewController

    open var pushViewControllers: [PushViewControllerType] = []
    open var currentPushViewController: PushViewControllerType? {
        get { return self.pushViewControllers.first }
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

    open func present(pushViewController: PushViewControllerType, animated: Bool, completion: (() -> Void)?) {
    }

    open func dismiss(pushViewController: PushViewControllerType, animated: Bool, completion: (() -> Void)?) {
    }

    internal func appearViewController(_ viewController: PushViewControllerType) {
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        #if os(iOS)
            viewController.didMove(toParentViewController: self)
        #endif
    }

    internal func disappearViewController(_ viewController: PushViewControllerType) {
        #if os(iOS)
            viewController.willMove(toParentViewController: nil)
        #endif
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
