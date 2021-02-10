//
//  Quickly
//

open class QPartialStackWireframe< RouterType: IQRouter, ContextType: IQContext > : IQPartialWireframe, IQWireframeDeeplinkable, IQWeakRouterable, IQContextable {
    
    public typealias WireframeType = QStackWireframe< RouterType, ContextType >

    public var router: RouterType? {
        get { return self.wireframe.router }
    }
    public var context: ContextType {
        get { return self.wireframe.context }
    }
    
    public private(set) var wireframe: WireframeType

    public init(
        wireframe: WireframeType
    ) {
        self.wireframe = wireframe
        self.setup()
    }
    
    open func setup() {
    }
    
    open func open(_ url: URL) -> Bool {
        return true
    }
    
    open func initialViewController() -> QStackViewController? {
        guard let vc = self.initialContextViewController() else { return nil }
        return QStackViewController(viewController: vc)
    }
    
    open func initialContextViewController() -> IQStackContentViewController? {
        return nil
    }

}

// MARK: IQRouter

extension QPartialStackWireframe : IQRouter where RouterType : IQRouter {
}

// MARK: IQWireframeDefaultRouter

extension QPartialStackWireframe : IQWireframeDefaultRouter where RouterType : IQWireframeDefaultRouter {
    
    public func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval) {
        self.wireframe.present(notificationView: notificationView, alignment: alignment, duration: duration)
    }
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.wireframe.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
