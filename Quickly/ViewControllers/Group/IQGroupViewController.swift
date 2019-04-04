//
//  Quickly
//

// MARK: - IQGroupViewControllerAnimation -

public protocol IQGroupViewControllerAnimation : class {

    func animate(
        contentView: UIView,
        currentViewController: IQGroupViewController,
        targetViewController: IQGroupViewController,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

// MARK: - IQGroupViewController -

public protocol IQGroupContainerViewController : IQViewController {

    var barView: QGroupbar? { set get }
    var barHeight: CGFloat { set get }
    var barHidden: Bool { set get }
    var barVisibility: CGFloat { set get }

    var viewControllers: [IQGroupViewController] { set get }
    var currentViewController: IQGroupViewController? { get }
    var animation: IQGroupViewControllerAnimation { get }
    var isAnimating: Bool { get }

    func set(barView: QGroupbar?, animated: Bool)
    func set(barHeight: CGFloat, animated: Bool)
    func set(barHidden: Bool, animated: Bool)
    func set(barVisibility: CGFloat, animated: Bool)

    func set(viewControllers: [IQGroupViewController], animated: Bool, completion: (() -> Swift.Void)?)
    func set(currentViewController: IQGroupViewController, animated: Bool, completion: (() -> Swift.Void)?)
    
    func didUpdate(viewController: IQGroupViewController, animated: Bool)

}

// MARK: - IQGroupSlideViewController -

public protocol IQGroupViewController : IQContentOwnerViewController {

    var containerViewController: IQGroupContainerViewController? { get }
    var contentViewController: IQGroupContentViewController { get }
    var barHidden: Bool { set get }
    var barVisibility: CGFloat { set get }
    var barItem: QGroupbarItem? { set get }
    var animation: IQGroupViewControllerAnimation? { set get }

    func set(item: QGroupbarItem?, animated: Bool)

}

extension IQGroupViewController {

    public var containerViewController: IQGroupContainerViewController? {
        get { return self.parent as? IQGroupContainerViewController }
    }
    public var barHidden: Bool {
        set(value) { self.containerViewController?.barHidden = value }
        get { return self.containerViewController?.barHidden ?? true }
    }
    public var barVisibility: CGFloat {
        set(value) { self.containerViewController?.barVisibility = value }
        get { return self.containerViewController?.barVisibility ?? 0 }
    }

}

// MARK: - IQGroupContentViewController -

public protocol IQGroupContentViewController : IQContentViewController {

    var groupViewController: IQGroupViewController? { get }
    var groupbarHidden: Bool { set get }
    var groupbarVisibility: CGFloat { set get }
    var groupbarItem: QGroupbarItem? { set get }
    var groupAnimation: IQGroupViewControllerAnimation? { set get }

    func setGroupItem(_ item: QGroupbarItem, animated: Bool)

}

extension IQGroupContentViewController {

    public var groupViewController: IQGroupViewController? {
        get { return self.parentOf() }
    }
    public var groupbarHidden: Bool {
        set(value) { self.groupViewController?.barHidden = value }
        get { return self.groupViewController?.barHidden ?? true }
    }
    public var groupbarVisibility: CGFloat {
        set(value) { self.groupViewController?.barVisibility = value }
        get { return self.groupViewController?.barVisibility ?? 0 }
    }
    public var groupbarItem: QGroupbarItem? {
        set(value) { self.groupViewController?.barItem = value }
        get { return self.groupViewController?.barItem }
    }
    public var groupAnimation: IQGroupViewControllerAnimation? {
        set(value) { self.groupViewController?.animation = value }
        get { return self.groupViewController?.animation }
    }

    public func setGroupItem(_ item: QGroupbarItem, animated: Bool) {
        guard let vc = self.groupViewController else { return }
        vc.set(item: item, animated: animated)
    }

}
