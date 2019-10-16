//
//  Quickly
//

// MARK: QStackViewControllerBarSize

public enum QStackViewControllerBarSize : Equatable {
    case fixed(height: CGFloat)
    case range(minHeight: CGFloat, maxHeight: CGFloat)
}

// MARK: IQStackViewControllerAnimation

public protocol IQStackViewControllerPresentAnimation : class {

    func animate(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        nextViewController: IQStackViewController,
        nextGroupbarVisibility: CGFloat,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

public protocol IQStackViewControllerDismissAnimation : class {

    func animate(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

public protocol IQStackViewControllerInteractiveDismissAnimation : class {

    var canFinish: Bool { get }
    
    func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat,
        position: CGPoint,
        velocity: CGPoint
    )
    
    func update(position: CGPoint, velocity: CGPoint)
    func cancel(_ complete: @escaping (_ completed: Bool) -> Void)
    func finish(_ complete: @escaping (_ completed: Bool) -> Void)

}

// MARK: IQStackContainerViewController

public protocol IQStackContainerViewController : IQGroupContentViewController {

    var viewControllers: [IQStackViewController] { set get }
    var rootViewController: IQStackViewController? { get }
    var currentViewController: IQStackViewController? { get }
    var previousViewController: IQStackViewController? { get }
    var presentAnimation: IQStackViewControllerPresentAnimation { get }
    var dismissAnimation: IQStackViewControllerDismissAnimation { get }
    var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { get }
    var hidesGroupbarWhenPushed: Bool { set get }
    var isAnimating: Bool { get }
    
    func set(viewControllers: [IQStackViewController], animated: Bool, completion: (() -> Swift.Void)?)

    func push(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func push(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func replace(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func replace(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func pop(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func pop(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func popTo(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func popTo(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: IQStackPageViewController

public protocol IQStackViewController : IQContentOwnerViewController {

    var containerViewController: IQStackContainerViewController? { get }
    var barView: QStackbar? { set get }
    var barSize: QStackViewControllerBarSize { set get }
    var barHidden: Bool { set get }
    var viewController: IQStackContentViewController { get }

    var presentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var dismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func set(barView: QStackbar?, animated: Bool)
    func set(barSize: QStackViewControllerBarSize, animated: Bool)
    func set(barHidden: Bool, animated: Bool)
    
    func pop(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackViewController {

    public var containerViewController: IQStackContainerViewController? {
        get { return self.parentViewController as? IQStackContainerViewController }
    }

    public func pop(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.pop(viewController: self, animated: animated, completion: completion)
    }

}

// MARK: IQStackContentViewController

public protocol IQStackContentViewController : IQContentViewController {

    var stackViewController: IQStackViewController? { get }

    var stackbar: QStackbar? { set get }
    var stackbarSize: QStackViewControllerBarSize { set get }
    var stackbarHidden: Bool { set get }
    var stackPresentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var stackDismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func setStackbar(_ stackbar: QStackbar?, animated: Bool)
    func setStackbarSize(_ size: QStackViewControllerBarSize, animated: Bool)
    func setStackbarHidden(_ hidden: Bool, animated: Bool)

    func popStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackContentViewController {

    public var stackViewController: IQStackViewController? {
        get { return self.parentViewControllerOf() }
    }
    public var stackbar: QStackbar? {
        set(value) { self.stackViewController?.barView = value }
        get { return self.stackViewController?.barView }
    }
    public var stackbarSize: QStackViewControllerBarSize {
        set(value) { self.stackViewController?.barSize = value }
        get { return self.stackViewController?.barSize ?? .fixed(height: 0) }
    }
    public var stackbarHidden: Bool {
        set(value) { self.stackViewController?.barHidden = value }
        get { return self.stackViewController?.barHidden ?? true }
    }
    public var stackPresentAnimation: IQStackViewControllerPresentAnimation? {
        set(value) { self.stackViewController?.presentAnimation = value }
        get { return self.stackViewController?.presentAnimation }
    }
    public var stackDismissAnimation: IQStackViewControllerDismissAnimation? {
        set(value) { self.stackViewController?.dismissAnimation = value }
        get { return self.stackViewController?.dismissAnimation }
    }
    public var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? {
        set(value) { self.stackViewController?.interactiveDismissAnimation = value }
        get { return self.stackViewController?.interactiveDismissAnimation }
    }

    public func setStackbar(_ stackbar: QStackbar?, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.set(barView: stackbar, animated: animated)
    }

    public func setStackbarSize(_ size: QStackViewControllerBarSize, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.set(barSize: size, animated: animated)
    }

    public func setStackbarHidden(_ hidden: Bool, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.set(barHidden: hidden, animated: animated)
    }

    public func popStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackViewController else { return }
        vc.pop(animated: animated, completion: completion)
    }

}
