//
//  Quickly
//

import UIKit

open class QHamburgerWireframe< RouterType: IQRouter, ContextType: IQContext > : IQWireframe, IQWireframeDeeplinkable, IQWeakRouterable, IQContextable {

    public private(set) weak var router: RouterType?
    public private(set) var context: ContextType
    public private(set) var viewController: QHamburgerContainerViewController

    public init(
        router: RouterType,
        context: ContextType
    ) {
        self.router = router
        self.context = context
        self.viewController = QHamburgerContainerViewController()
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

// MARK: IQWireframeSystemRouter

extension QHamburgerWireframe : IQWireframeSystemRouter where RouterType : IQWireframeSystemRouter {
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframeModalRouter

extension QHamburgerWireframe : IQWireframeModalRouter where RouterType : IQWireframeModalRouter {
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
    
// MARK: IQWireframeDialogRouter

extension QHamburgerWireframe : IQWireframeDialogRouter where RouterType : IQWireframeDialogRouter {
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
    
// MARK: IQWireframePushRouter

extension QHamburgerWireframe : IQWireframePushRouter where RouterType : IQWireframePushRouter {
    
    public func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval) {
        self.router?.present(notificationView: notificationView, alignment: alignment, duration: duration)
    }
    
    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
