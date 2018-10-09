//
//  Quickly
//

// MARK: - IQStackViewControllerAnimation -

public protocol IQStackViewControllerPresentAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackViewController,
        nextViewController: IQStackViewController
    )

}

public protocol IQStackViewControllerDismissAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackViewController,
        previousViewController: IQStackViewController
    )

}

public protocol IQStackViewControllerInteractiveDismissAnimation : IQInteractiveAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackViewController,
        previousViewController: IQStackViewController,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQStackViewController -

public protocol IQStackContainerViewController : IQViewController {

    var viewControllers: [IQStackViewController] { get }
    var rootViewController: IQStackViewController? { get }
    var currentViewController: IQStackViewController? { get }
    var previousViewController: IQStackViewController? { get }
    var presentAnimation: IQStackViewControllerPresentAnimation { get }
    var dismissAnimation: IQStackViewControllerDismissAnimation { get }
    var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { get }
    var isAnimating: Bool { get }

    func presentStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func dismissStack(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func dismissStack(to viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissStack(to viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

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
    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackViewController {

    public var stackContainerViewController: IQStackContainerViewController? {
        get { return self.parent as? IQStackContainerViewController }
    }

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackContainerViewController else { return }
        vc.dismissStack(self, animated: animated, completion: completion)
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

    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

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
        get { return self.stackViewController?.stackbarHidden ?? false }
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

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackViewController else { return }
        vc.dismissStack(animated: animated, completion: completion)
    }

}
