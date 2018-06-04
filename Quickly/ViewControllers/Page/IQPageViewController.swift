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
        currentViewController: IQPageSlideViewController,
        targetViewController: IQPageSlideViewController
    )

}

public protocol IQPageViewControllerInteractiveAnimation : IQInteractiveAnimation {

    var finishMode: QPageViewControllerAnimationMode { get }

    func prepare(
        contentView: UIView,
        backwardViewController: IQPageSlideViewController?,
        currentViewController: IQPageSlideViewController,
        forwardViewController: IQPageSlideViewController?,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQPageViewController -

public protocol IQPageViewController : IQViewController {

    var pagebar: QPagebar? { get }
    var pagebarHeight: CGFloat { get }
    var pagebarHidden: Bool { get }

    var viewControllers: [IQPageSlideViewController] { get }
    var currentViewController: IQPageSlideViewController? { get }
    var forwardViewController: IQPageSlideViewController? { get }
    var backwardViewController: IQPageSlideViewController? { get }
    var forwardAnimation: IQPageViewControllerAnimation { get }
    var backwardAnimation: IQPageViewControllerAnimation { get }
    var interactiveAnimation: IQPageViewControllerInteractiveAnimation? { get }
    var isAnimating: Bool { get }

    func setPagebar(_ pagebar: QPagebar?, animated: Bool)
    func setPagebarHeight(_ height: CGFloat, animated: Bool)
    func setPagebarHidden(_ hidden: Bool, animated: Bool)

    func setViewControllers(_ viewControllers: [IQPageSlideViewController], mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    func setCurrentViewController(_ viewController: IQPageSlideViewController, mode: QPageViewControllerAnimationMode, completion: (() -> Swift.Void)?)
    func updatePagebarItem(_ viewController: IQPageSlideViewController, animated: Bool)

}

// MARK: - IQPageSlideViewController -

public protocol IQPageSlideViewController : IQContentOwnerViewController {

    var pageViewController: IQPageViewController? { get }
    var contentViewController: IQPageContentViewController { get }

    var pagebarItem: QPagebarItem? { get }

    var forwardAnimation: IQPageViewControllerAnimation? { set get }
    var backwardAnimation: IQPageViewControllerAnimation? { set get }
    var interactiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setPagebarItem(_ item: QPagebarItem?, animated: Bool)

}

extension IQPageSlideViewController {

    public var pageViewController: IQPageViewController? {
        get { return self.parent as? IQPageViewController }
    }

}

// MARK: - IQPageContentViewController -

public protocol IQPageContentViewController : IQContentViewController {

    var pageSlideViewController: IQPageSlideViewController? { get }

    var pagebarItem: QPagebarItem? { get }

    var pageForwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageBackwardAnimation: IQPageViewControllerAnimation? { set get }
    var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? { set get }

    func setPagebarItem(_ item: QPagebarItem, animated: Bool)

}

extension IQPageContentViewController {

    public var pageSlideViewController: IQPageSlideViewController? {
        get { return self.parent as? IQPageSlideViewController }
    }
    public var pagebarItem: QPagebarItem? {
        get { return self.pageSlideViewController?.pagebarItem }
    }
    public var pageForwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageSlideViewController?.forwardAnimation = value }
        get { return self.pageSlideViewController?.forwardAnimation }
    }
    public var pageBackwardAnimation: IQPageViewControllerAnimation? {
        set(value) { self.pageSlideViewController?.backwardAnimation = value }
        get { return self.pageSlideViewController?.backwardAnimation }
    }
    public var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation? {
        set(value) { self.pageSlideViewController?.interactiveAnimation = value }
        get { return self.pageSlideViewController?.interactiveAnimation }
    }

    public func setPagebarItem(_ item: QPagebarItem, animated: Bool) {
        guard let vc = self.pageSlideViewController else { return }
        vc.setPagebarItem(item, animated: animated)
    }

}
