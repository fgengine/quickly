//
//  Quickly
//

open class QStackWireframe< RouteContextType: IQRouteContext, WireframeType: IQWireframe > : IQChildWireframe {

    open var viewController: IQViewController {
        get { return self.containerViewController }
    }
    open private(set) var routeContext: RouteContextType
    open private(set) weak var parentWireframe: WireframeType?

    open private(set) lazy var containerViewController: QStackContainerViewController = self.prepareContainerViewController()

    public init(_ routeContext: RouteContextType, _ parentWireframe: WireframeType) {
        self.routeContext = routeContext
        self.parentWireframe = parentWireframe
    }

    private func prepareContainerViewController() -> QStackContainerViewController {
        return QStackContainerViewController(self.prepareRootViewController())
    }

    open func prepareRootViewController() -> IQStackViewController {
        return QStackViewController(self.prepareRootContentViewController())
    }

    open func prepareRootContentViewController() -> IQStackContentViewController {
        fatalError("Please override prepareRootContentViewController()")
    }

    open func present(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func present(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func dismiss(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismiss(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

}
