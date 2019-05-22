//
//  Quickly
//

// MARK: - QPageViewControllerAnimationMode -

public enum QPageViewControllerAnimationMode {
    case none
    case forward
    case backward

    public var isAnimating: Bool {
        get {
            switch self {
            case .none: return false
            case .forward: return true
            case .backward: return true
            }
        }
    }
}

// MARK: - IQPageViewControllerAnimation -

public protocol IQPageViewControllerAnimation : class {

    func animate(
        contentView: UIView,
        currentViewController: IQPageViewController,
        targetViewController: IQPageViewController,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

public protocol IQPageViewControllerInteractiveAnimation : class {

    var canFinish: Bool { get }
    var finishMode: QPageViewControllerAnimationMode { get }

    func prepare(
        contentView: UIView,
        backwardViewController: IQPageViewController?,
        currentViewController: IQPageViewController,
        forwardViewController: IQPageViewController?,
        position: CGPoint,
        velocity: CGPoint
    )
    func update(position: CGPoint, velocity: CGPoint)
    func cancel(_ complete: @escaping (_ completed: Bool) -> Void)
    func finish(_ complete: @escaping (_ completed: Bool) -> Void)

}

// MARK: - IQPageViewController -

public protocol IQPageContainerViewController : IQViewController {

    var barView: QPagebar? { set get }
    var barHeight: CGFloat { set get }
    var barHidden: Bool { set get }

    var viewControllers: [IQPageViewController] { set get }
    var currentViewController: IQPageViewController? { get }
    var forwardViewController: IQPageViewController? { get }
    var backwardViewController: IQPageViewController? { get }
    var forwardAnimation: IQPageViewControllerAnimation { get }
    var backwardAnimation: IQPageViewControllerAnimation { get }
    var interactiveAnimation: IQPageViewControllerInteractiveAnimation? { get }
    var isAnimating: Bool { get }

    func set(barView: QPagebar?, animated: Bool)
    func set(barHeight: CGFloat, animated: Bool)
    func set(barHidden: Bool, animated: Bool)

    func set(viewControllers: [IQPageViewController], mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    func set(currentViewController: IQPageViewController, mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    
    func didUpdate(viewController: IQPageViewController, animated: Bool)

}

// MARK: - IQPageSlideViewController -

public protocol IQPageViewController : IQContentOwnerViewController {

    var containerViewController: IQPageContainerViewController? { get }
    var viewController: IQPageContentViewController { get }
    var item: QPagebarItem? { set get }
    var forwardAnimation: IQPageViewControllerAnimation? { set get }
    var backwardAnimation: IQPageViewControllerAnimation? { set get }
    var interactiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setItem(_ item: QPagebarItem?, animated: Bool)

}

extension IQPageViewController {

    public var containerViewController: IQPageContainerViewController? {
        get { return self.parentViewController as? IQPageContainerViewController }
    }

}

// MARK: - IQPageContentViewController -

public protocol IQPageContentViewController : IQContentViewController {

    var pageViewController: IQPageViewController? { get }
    var pageItem: QPagebarItem? { set get }
    var pageForwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageBackwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setPageItem(_ item: QPagebarItem, animated: Bool)

}

extension IQPageContentViewController {

    public var pageViewController: IQPageViewController? {
        get { return self.parentViewControllerOf() }
    }
    public var pageItem: QPagebarItem? {
        set(value) { self.pageViewController?.item = value }
        get { return self.pageViewController?.item }
    }
    public var pageForwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageViewController?.forwardAnimation = value }
        get { return self.pageViewController?.forwardAnimation }
    }
    public var pageBackwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageViewController?.backwardAnimation = value }
        get { return self.pageViewController?.backwardAnimation }
    }
    public var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? {
        set(value) { self.pageViewController?.interactiveAnimation = value }
        get { return self.pageViewController?.interactiveAnimation }
    }

    public func setPageItem(_ item: QPagebarItem, animated: Bool) {
        guard let vc = self.pageViewController else { return }
        vc.setItem(item, animated: animated)
    }

}
