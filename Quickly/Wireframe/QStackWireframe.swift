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
    
    open func presentStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.presentStack(viewController, animated: animated, completion: completion)
    }
    
    open func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.presentStack(viewController, animated: animated, completion: completion)
    }

    open func replaceStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replaceStack(viewController, animated: animated, completion: completion)
    }

    open func replaceStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replaceStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.dismissStack(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.dismissStack(to: viewController, animated: animated, completion: completion)
    }

    open func dismissStack(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.dismissStack(to: viewController, animated: animated, completion: completion)
    }

}
