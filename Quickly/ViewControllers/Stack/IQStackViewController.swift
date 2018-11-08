//
//  Quickly
//

// MARK: - IQStackViewControllerAnimation -

public protocol IQStackViewControllerPresentAnimation : IQFixedAnimation {

    func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        nextViewController: IQStackViewController,
        nextGroupbarVisibility: CGFloat
    )

}

public protocol IQStackViewControllerDismissAnimation : IQFixedAnimation {

    func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat
    )

}

public protocol IQStackViewControllerInteractiveDismissAnimation : IQInteractiveAnimation {

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

}

// MARK: - IQStackContainerViewController -

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
    
    func setViewControllers(_ viewControllers: [IQStackViewController], animated: Bool, completion: (() -> Swift.Void)?)

    func pushStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func pushStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func replaceStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func replaceStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func popStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func popStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func popStack(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func popStack(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQStackPageViewController -

public protocol IQStackViewController : IQContentOwnerViewController {

    var stackContainerViewController: IQStackContainerViewController? { get }
    var stackbar: QStackbar? { set get }
    var stackbarHeight: CGFloat { set get }
    var stackbarHidden: Bool { set get }
    var stackContentViewController: IQStackContentViewController { get }

    var stackPresentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var stackDismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func setStackbar(_ stackbar: QStackbar?, animated: Bool)
    func setStackbarHeight(_ height: CGFloat, animated: Bool)
    func setStackbarHidden(_ hidden: Bool, animated: Bool)
    
    func popStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackViewController {

    public var stackContainerViewController: IQStackContainerViewController? {
        get { return self.parent as? IQStackContainerViewController }
    }

    public func popStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackContainerViewController else { return }
        vc.popStack(self, animated: animated, completion: completion)
    }

}

// MARK: - IQStackContentViewController -

public protocol IQStackContentViewController : IQContentViewController {

    var stackViewController: IQStackViewController? { get }

    var stackbar: QStackbar? { set get }
    var stackbarHeight: CGFloat { set get }
    var stackbarHidden: Bool { set get }
    var stackPresentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var stackDismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func setStackbar(_ stackbar: QStackbar?, animated: Bool)
    func setStackbarHeight(_ height: CGFloat, animated: Bool)
    func setStackbarHidden(_ hidden: Bool, animated: Bool)

    func popStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackContentViewController {

    public var stackViewController: IQStackViewController? {
        get { return self.parentOf() }
    }
    public var stackbar: QStackbar? {
        set(value) { self.stackViewController?.stackbar = value }
        get { return self.stackViewController?.stackbar }
    }
    public var stackbarHeight: CGFloat {
        set(value) { self.stackViewController?.stackbarHeight = value }
        get { return self.stackViewController?.stackbarHeight ?? 0 }
    }
    public var stackbarHidden: Bool {
        set(value) { self.stackViewController?.stackbarHidden = value }
        get { return self.stackViewController?.stackbarHidden ?? true }
    }
    public var stackPresentAnimation: IQStackViewControllerPresentAnimation? {
        set(value) { self.stackViewController?.stackPresentAnimation = value }
        get { return self.stackViewController?.stackPresentAnimation }
    }

    public var stackDismissAnimation: IQStackViewControllerDismissAnimation? {
        set(value) { self.stackViewController?.stackDismissAnimation = value }
        get { return self.stackViewController?.stackDismissAnimation }
    }
    public var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? {
        set(value) { self.stackViewController?.stackInteractiveDismissAnimation = value }
        get { return self.stackViewController?.stackInteractiveDismissAnimation }
    }

    public func setStackbar(_ stackbar: QStackbar?, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.setStackbar(stackbar, animated: animated)
    }

    public func setStackbarHeight(_ height: CGFloat, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.setStackbarHeight(height, animated: animated)
    }

    public func setStackbarHidden(_ hidden: Bool, animated: Bool) {
        guard let vc = self.stackViewController else { return }
        vc.setStackbarHidden(hidden, animated: animated)
    }

    public func popStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackViewController else { return }
        vc.popStack(animated: animated, completion: completion)
    }

}
