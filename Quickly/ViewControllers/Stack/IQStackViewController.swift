//
//  Quickly
//

// MARK: - IQStackViewControllerAnimation -

public protocol IQStackViewControllerPresentAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        nextViewController: IQStackPageViewController
    )

}

public protocol IQStackViewControllerDismissAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController
    )

}

public protocol IQStackViewControllerInteractiveDismissAnimation : IQInteractiveAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQStackViewController -

public protocol IQStackViewController : IQViewController {

    var viewControllers: [IQStackPageViewController] { get }
    var currentViewController: IQStackPageViewController? { get }
    var previousViewController: IQStackPageViewController? { get }
    var presentAnimation: IQStackViewControllerPresentAnimation { get }
    var dismissAnimation: IQStackViewControllerDismissAnimation { get }
    var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { get }
    var isAnimating: Bool { get }

    func presentStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func dismissStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQStackPageViewController -

public protocol IQStackPageViewController : IQContentOwnerViewController {

    var stackViewController: IQStackViewController? { get }
    var stackbar: QStackbar? { get }
    var stackbarHeight: CGFloat { get }
    var stackbarHidden: Bool { get }
    var contentViewController: IQStackContentViewController { get }

    var presentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var dismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func setStackbar(_ stackbar: QStackbar?, animated: Bool)
    func setStackbarHeight(_ height: CGFloat, animated: Bool)
    func setStackbarHidden(_ hidden: Bool, animated: Bool)
    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackPageViewController {

    public var stackViewController: IQStackViewController? {
        get { return self.parent as? IQStackViewController }
    }

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackViewController else { return }
        vc.dismissStack(self, animated: animated, completion: completion)
    }

}

// MARK: - IQStackContentViewController -

public protocol IQStackContentViewController : IQContentViewController {

    var stackPageViewController: IQStackPageViewController? { get }

    var stackbar: QStackbar? { get }
    var stackbarHeight: CGFloat { get }
    var stackbarHidden: Bool { get }
    var stackPresentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var stackDismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? { set get }

    func setStackbar(_ stackbar: QStackbar?, animated: Bool)
    func setStackbarHeight(_ height: CGFloat, animated: Bool)
    func setStackbarHidden(_ hidden: Bool, animated: Bool)

    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackContentViewController {

    public var stackPageViewController: IQStackPageViewController? {
        get { return self.parent as? IQStackPageViewController }
    }
    public var stackbar: QStackbar? {
        get { return self.stackPageViewController?.stackbar }
    }
    public var stackbarHeight: CGFloat {
        get {
            guard let vc = self.stackPageViewController else { return 0 }
            return vc.stackbarHeight
        }
    }
    public var stackbarHidden: Bool {
        get {
            guard let vc = self.stackPageViewController else { return false }
            return vc.stackbarHidden
        }
    }
    public var stackPresentAnimation: IQStackViewControllerPresentAnimation? {
        set(value) { self.stackPageViewController?.presentAnimation = value }
        get { return self.stackPageViewController?.presentAnimation }
    }

    public var stackDismissAnimation: IQStackViewControllerDismissAnimation? {
        set(value) { self.stackPageViewController?.dismissAnimation = value }
        get { return self.stackPageViewController?.dismissAnimation }
    }
    public var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? {
        set(value) { self.stackPageViewController?.interactiveDismissAnimation = value }
        get { return self.stackPageViewController?.interactiveDismissAnimation }
    }

    public func setStackbar(_ stackbar: QStackbar?, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbar(stackbar, animated: animated)
    }

    public func setStackbarHeight(_ height: CGFloat, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbarHeight(height, animated: animated)
    }

    public func setStackbarHidden(_ hidden: Bool, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbarHidden(hidden, animated: animated)
    }

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackPageViewController else { return }
        vc.dismissStack(animated: animated, completion: completion)
    }

}
