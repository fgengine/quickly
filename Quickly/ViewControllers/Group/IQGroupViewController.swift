//
//  Quickly
//

// MARK: - IQGroupViewControllerAnimation -

public protocol IQGroupViewControllerAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        currentViewController: IQGroupViewController,
        targetViewController: IQGroupViewController
    )

}

// MARK: - IQGroupViewController -

public protocol IQGroupContainerViewController : IQViewController {

    var groupbar: QGroupbar? { set get }
    var groupbarHeight: CGFloat { set get }
    var groupbarHidden: Bool { set get }

    var viewControllers: [IQGroupViewController] { set get }
    var currentViewController: IQGroupViewController? { get }
    var animation: IQGroupViewControllerAnimation { get }
    var isAnimating: Bool { get }

    func setGroupbar(_ groupbar: QGroupbar?, animated: Bool)
    func setGroupbarHeight(_ height: CGFloat, animated: Bool)
    func setGroupbarHidden(_ hidden: Bool, animated: Bool)

    func setViewControllers(_ viewControllers: [IQGroupViewController], animated: Bool, completion: (() -> Swift.Void)?)
    func setCurrentViewController(_ viewController: IQGroupViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func updateGroupItem(_ viewController: IQGroupViewController, animated: Bool)

}

// MARK: - IQGroupSlideViewController -

public protocol IQGroupViewController : IQContentOwnerViewController {

    var groupContainerViewController: IQGroupContainerViewController? { get }
    var groupContentViewController: IQGroupContentViewController { get }
    var groupItem: QGroupbarItem? { set get }
    var groupAnimation: IQGroupViewControllerAnimation? { set get }

    func setGroupItem(_ item: QGroupbarItem?, animated: Bool)

}

extension IQGroupViewController {

    public var groupContainerViewController: IQGroupContainerViewController? {
        get { return self.parent as? IQGroupContainerViewController }
    }

}

// MARK: - IQGroupContentViewController -

public protocol IQGroupContentViewController : IQContentViewController {

    var groupViewController: IQGroupViewController? { get }
    var groupItem: QGroupbarItem? { set get }
    var groupAnimation: IQGroupViewControllerAnimation? { set get }

    func setGroupItem(_ item: QGroupbarItem, animated: Bool)

}

extension IQGroupContentViewController {

    public var groupViewController: IQGroupViewController? {
        get { return self.parentOf() }
    }
    public var groupItem: QGroupbarItem? {
        set(value) { self.groupViewController?.groupItem = value }
        get { return self.groupViewController?.groupItem }
    }
    public var groupAnimation: IQGroupViewControllerAnimation? {
        set(value) { self.groupViewController?.groupAnimation = value }
        get { return self.groupViewController?.groupAnimation }
    }

    public func setGroupItem(_ item: QGroupbarItem, animated: Bool) {
        guard let vc = self.groupViewController else { return }
        vc.setGroupItem(item, animated: animated)
    }

}
