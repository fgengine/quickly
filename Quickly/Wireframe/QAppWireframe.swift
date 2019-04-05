//
//  Quickly
//

public protocol IQAppWireframe : IQWireframe {
    
    associatedtype ContextType: IQContext
    
    var context: ContextType { get }
    
    func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?)
    func open(_ url: URL) -> Bool
    
    var backgroundViewController: IQViewController? { set get }
    var contentViewController: IQViewController? { set get }
    var modalContainerViewController: IQModalContainerViewController? { set get }
    var dialogContainerViewController: IQDialogContainerViewController? { set get }
    var pushContainerViewController: IQPushContainerViewController? { set get }
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
}

open class QAppWireframe< ContextType: IQContext > : IQAppWireframe {
    
    open var viewController: IQViewController {
        get { return self.mainViewController }
    }
    open private(set) var mainViewController: QMainViewController = QMainViewController()
    open private(set) var context: ContextType
    open var backgroundViewController: IQViewController? {
        set(value) { self.mainViewController.backgroundViewController = value }
        get { return self.mainViewController.backgroundViewController }
    }
    open var contentViewController: IQViewController? {
        set(value) { self.mainViewController.contentViewController = value }
        get { return self.mainViewController.contentViewController }
    }
    open var modalContainerViewController: IQModalContainerViewController? {
        set(value) { self.mainViewController.modalContainerViewController = value }
        get { return self.mainViewController.modalContainerViewController }
    }
    open var dialogContainerViewController: IQDialogContainerViewController? {
        set(value) { self.mainViewController.dialogContainerViewController = value }
        get { return self.mainViewController.dialogContainerViewController }
    }
    open var pushContainerViewController: IQPushContainerViewController? {
        set(value) { self.mainViewController.pushContainerViewController = value }
        get { return self.mainViewController.pushContainerViewController }
    }

    open private(set) var window: QWindow
    
    open var current: IQWireframe? {
        didSet {
            if let current = self.current {
                self.mainViewController.contentViewController = current.viewController
            } else {
                self.mainViewController.contentViewController = nil
            }
        }
    }

    public init(
        context: ContextType
    ) {
        self.mainViewController = QMainViewController()
        self.context = context
        self.window = QWindow(self.mainViewController)
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
        return true
    }
    
    open func present(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let rootViewController = self.window.rootViewController else { return }
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    open func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
    open func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.modalContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.dialogContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.present(viewController: viewController, animated: animated, completion: completion)
    }
    
    open func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.pushContainerViewController?.dismiss(viewController: viewController, animated: animated, completion: completion)
    }

}
