//
//  Quickly
//

open class QStackWireframe< ContextType: IQContext, WireframeType: IQWireframe > : IQChildWireframe {

    open var baseViewController: IQViewController {
        get { return self.viewController }
    }
    open private(set) var viewController: QStackContainerViewController
    open private(set) var context: ContextType
    open private(set) weak var parent: WireframeType?

    public init(
        context: ContextType,
        parent: WireframeType
    ) {
        self.viewController = QStackContainerViewController()
        self.context = context
        self.parent = parent
        self.setup()
    }
    
    open func setup() {
    }
    
    open func pushStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.pushStack(viewController, animated: animated, completion: completion)
    }
    
    open func pushStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.pushStack(viewController, animated: animated, completion: completion)
    }

    open func replaceStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replaceStack(viewController, animated: animated, completion: completion)
    }

    open func replaceStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replaceStack(viewController, animated: animated, completion: completion)
    }

    open func popStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popStack(viewController, animated: animated, completion: completion)
    }

    open func popStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popStack(viewController, animated: animated, completion: completion)
    }

    open func popStack(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popStack(to: viewController, animated: animated, completion: completion)
    }

    open func popStack(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popStack(to: viewController, animated: animated, completion: completion)
    }
    
    open func resetStack(animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if let rootViewController = self.viewController.rootViewController {
            self.viewController.popStack(to: rootViewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

}
