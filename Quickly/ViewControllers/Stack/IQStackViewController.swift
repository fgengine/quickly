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

public protocol IQStackViewControllerinteractiveDismissAnimation : IQInteractiveAnimation {

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

    var viewControllers: [IQStackPageViewController] { set get }
    var currentViewController: IQStackPageViewController? { get }
    var previousViewController: IQStackPageViewController? { get }
    var presentAnimation: IQStackViewControllerPresentAnimation { get }
    var dismissAnimation: IQStackViewControllerDismissAnimation { get }
    var interactiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation? { get }
    var isAnimating: Bool { get }

    func presentStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

    func dismissStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQStackPageViewController -

public protocol IQStackPageViewController : IQViewController {

    var stackViewController: IQStackViewController? { set get }
    var stackbar: QStackbar? { set get }
    var stackbarHeight: CGFloat { set get }
    var stackbarHidden: Bool { set get }
    var contentViewController: IQStackContentViewController { get }

    var presentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var dismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var interactiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation? { set get }

    func setStackbar(_ view: QStackbar?, animated: Bool)
    func setStackbarHeight(_ value: CGFloat, animated: Bool)
    func setStackbarHidden(_ value: Bool, animated: Bool)
    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

    func updateContent()

}

extension IQStackPageViewController {

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackViewController else { return }
        vc.dismissStack(self, animated: animated, completion: completion)
    }

}

// MARK: - IQStackContentViewController -

public protocol IQStackContentViewController : IQViewController {

    var stackPageViewController: IQStackPageViewController? { set get }
    var stackPageContentOffset: CGPoint { get }
    var stackPageContentSize: CGSize { get }

    var stackbar: QStackbar? { set get }
    var stackbarHeight: CGFloat { set get }
    var stackbarHidden: Bool { set get }
    var stackPresentAnimation: IQStackViewControllerPresentAnimation? { set get }
    var stackDismissAnimation: IQStackViewControllerDismissAnimation? { set get }
    var stackInteractiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation? { set get }

    func setStackbar(_ view: QStackbar?, animated: Bool)
    func setStackbarHeight(_ value: CGFloat, animated: Bool)
    func setStackbarHidden(_ value: Bool, animated: Bool)

    func dismissStack(animated: Bool, completion: (() -> Swift.Void)?)

}

extension IQStackContentViewController {

    public var stackbar: QStackbar? {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.stackbar = value
        }
        get {
            guard let vc = self.stackPageViewController else { return nil }
            return vc.stackbar
        }
    }
    public var stackbarHeight: CGFloat {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.stackbarHeight = value
        }
        get {
            guard let vc = self.stackPageViewController else { return 0 }
            return vc.stackbarHeight
        }
    }
    public var stackbarHidden: Bool {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.stackbarHidden = value
        }
        get {
            guard let vc = self.stackPageViewController else { return true }
            return vc.stackbarHidden
        }
    }
    public var stackPresentAnimation: IQStackViewControllerPresentAnimation? {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.presentAnimation = value
        }
        get {
            guard let vc = self.stackPageViewController else { return nil }
            return vc.presentAnimation
        }
    }

    public var stackDismissAnimation: IQStackViewControllerDismissAnimation? {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.dismissAnimation = value
        }
        get {
            guard let vc = self.stackPageViewController else { return nil }
            return vc.dismissAnimation
        }
    }
    public var stackInteractiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation? {
        set(value) {
            guard let vc = self.stackPageViewController else { return }
            vc.interactiveDismissAnimation = value
        }
        get {
            guard let vc = self.stackPageViewController else { return nil }
            return vc.interactiveDismissAnimation
        }
    }

    public func setStackbar(_ view: QStackbar?, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbar(view, animated: animated)
    }

    public func setStackbarHeight(_ value: CGFloat, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbarHeight(value, animated: animated)
    }

    public func setStackbarHidden(_ value: Bool, animated: Bool) {
        guard let vc = self.stackPageViewController else { return }
        vc.setStackbarHidden(value, animated: animated)
    }

    public func dismissStack(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.stackPageViewController else { return }
        vc.dismissStack(animated: animated, completion: completion)
    }

}
