//
//  Quickly
//

import UIKit

open class QMainWireframe< ContextType: IQContext > : IQWireframe, IQWireframeDeeplinkable, IQContextable {
    
    public weak var router: IQWireframeSystemRouter?
    public private(set) var context: ContextType
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
    
    private var _wireframe: AnyObject?
    
    public init(
        context: ContextType
    ) {
        self.context = context
        self.viewController = QMainViewController()
        self.setup()
    }
    
    open func setup() {
    }
    
    open func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?) {
    }
    
    open func open(_ url: URL) -> Bool {
        guard let deeplinkable = self._wireframe as? IQWireframeDeeplinkable else { return false }
        return deeplinkable.open(url)
    }
    
}

// MARK: Public

public extension QMainWireframe {
    
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

// MARK: IQWireframeSystemRouter

extension QMainWireframe : IQWireframeSystemRouter {
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.router?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframeModalRouter

extension QMainWireframe : IQWireframeModalRouter {
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
}

// MARK: IQWireframeDialogRouter

extension QMainWireframe : IQWireframeDialogRouter {
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframePushRouter

extension QMainWireframe : IQWireframePushRouter {
    
    public func present(notificationView: QDisplayView, alignment: QMainViewController.NotificationAlignment, duration: TimeInterval) {
        self.viewController.present(notificationView: notificationView, alignment: alignment, duration: duration)
    }
    
    public func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.pushContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
