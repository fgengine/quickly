//
//  Quickly
//

// MARK: - IQWireframe -

public protocol IQWireframe : class {

    var viewController: IQViewController { get }

    func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQRouteWireframe -

public protocol IQRootWireframe : IQWireframe {

    associatedtype RouteContextType: IQRouteContext

    var routeContext: RouteContextType { get }
    var backgroundViewController: IQViewController? { set get }
    var contentViewController: IQViewController? { set get }
    var modalContainerViewController: IQModalContainerViewController? { set get }
    var dialogContainerViewController: IQDialogContainerViewController? { set get }
    var pushContainerViewController: IQPushContainerViewController? { set get }

}

extension IQRootWireframe {

    public func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.presentModal(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.dismissModal(viewController: viewController, animated: animated, completion: completion)
    }

    public func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.presentDialog(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.dismissDialog(viewController: viewController, animated: animated, completion: completion)
    }

    public func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.presentPush(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.dismissPush(viewController: viewController, animated: animated, completion: completion)
    }

}

// MARK: - IQChildWireframe -

public protocol IQChildWireframe : IQWireframe {

    associatedtype RouteContextType: IQRouteContext
    associatedtype WireframeType: IQWireframe

    var routeContext: RouteContextType { get }
    var parentWireframe: WireframeType? { get }

}

extension IQChildWireframe {

    public func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.presentModal(viewController, animated: animated, completion: completion)
    }

    public func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.dismissModal(viewController, animated: animated, completion: completion)
    }

    public func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.presentDialog(viewController, animated: animated, completion: completion)
    }

    public func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.dismissDialog(viewController, animated: animated, completion: completion)
    }

    public func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.presentPush(viewController, animated: animated, completion: completion)
    }

    public func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.parentWireframe?.dismissPush(viewController, animated: animated, completion: completion)
    }

}
