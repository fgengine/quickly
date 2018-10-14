//
//  Quickly
//

// MARK: - IQWireframe -

public protocol IQBaseWireframe : class {

    var baseViewController: IQViewController { get }
    
    func setup()

    func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQWireframe -

public protocol IQWireframe : IQBaseWireframe {
    
    associatedtype ViewControllerType: IQViewController
    
    var viewController: ViewControllerType { get }
    
}

// MARK: - IQRootWireframe -

public protocol IQRootWireframe : IQWireframe {

    associatedtype ContextType: IQContext

    var context: ContextType { get }
    var backgroundViewController: IQViewController? { set get }
    var contentViewController: IQViewController? { set get }
    var modalContainerViewController: IQModalContainerViewController? { set get }
    var dialogContainerViewController: IQDialogContainerViewController? { set get }
    var pushContainerViewController: IQPushContainerViewController? { set get }

}

extension IQRootWireframe {

    public func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.presentModal(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.dismissModal(viewController: viewController, animated: animated, completion: completion)
    }

    public func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.presentDialog(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.dismissDialog(viewController: viewController, animated: animated, completion: completion)
    }

    public func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.presentPush(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.dismissPush(viewController: viewController, animated: animated, completion: completion)
    }

}

// MARK: - IQChildWireframe -

public protocol IQChildWireframe : IQWireframe {

    associatedtype ContextType: IQContext
    associatedtype ParentType: IQWireframe

    var context: ContextType { get }
    var parent: ParentType? { get }

}

extension IQChildWireframe {

    public func presentModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.presentModal(viewController, animated: animated, completion: completion)
    }

    public func dismissModal(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.dismissModal(viewController, animated: animated, completion: completion)
    }

    public func presentDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.presentDialog(viewController, animated: animated, completion: completion)
    }

    public func dismissDialog(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.dismissDialog(viewController, animated: animated, completion: completion)
    }

    public func presentPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.presentPush(viewController, animated: animated, completion: completion)
    }

    public func dismissPush(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parentWireframe = self.parent else { return }
        parentWireframe.dismissPush(viewController, animated: animated, completion: completion)
    }

}
