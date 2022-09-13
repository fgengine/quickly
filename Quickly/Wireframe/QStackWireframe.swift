//
//  Quickly
//

import UIKit

open class QStackWireframe< RouterType: IQRouter, ContextType: IQContext > : IQWireframe, IQWireframeDeeplinkable, IQWeakRouterable, IQContextable {

    public private(set) weak var router: RouterType?
    public private(set) var context: ContextType
    public private(set) var viewController: QStackContainerViewController

    public init(
        router: RouterType,
        context: ContextType
    ) {
        self.viewController = QStackContainerViewController()
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

// MARK: Public

public extension QStackWireframe {
    
    func push(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.push(viewController: viewController, animated: animated, completion: completion)
    }
    
    func push(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.push(viewController: viewController, animated: animated, completion: completion)
    }

    func replace(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.replace(viewController: viewController, animated: animated, completion: completion)
    }

    func replace(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.replace(viewController: viewController, animated: animated, completion: completion)
    }
    
    func replaceAll(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.replaceAll(viewController: viewController, animated: animated, completion: completion)
    }
    
    func replaceAll(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.replaceAll(viewController: viewController, animated: animated, completion: completion)
    }

    func pop(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    func pop(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.pop(viewController: viewController, animated: animated, completion: completion)
    }

    func popTo(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }

    func popTo(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewController.popTo(viewController: viewController, animated: animated, completion: completion)
    }
    
    func reset(animated: Bool, completion: (() -> Swift.Void)?) {
        if let rootViewController = self.viewController.rootViewController {
            self.viewController.popTo(viewController: rootViewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
    
}

// MARK: IQRouter

extension QStackWireframe : IQRouter where RouterType : IQRouter {
}

// MARK: IQWireframeDefaultRouter

extension QStackWireframe : IQWireframeDefaultRouter where RouterType : IQWireframeDefaultRouter {
    
    public func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval) {
        self.router?.present(notificationView: notificationView, alignment: alignment, duration: duration)
    }
    
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
