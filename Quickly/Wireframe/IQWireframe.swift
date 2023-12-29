//
//  Quickly
//

import UIKit

public protocol IQWireframe : AnyObject {
    
    associatedtype ViewControllerType: IQViewController
    
    var viewController: ViewControllerType { get }
    
}

public protocol IQPartialWireframe : AnyObject {
    
    associatedtype ViewControllerType: IQViewController
    
    func initialViewController() -> ViewControllerType?
    
}

public protocol IQWireframeDeeplinkable : AnyObject {
    
    func open(_ url: URL) -> Bool
    
}

public protocol IQWireframeSystemRouter : IQRouter {
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}

public protocol IQWireframeModalRouter : IQRouter {
    
    func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}

public protocol IQWireframeDialogRouter : IQRouter {
    
    func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}

public protocol IQWireframePushRouter : IQRouter {
    
    func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval)
    
    func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}
