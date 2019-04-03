//
//  Quickly
//

open class QStackWireframe< WireframeType: IQWireframe, ContextType: IQContext > : IQChildWireframe {

    open var presentableViewController: IQViewController {
        get { return self.viewController }
    }
    open private(set) var viewController: QStackContainerViewController
    open private(set) weak var parent: WireframeType?
    open private(set) var context: ContextType

    public init(
        parent: WireframeType,
        context: ContextType
    ) {
        self.viewController = QStackContainerViewController()
        self.parent = parent
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }
    
    open func push(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.push(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func push(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.push(viewController: viewController, animated: animated, completion: completion)
    }

    open func replace(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replace(viewController: viewController, animated: animated, completion: completion)
    }

    open func replace(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.replace(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.viewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func reset(animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if let rootViewController = self.viewController.rootViewController {
            self.viewController.popTo(viewController: rootViewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

}
