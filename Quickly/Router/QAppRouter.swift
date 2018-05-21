//
//  Quickly
//

open class QAppRouter< ContainerType: IQContainer > : IQRouter {

    open var container: ContainerType
    open var viewController: IQViewController {
        get { return self.mainViewController }
    }

    open lazy var window: QWindow? = self.prepareWindow()
    open lazy var mainViewController: QMainViewController = self.prepareMainViewController()
    open var currentRouter: IQRouter? {
        didSet {
            if let currentRouter = self.currentRouter {
                self.mainViewController.contentViewController = currentRouter.viewController
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

    public init(container: ContainerType) {
        self.container = container
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
