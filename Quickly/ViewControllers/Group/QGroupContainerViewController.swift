//
//  Quickly
//

open class QGroupContainerViewController : QViewController, IQGroupContainerViewController, IQStackContentViewController, IQModalContentViewController, IQHamburgerContentViewController {

    open var barView: QGroupbar? {
        set(value) { self.set(barView: value) }
        get { return self._groupbar }
    }
    open var barHeight: CGFloat {
        set(value) { self.set(barHeight: value) }
        get { return self._groupbarHeight }
    }
    open var barHidden: Bool {
        set(value) { self.set(barHidden: value) }
        get { return self._groupbarHidden }
    }
    open var barVisibility: CGFloat {
        set(value) { self.set(barVisibility: value) }
        get { return self._groupbarVisibility }
    }
    open var viewControllers: [IQGroupViewController] {
        set(value) { self.set(viewControllers: value) }
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
            self._appear(viewController: vc)
            self.currentViewController = vc
        }
        if let groupbar = self._groupbar {
            groupbar.items = self._viewControllers.compactMap({ return $0.barItem })
            groupbar.setSelectedItem(self.currentViewController?.barItem, animated: false)
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
            groupbar.edgeInsets = self._barEdgeInsets()
            groupbar.frame = self._barFrame(bounds: bounds)
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

    open func set(barView: QGroupbar?, animated: Bool = false) {
        if self._groupbar !== barView {
            if self.isLoaded == true {
                if let view = self._groupbar {
                    view.removeFromSuperview()
                    view.delegate = nil
                }
                self._groupbar = barView
                if let view = self._groupbar {
                    view.frame = self._barFrame(bounds: self.view.bounds)
                    view.edgeInsets = self._barEdgeInsets()
                    view.delegate = self
                    self.view.addSubview(view)
                }
                self.setNeedLayout()
            } else {
                if let view = self._groupbar {
                    view.delegate = nil
                }
                self._groupbar = barView
                if let view = self._groupbar {
                    view.delegate = self
                }
            }
            self._updateAdditionalEdgeInsets()
        }
    }

    open func set(barHeight: CGFloat, animated: Bool = false) {
        if self._groupbarHeight != barHeight {
            self._groupbarHeight = barHeight
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateBar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func set(barHidden: Bool, animated: Bool = false) {
        if self._groupbarHidden != barHidden {
            self._groupbarHidden = barHidden
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateBar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func set(barVisibility: CGFloat, animated: Bool = false) {
        if self._groupbarVisibility != barVisibility {
            self._groupbarVisibility = barVisibility
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true {
                self._updateBar(bounds: self.view.bounds, animated: animated)
            }
        }
    }

    open func set(viewControllers: [IQGroupViewController], animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        self._viewControllers.forEach({ self._remove(childViewController: $0) })
        self._viewControllers = viewControllers
        self._viewControllers.forEach({ self._add(childViewController: $0) })
        if self.isLoaded == true {
            self._update(viewController: self.currentViewController, animated: animated, updation: {
                if let groupbar = self._groupbar {
                    let groupbarItems = self._viewControllers.compactMap({ return $0.barItem })
                    let selectedGroupbarItem = self.currentViewController?.barItem
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

    open func set(currentViewController: IQGroupViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        guard self._viewControllers.contains(where: { $0 === currentViewController }) == true else { return }
        if self.isLoaded == true {
            self._update(viewController: currentViewController, animated: animated, updation: {
                if let groupbar = self._groupbar {
                    groupbar.setSelectedItem(currentViewController.barItem, animated: animated)
                }
            }, completion: completion)
        } else {
            self.currentViewController = currentViewController
        }
    }

    open func didUpdate(viewController: IQGroupViewController, animated: Bool) {
        guard let groupbar = self._groupbar else { return }
        guard let index = self._viewControllers.firstIndex(where: { $0 === viewController }) else { return }
        guard let barItem = viewController.barItem else { return }
        groupbar.replaceItem(barItem, index: index)
    }
    
    // MARK: IQContentViewController
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    
    open func notifyBeginUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.beginUpdateContent()
        }
    }
    
    open func notifyUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if let viewController = self.contentOwnerViewController {
            return viewController.finishUpdateContent(velocity: velocity)
        }
        return nil
    }
    
    open func notifyEndUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.endUpdateContent()
        }
    }
    
}

// MARK: - Private -

extension QGroupContainerViewController {

    private func _update(viewController: IQGroupViewController?, animated: Bool, updation: (() -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        if self.currentViewController !== viewController {
            let previousViewController = self.currentViewController
            self.currentViewController = viewController
            if let vc = self.currentViewController {
                self._appear(viewController: vc)
            }
            updation?()
            if let currentViewController = previousViewController, let targetViewController = viewController {
                let animation = self._animation(viewController: currentViewController)
                self.isAnimating = true
                animation.animate(
                    contentView: self.view,
                    currentViewController: currentViewController,
                    targetViewController: targetViewController,
                    animated: animated,
                    complete: { [weak self] in
                        if let self = self {
                            self._disappear(viewController: currentViewController)
                            self.isAnimating = false
                        }
                        completion?()
                    }
                )
            } else {
                if let vc = previousViewController {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                    self._disappear(viewController: vc)
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
    
    private func _add(childViewController: IQGroupViewController) {
        childViewController.parentViewController = self
    }
    
    private func _remove(childViewController: IQGroupViewController) {
        childViewController.parentViewController = nil
    }

    private func _appear(viewController: IQGroupViewController) {
        viewController.view.frame = self.view.bounds
        if let groupbar = self._groupbar {
            self.view.insertSubview(viewController.view, belowSubview: groupbar)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _disappear(viewController: IQGroupViewController) {
        viewController.view.removeFromSuperview()
    }

    private func _animation(viewController: IQGroupViewController) -> IQGroupViewControllerAnimation {
        if let animation = viewController.animation { return animation }
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
    
    private func _updateBar(bounds: CGRect, animated: Bool) {
        guard let groupbar = self._groupbar else { return }
        if animated == true {
            UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                groupbar.edgeInsets = self._barEdgeInsets()
                groupbar.frame = self._barFrame(bounds: bounds)
            })
        } else {
            groupbar.edgeInsets = self._barEdgeInsets()
            groupbar.frame = self._barFrame(bounds: bounds)
        }
    }

    private func _barFrame(bounds: CGRect) -> CGRect {
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

    private func _barEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: 0,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom,
            right: edgeInsets.right
        )
    }

}

// MARK: - QGroupbarDelegate -

extension QGroupContainerViewController : QGroupbarDelegate {

    public func groupbar(_ groupbar: QGroupbar, didSelectItem: QGroupbarItem) {
        guard let index = self._viewControllers.firstIndex(where: { return $0.barItem === didSelectItem }) else { return }
        let viewController = self._viewControllers[index]
        self._update(viewController: viewController, animated: true)
    }

}
