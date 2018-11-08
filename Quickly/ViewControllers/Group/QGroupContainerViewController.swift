//
//  Quickly
//

open class QGroupContainerViewController : QViewController, IQGroupContainerViewController, IQStackContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open var groupbar: QGroupbar? {
        set(value) { self.setGroupbar(value) }
        get { return self._groupbar }
    }
    open var groupbarHeight: CGFloat {
        set(value) { self.setGroupbarHeight(value) }
        get { return self._groupbarHeight }
    }
    open var groupbarHidden: Bool {
        set(value) { self.setGroupbarHidden(value) }
        get { return self._groupbarHidden }
    }
    open var groupbarVisibility: CGFloat {
        set(value) { self.setGroupbarVisibility(value) }
        get { return self._groupbarVisibility }
    }
    open var viewControllers: [IQGroupViewController] {
        set(value) { self.setViewControllers(value) }
        get { return self._viewControllers }
    }
    open private(set) var currentViewController: IQGroupViewController?
    open var animation: IQGroupViewControllerAnimation
    open private(set) var isAnimating: Bool {
        didSet {
            if let groupbar = self._groupbar {
                groupbar.isUserInteractionEnabled = self.isAnimating == false
            }
        }
    }
    
    private var _groupbar: QGroupbar?
    private var _groupbarHeight: CGFloat
    private var _groupbarHidden: Bool
    private var _groupbarVisibility: CGFloat
    private var _viewControllers: [IQGroupViewController]

    public override init() {
        self._groupbarHeight = 44
        self._groupbarHidden = false
        self._groupbarVisibility = 1
        self._viewControllers = []
        self.animation = QGroupViewControllerAnimation()
        self.isAnimating = false
        super.init()
    }

    open override func didLoad() {
        self._updateAdditionalEdgeInsets()

        if self.currentViewController == nil {
            self.currentViewController = self.viewControllers.first
        }
        if let vc = self.currentViewController {
            self._appearViewController(vc)
            self.currentViewController = vc
        }
        if let groupbar = self._groupbar {
            groupbar.items = self._viewControllers.compactMap({ return $0.groupbarItem })
            groupbar.setSelectedItem(self.currentViewController?.groupbarItem, animated: false)
            self.view.addSubview(groupbar)
        }
    }

    open override func layout(bounds: CGRect) {
        guard self.isAnimating == false else {
            return
        }
        if let vc = self.currentViewController {
            vc.view.frame = bounds
        }
        if let groupbar = self._groupbar {
            groupbar.edgeInsets = self._groupbarEdgeInsets()
            groupbar.frame = self._groupbarFrame(bounds: bounds)
        }
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        if let vc = self.currentViewController {
            vc.prepareInteractivePresent()
        }
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        if let vc = self.currentViewController {
            vc.cancelInteractivePresent()
        }
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        if let vc = self.currentViewController {
            vc.finishInteractivePresent()
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        if let vc = self.currentViewController {
            vc.willPresent(animated: animated)
        }
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        if let vc = self.currentViewController {
            vc.didPresent(animated: animated)
        }
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        if let vc = self.currentViewController {
            vc.prepareInteractiveDismiss()
        }
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        if let vc = self.currentViewController {
            vc.cancelInteractiveDismiss()
        }
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        if let vc = self.currentViewController {
            vc.finishInteractiveDismiss()
        }
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        if let vc = self.currentViewController {
            vc.willDismiss(animated: animated)
        }
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        if let vc = self.currentViewController {
            vc.didDismiss(animated: animated)
        }
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let vc = self.currentViewController {
            vc.willTransition(size: size)
        }
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        if let vc = self.currentViewController {
            vc.didTransition(size: size)
        }
    }
    
    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        guard let vc = self.currentViewController else { return super.supportedOrientations() }
        return vc.supportedOrientations()
    }
    
    open override func preferedStatusBarHidden() -> Bool {
        guard let vc = self.currentViewController else { return super.preferedStatusBarHidden() }
        return vc.preferedStatusBarHidden()
    }
    
    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        guard let vc = self.currentViewController else { return super.preferedStatusBarStyle() }
        return vc.preferedStatusBarStyle()
    }
    
    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        guard let vc = self.currentViewController else { return super.preferedStatusBarAnimation() }
        return vc.preferedStatusBarAnimation()
    }

    open func setGroupbar(_ groupbar: QGroupbar?, animated: Bool = false) {
        if self._groupbar !== groupbar {
            if self.isLoaded == true {
                if let groupbar = self._groupbar {
                    groupbar.removeFromSuperview()
                    groupbar.delegate = nil
                }
                self._groupbar = groupbar
                if let groupbar = self._groupbar {
                    groupbar.frame = self._groupbarFrame(bounds: self.view.bounds)
                    groupbar.edgeInsets = self._groupbarEdgeInsets()
                    groupbar.delegate = self
                    self.view.addSubview(groupbar)
                }
                self.setNeedLayout()
            } else {
                if let groupbar = self._groupbar {
                    groupbar.delegate = nil
                }
                self._groupbar = groupbar
                if let groupbar = self._groupbar {
                    groupbar.delegate = self
                }
            }
            self._updateAdditionalEdgeInsets()
        }
    }

    open func setGroupbarHeight(_ value: CGFloat, animated: Bool = false) {
        if self._groupbarHeight != value {
            self._groupbarHeight = value
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateGroupbar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func setGroupbarHidden(_ value: Bool, animated: Bool = false) {
        if self._groupbarHidden != value {
            self._groupbarHidden = value
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateGroupbar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func setGroupbarVisibility(_ visibility: CGFloat, animated: Bool = false) {
        if self._groupbarVisibility != visibility {
            self._groupbarVisibility = visibility
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateGroupbar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func setViewControllers(_ viewControllers: [IQGroupViewController], animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        self._viewControllers.forEach({ self._removeChildViewController($0) })
        self._viewControllers = viewControllers
        self._viewControllers.forEach({ self._addChildViewController($0) })
        if self.isLoaded == true {
            self._updateViewControllers(self.currentViewController, animated: animated, updation: {
                if let groupbar = self._groupbar {
                    let groupbarItems = self._viewControllers.compactMap({ return $0.groupbarItem })
                    let selectedGroupbarItem = self.currentViewController?.groupbarItem
                    if animated == true {
                        groupbar.performBatchUpdates({
                            groupbar.deleteItem(groupbar.items)
                            groupbar.appendItem(groupbarItems)
                        }, completion: { _ in
                            groupbar.setSelectedItem(selectedGroupbarItem, animated: true)
                        })
                    } else {
                        groupbar.items = groupbarItems
                        groupbar.setSelectedItem(selectedGroupbarItem, animated: true)
                    }
                }
            }, completion: completion)
        }
    }

    open func setCurrentViewController(_ viewController: IQGroupViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        guard self._viewControllers.contains(where: { $0 === viewController }) == true else { return }
        if self.isLoaded == true {
            self._updateViewControllers(viewController, animated: animated, updation: {
                if let groupbar = self._groupbar {
                    groupbar.setSelectedItem(viewController.groupbarItem, animated: animated)
                }
            }, completion: completion)
        } else {
            self.currentViewController = viewController
        }
    }

    open func updateGroupItem(_ viewController: IQGroupViewController, animated: Bool) {
        guard let groupbar = self._groupbar else { return }
        guard let index = self._viewControllers.index(where: { $0 === viewController }) else { return }
        guard let groupbarItem = viewController.groupbarItem else { return }
        groupbar.replaceItem(groupbarItem, index: index)
    }

    private func _updateViewControllers(_ viewController: IQGroupViewController?, animated: Bool, updation: (() -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        if self.currentViewController !== viewController {
            let previousViewController = self.currentViewController
            self.currentViewController = viewController
            if let vc = self.currentViewController {
                self._appearViewController(vc)
            }
            updation?()
            if let currentViewController = previousViewController, let targetViewController = viewController {
                let animation = self._prepareAnimation(currentViewController)
                self.isAnimating = true
                animation.prepare(
                    contentView: self.view,
                    currentViewController: currentViewController,
                    targetViewController: targetViewController
                )
                animation.update(animated: animated, complete: { [weak self] _ in
                    guard let strong = self else { return }
                    strong._disappearViewController(currentViewController)
                    strong.isAnimating = false
                    completion?()
                })
            } else {
                if let vc = previousViewController {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                    self._disappearViewController(vc)
                }
                if let vc = viewController {
                    vc.willPresent(animated: false)
                    vc.didPresent(animated: false)
                }
                completion?()
            }
        } else {
            updation?()
            completion?()
        }
    }
    
    private func _addChildViewController(_ viewController: IQGroupViewController) {
        viewController.parent = self
    }
    
    private func _removeChildViewController(_ viewController: IQGroupViewController) {
        viewController.parent = nil
    }

    private func _appearViewController(_ viewController: IQGroupViewController) {
        viewController.view.frame = self.view.bounds
        if let groupbar = self._groupbar {
            self.view.insertSubview(viewController.view, belowSubview: groupbar)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _disappearViewController(_ viewController: IQGroupViewController) {
        viewController.view.removeFromSuperview()
    }

    private func _prepareAnimation(_ viewController: IQGroupViewController) -> IQGroupViewControllerAnimation {
        if let animation = viewController.groupAnimation { return animation }
        return self.animation
    }

    private func _updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: (self._groupbar != nil && self._groupbarHidden == false) ? self._groupbarHeight * self._groupbarVisibility : 0,
            right: 0
        )
    }
    
    private func _updateGroupbar(bounds: CGRect, animated: Bool) {
        guard let groupbar = self._groupbar else { return }
        if animated == true {
            UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                groupbar.edgeInsets = self._groupbarEdgeInsets()
                groupbar.frame = self._groupbarFrame(bounds: bounds)
            })
        } else {
            groupbar.edgeInsets = self._groupbarEdgeInsets()
            groupbar.frame = self._groupbarFrame(bounds: bounds)
        }
    }

    private func _groupbarFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self._groupbarHeight + edgeInsets.bottom
        if self._groupbarHidden == true {
            return CGRect(
                x: bounds.origin.x,
                y: bounds.maxY,
                width: bounds.size.width,
                height: fullHeight
            )
        }
        return CGRect(
            x: bounds.origin.x,
            y: bounds.maxY - (fullHeight * self._groupbarVisibility),
            width: bounds.size.width,
            height: fullHeight
        )
    }

    private func _groupbarEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: 0,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom,
            right: edgeInsets.right
        )
    }

}

extension QGroupContainerViewController : QGroupbarDelegate {

    public func groupbar(_ groupbar: QGroupbar, didSelectItem: QGroupbarItem) {
        guard let index = self._viewControllers.index(where: { return $0.groupbarItem === didSelectItem }) else { return }
        let viewController = self._viewControllers[index]
        self._updateViewControllers(viewController, animated: true)
    }

}
