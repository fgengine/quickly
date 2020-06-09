//
//  Quickly
//

open class QAppWireframe< ContextType: IQContext > : IQWireframe, IQWireframeDeeplinkable, IQContextable {
    
    public private(set) var window: QWindow
    public var viewController: QMainViewController
    public var backgroundViewController: IQViewController? {
        set(value) { self.viewController.backgroundViewController = value }
        get { return self.viewController.backgroundViewController }
    }
    public var contentViewController: IQViewController? {
        set(value) { self.viewController.contentViewController = value }
        get { return self.viewController.contentViewController }
    }
    public var modalContainerViewController: IQModalContainerViewController? {
        set(value) { self.viewController.modalContainerViewController = value }
        get { return self.viewController.modalContainerViewController }
    }
    public var dialogContainerViewController: IQDialogContainerViewController? {
        set(value) { self.viewController.dialogContainerViewController = value }
        get { return self.viewController.dialogContainerViewController }
    }
    public var pushContainerViewController: IQPushContainerViewController? {
        set(value) { self.viewController.pushContainerViewController = value }
        get { return self.viewController.pushContainerViewController }
    }
    public private(set) var context: ContextType

    private var _wireframe: AnyObject?

    public init(
        context: ContextType
    ) {
        self.viewController = QMainViewController()
        self.context = context
        self.window = QWindow(self.viewController)
        self.setup()
    }
    
    open func setup() {
    }

    open func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?) {
        if self.window.isKeyWindow == false {
            self.window.makeKeyAndVisible()
        }
    }
    
    open func open(_ url: URL) -> Bool {
        guard let deeplinkable = self._wireframe as? IQWireframeDeeplinkable else { return false }
        return deeplinkable.open(url)
    }

}

// MARK: Public

public extension QAppWireframe {
    
    func set< WireframeType: IQWireframe >(wireframe: WireframeType) {
        if self._wireframe !== wireframe {
            self._wireframe = wireframe
            self.viewController.contentViewController = wireframe.viewController
        }
    }
    
    func wireframe< WireframeType: IQWireframe >() -> WireframeType? {
        return self._wireframe as? WireframeType
    }
    
}

// MARK: IQWireframeDefaultRouter

extension QAppWireframe : IQWireframeDefaultRouter {
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        guard let rootViewController = self.window.rootViewController else { return }
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
