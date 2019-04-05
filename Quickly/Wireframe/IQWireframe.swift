//
//  Quickly
//

public protocol IQWireframe : class {
    
    var viewController: IQViewController { get }
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
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
