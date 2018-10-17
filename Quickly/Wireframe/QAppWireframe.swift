//
//  Quickly
//

open class QAppWireframe< ContextType: IQContext > : IQAppWireframe {
    
    open var baseViewController: IQViewController {
        get { return self.viewController }
    }
    open private(set) var viewController: QMainViewController = QMainViewController()
    open private(set) var context: ContextType
    open var backgroundViewController: IQViewController? {
        set(value) { self.viewController.backgroundViewController = value }
        get { return self.viewController.backgroundViewController }
    }
    open var contentViewController: IQViewController? {
        set(value) { self.viewController.contentViewController = value }
        get { return self.viewController.contentViewController }
    }
    open var modalContainerViewController: IQModalContainerViewController? {
        set(value) { self.viewController.modalContainerViewController = value }
        get { return self.viewController.modalContainerViewController }
    }
    open var dialogContainerViewController: IQDialogContainerViewController? {
        set(value) { self.viewController.dialogContainerViewController = value }
        get { return self.viewController.dialogContainerViewController }
    }
    open var pushContainerViewController: IQPushContainerViewController? {
        set(value) { self.viewController.pushContainerViewController = value }
        get { return self.viewController.pushContainerViewController }
    }

    open private(set) var window: QWindow
    
    open var current: IQBaseWireframe? {
        didSet {
            if let current = self.current {
                self.viewController.contentViewController = current.baseViewController
            } else {
                self.viewController.contentViewController = nil
            }
        }
    }

    public init(
        context: ContextType
    ) {
        self.viewController = QMainViewController()
        self.context = context
        self.window = QWindow(self.viewController)
        self.setup()
    }
    
    open func setup() {
    }

    open func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?) {
        if self.window.isKeyWindow == false {
            self.window.makeKeyAndVisible()
        }
    }

}
