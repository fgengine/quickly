//
//  Quickly
//

public protocol IQWireframe : class {
    
    associatedtype ViewControllerType: IQViewController
    
    var viewController: ViewControllerType { get }
    
}

public protocol IQPartialWireframe : class {
    
    associatedtype ViewControllerType: IQViewController
    
    func initialViewController() -> ViewControllerType?
    
}

public protocol IQWireframeDeeplinkable : class {
    
    func open(_ url: URL) -> Bool
    
}

// MARK: IQWireframeDefaultRouter

public protocol IQWireframeDefaultRouter : IQRouter {
    
    func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval)
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}
