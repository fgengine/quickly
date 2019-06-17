//
//  Quickly
//

open class QStackWireframe< WireframeType: IQWireframe, ContextType: IQContext > : IQChildWireframe {

    open var viewController: IQViewController {
        get { return self.containerViewController }
    }
    open private(set) var containerViewController: QStackContainerViewController
    open private(set) weak var parent: WireframeType?
    open private(set) var context: ContextType

    public init(
        parent: WireframeType,
        context: ContextType
    ) {
        self.containerViewController = QStackContainerViewController()
        self.parent = parent
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }
    
    open func open(_ url: URL) -> Bool {
        return true
    }
    
    open func push(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.push(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func push(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.push(viewController: viewController, animated: animated, completion: completion)
    }

    open func replace(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.replace(viewController: viewController, animated: animated, completion: completion)
    }

    open func replace(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.replace(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    open func popTo(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }

    open func popTo(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.containerViewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func reset(animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if let rootViewController = self.containerViewController.rootViewController {
            self.containerViewController.popTo(viewController: rootViewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

}
