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

    open func presentStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(to: viewController, animated: animated, completion: completion)
    }

    open func dismissStack(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.dismissStack(to: viewController, animated: animated, completion: completion)
    }

}
