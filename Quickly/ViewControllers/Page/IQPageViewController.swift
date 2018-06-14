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

public protocol IQPageViewControllerAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQPageViewController,
        targetViewController: IQPageViewController
    )

}

public protocol IQPageViewControllerInteractiveAnimation : IQInteractiveAnimation {

    var finishMode: QPageViewControllerAnimationMode { get }

    func prepare(
        contentView: UIView,
        backwardViewController: IQPageViewController?,
        currentViewController: IQPageViewController,
        forwardViewController: IQPageViewController?,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQPageViewController -

public protocol IQPageContainerViewController : IQViewController {

    var pagebar: QPagebar? { get }
    var pagebarHeight: CGFloat { get }
    var pagebarHidden: Bool { get }

    var viewControllers: [IQPageViewController] { get }
    var currentViewController: IQPageViewController? { get }
    var forwardViewController: IQPageViewController? { get }
    var backwardViewController: IQPageViewController? { get }
    var forwardAnimation: IQPageViewControllerAnimation { get }
    var backwardAnimation: IQPageViewControllerAnimation { get }
    var interactiveAnimation: IQPageViewControllerInteractiveAnimation? { get }
    var isAnimating: Bool { get }

    func setPagebar(_ pagebar: QPagebar?, animated: Bool)
    func setPagebarHeight(_ height: CGFloat, animated: Bool)
    func setPagebarHidden(_ hidden: Bool, animated: Bool)

    func setViewControllers(_ viewControllers: [IQPageViewController], mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    func setCurrentViewController(_ viewController: IQPageViewController, mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    func updatePageItem(_ viewController: IQPageViewController, animated: Bool)

}

// MARK: - IQPageSlideViewController -

public protocol IQPageViewController : IQContentOwnerViewController {

    var pageContainerViewController: IQPageContainerViewController? { get }
    var pageContentViewController: IQPageContentViewController { get }
    var pageItem: QPagebarItem? { get }
    var pageForwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageBackwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setPageItem(_ item: QPagebarItem?, animated: Bool)

}

extension IQPageViewController {

    public var pageContainerViewController: IQPageContainerViewController? {
        get { return self.parent as? IQPageContainerViewController }
    }

}

// MARK: - IQPageContentViewController -

public protocol IQPageContentViewController : IQContentViewController {

    var pageViewController: IQPageViewController? { get }
    var pageItem: QPagebarItem? { get }
    var pageForwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageBackwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setPageItem(_ item: QPagebarItem, animated: Bool)

}

extension IQPageContentViewController {

    public var pageViewController: IQPageViewController? {
        get { return self.parentOf() }
    }
    public var pageItem: QPagebarItem? {
        get { return self.pageViewController?.pageItem }
    }
    public var pageForwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageViewController?.pageForwardAnimation = value }
        get { return self.pageViewController?.pageForwardAnimation }
    }
    public var pageBackwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageViewController?.pageBackwardAnimation = value }
        get { return self.pageViewController?.pageBackwardAnimation }
    }
    public var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? {
        set(value) { self.pageViewController?.pageInteractiveAnimation = value }
        get { return self.pageViewController?.pageInteractiveAnimation }
    }

    public func setPageItem(_ item: QPagebarItem, animated: Bool) {
        guard let vc = self.pageViewController else { return }
        vc.setPageItem(item, animated: animated)
    }

}
