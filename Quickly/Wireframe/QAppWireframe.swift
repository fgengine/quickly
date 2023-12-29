//
//  Quickly
//

import UIKit

open class QAppWireframe< ContextType: IQContext > : IQWireframe, IQWireframeDeeplinkable, IQContextable {
    
    public var context: ContextType {
        return self._main.context
    }
    
    public private(set) var window: QWindow
    public var viewController: QMainViewController {
        return self._main.viewController
    }
    public var backgroundViewController: IQViewController? {
        set(value) { self._main.backgroundViewController = value }
        get { return self._main.backgroundViewController }
    }
    public var contentViewController: IQViewController? {
        set(value) { self._main.contentViewController = value }
        get { return self._main.contentViewController }
    }
    public var modalContainerViewController: IQModalContainerViewController? {
        set(value) { self._main.modalContainerViewController = value }
        get { return self._main.modalContainerViewController }
    }
    public var dialogContainerViewController: IQDialogContainerViewController? {
        set(value) { self._main.dialogContainerViewController = value }
        get { return self._main.dialogContainerViewController }
    }
    public var pushContainerViewController: IQPushContainerViewController? {
        set(value) { self._main.pushContainerViewController = value }
        get { return self._main.pushContainerViewController }
    }

    private let _main: QMainWireframe< ContextType >

    public init(
        context: ContextType
    ) {
        self._main = .init(context: context)
        self.window = QWindow(self._main.viewController)
        self._main.router = self
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
        return self._main.open(url)
    }

}

// MARK: Public

public extension QAppWireframe {
    
    func set< WireframeType: IQWireframe >(wireframe: WireframeType) {
        self._main.set(wireframe: wireframe)
    }
    
    func wireframe< WireframeType: IQWireframe >() -> WireframeType? {
        return self._main.wireframe()
    }
    
}

// MARK: IQWireframeSystemRouter

extension QAppWireframe : IQWireframeSystemRouter {
    
    public func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        guard let rootViewController = self.window.rootViewController else { return }
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframeModalRouter

extension QAppWireframe : IQWireframeModalRouter {
    
    public func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.modalContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframeDialogRouter

extension QAppWireframe : IQWireframeDialogRouter {
    
    public func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.dialogContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}

// MARK: IQWireframePushRouter

extension QAppWireframe : IQWireframePushRouter {
    
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
