//
//  Quickly
//

// MARK: - IQWireframe -

public protocol IQBaseWireframe : class {

    var presentableViewController: IQViewController { get }
    
    func setup()
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

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

    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

}

// MARK: - IQChildWireframe -

public protocol IQChildWireframe : IQWireframe {

    associatedtype ParentType: IQWireframe
    associatedtype ContextType: IQContext

    var parent: ParentType? { get }
    var context: ContextType { get }

}

extension IQChildWireframe {
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        guard let parent = self.parent else { return }
        parent.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        guard let parent = self.parent else { return }
        parent.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.present(viewController: viewController, animated: animated, completion: completion)
    }

    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let parent = self.parent else { return }
        parent.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

}
