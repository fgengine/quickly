//
//  Quickly
//

open class QAppWireframe< RouteContextType: IQRouteContext > : IQRootWireframe {

    open private(set) var routeContext: RouteContextType
    open var viewController: IQViewController {
        get { return self.mainViewController }
    }
    open var backgroundViewController: IQViewController? {
        set(value) { self.mainViewController.backgroundViewController = value }
        get { return self.mainViewController.backgroundViewController }
    }
    open var contentViewController: IQViewController? {
        set(value) { self.mainViewController.contentViewController = value }
        get { return self.mainViewController.contentViewController }
    }
    open var modalContainerViewController: IQModalContainerViewController? {
        set(value) { self.mainViewController.modalContainerViewController = value }
        get { return self.mainViewController.modalContainerViewController }
    }
    open var dialogContainerViewController: IQDialogContainerViewController? {
        set(value) { self.mainViewController.dialogContainerViewController = value }
        get { return self.mainViewController.dialogContainerViewController }
    }
    open var pushContainerViewController: IQPushContainerViewController? {
        set(value) { self.mainViewController.pushContainerViewController = value }
        get { return self.mainViewController.pushContainerViewController }
    }

    open private(set) lazy var window: QWindow? = self.prepareWindow()
    open private(set) lazy var mainViewController: QMainViewController = self.prepareMainViewController()
    open var currentWireframe: IQWireframe? {
        didSet {
            if let currentWireframe = self.currentWireframe {
                self.mainViewController.contentViewController = currentWireframe.viewController
            } else {
                self.mainViewController.contentViewController = nil
            }
            if let window = self.window {
                if window.isKeyWindow == false {
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    public init(_ routeContext: RouteContextType) {
        self.routeContext = routeContext
    }

    open func launch(_ options: [UIApplicationLaunchOptionsKey : Any]?) {
        fatalError("Required override function '\(#function)'")
    }

    private func prepareWindow() -> QWindow? {
        return QWindow(self.mainViewController)
    }

    private func prepareMainViewController() -> QMainViewController {
        return QMainViewController()
    }

}
