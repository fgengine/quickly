//
//  Quickly
//

open class QHamburgerWireframe< RouterType: IQRouter, ContextType: IQContext > : IQWireframe, IQWeakRouterable, IQContextable {

    public private(set) var viewController: QHamburgerContainerViewController
    public private(set) weak var router: RouterType?
    public private(set) var context: ContextType

    public init(
        router: RouterType,
        context: ContextType
    ) {
        self.viewController = QHamburgerContainerViewController()
        self.router = router
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }
    
    open func open(_ url: URL) -> Bool {
        return true
    }

}

// MARK: IQRouter

extension QHamburgerWireframe : IQRouter where RouterType : IQRouter {
}

// MARK: IQWireframePresetable

extension QHamburgerWireframe : IQWireframeDefaultRouter where RouterType : IQWireframeDefaultRouter {

    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
