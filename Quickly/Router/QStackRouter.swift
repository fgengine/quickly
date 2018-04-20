//
//  Quickly
//

open class QStackRouter< ContainerType: IQContainer, RouterType: IQRouter > : IQRouter {

    open var container: ContainerType
    open weak var router: RouterType?
    open var viewController: IQViewController {
        get { return self.stackViewController }
    }

    open private(set) lazy var stackViewController: QStackViewController = self.prepareStackViewController()

    public required init(container: ContainerType, router: RouterType) {
        self.container = container
        self.router = router
    }

    private func prepareStackViewController() -> QStackViewController {
        return QStackViewController(rootViewController: self.prepareRootPageViewController())
    }

    open func prepareRootPageViewController() -> IQStackPageViewController {
        return QStackPageViewController(contentViewController: self.prepareRootViewController())
    }

    open func prepareRootViewController() -> IQStackContentViewController {
        fatalError("Please override prepareRootViewController()")
    }

    open func present(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.stackViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func present(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.stackViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func dismiss(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.stackViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismiss(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.stackViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

}
