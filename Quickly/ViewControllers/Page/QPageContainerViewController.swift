//
//  Quickly
//

open class QPageContainerViewController : QViewController, IQPageContainerViewController, IQStackContentViewController, IQGroupContentViewController, IQModalContentViewController, IQHamburgerContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open var barView: QPagebar? {
        set(value) { self.set(barView: value) }
        get { return self._barView }
    }
    open var barHeight: CGFloat {
        set(value) { self.set(barHeight: value) }
        get { return self._barHeight }
    }
    open var barHidden: Bool {
        set(value) { self.set(barHidden: value) }
        get { return self._barHidden }
    }
    open var viewControllers: [IQPageViewController] {
        set(value) { self.set(viewControllers: value) }
        get { return self._viewControllers }
    }
    open private(set) var currentViewController: IQPageViewController?
    open private(set) var forwardViewController: IQPageViewController?
    open private(set) var backwardViewController: IQPageViewController?
    open var forwardAnimation: IQPageViewControllerAnimation
    open var backwardAnimation: IQPageViewControllerAnimation
    open var interactiveAnimation: IQPageViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool {
        didSet {
            if let pagebar = self._barView {
                pagebar.isUserInteractionEnabled = self.isAnimating == false
            }
        }
    }
    public private(set) lazy var interactiveGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleInteractiveGesture(_:)))
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        return gesture
    }()
    
    private var _barView: QPagebar?
    private var _barHeight: CGFloat
    private var _barHidden: Bool
    private var _viewControllers: [IQPageViewController]
    private var _activeInteractiveCurrentViewController: IQPageViewController?
    private var _activeInteractiveForwardViewController: IQPageViewController?
    private var _activeInteractiveBackwardViewController: IQPageViewController?
    private var _activeInteractiveAnimation: IQPageViewControllerInteractiveAnimation?

    public override init() {
        self._barHeight = 44
        self._barHidden = false
        self._viewControllers = []
        self.forwardAnimation = QPageViewControllerForwardAnimation()
        self.backwardAnimation = QPageViewControllerBackwardAnimation()
        self.interactiveAnimation = QPageViewControllerInteractiveAnimation()
        self.isAnimating = false
        super.init()
    }

    open override func didLoad() {
        self._updateAdditionalEdgeInsets()

        self.view.addGestureRecognizer(self.interactiveGesture)

        let displayed = self._displayed(viewController: self.currentViewController)
        if let vc = displayed.0 {
            self._appear(viewController: vc, frame: self._backwardViewControllerFrame())
            self.backwardViewController = vc
        }
        if let vc = displayed.1 {
            self._appear(viewController: vc, frame: self._currentViewControllerFrame())
            self.currentViewController = vc
        }
        if let vc = displayed.2 {
            self._appear(viewController: vc, frame: self._forwardViewControllerFrame())
            self.forwardViewController = vc
        }
        if let pagebar = self._barView {
            pagebar.items = self._viewControllers.compactMap({ return $0.item })
            pagebar.setSelectedItem(self.currentViewController?.item, animated: false)
            self.view.addSubview(pagebar)
            self.view.bringSubviewToFront(pagebar)
        }
    }

    open override func layout(bounds: CGRect) {
        guard self.isAnimating == false else {
            return
        }
        if let vc = self.backwardViewController {
            vc.view.frame = self._backwardViewControllerFrame()
        }
        if let vc = self.currentViewController {
            vc.view.frame = self._currentViewControllerFrame()
        }
        if let vc = self.forwardViewController {
            vc.view.frame = self._forwardViewControllerFrame()
        }
        if let pagebar = self._barView {
            pagebar.edgeInsets = self._barEdgeInsets()
            pagebar.frame = self._barFrame(bounds: bounds)
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

    open func set(barView: QPagebar?, animated: Bool = false) {
        if self.isLoaded == true {
            if let pagebar = self._barView {
                pagebar.removeFromSuperview()
                pagebar.delegate = nil
            }
            self._barView = barView
            if let pagebar = self._barView {
                pagebar.frame = self._barFrame(bounds: self.view.bounds)
                pagebar.edgeInsets = self._barEdgeInsets()
                pagebar.delegate = self
                self.view.addSubview(pagebar)
                self.view.bringSubviewToFront(pagebar)
            }
            self.setNeedLayout()
        } else {
            if let pagebar = self._barView {
                pagebar.delegate = nil
            }
            self._barView = barView
            if let pagebar = self._barView {
                pagebar.delegate = self
            }
        }
        self._updateAdditionalEdgeInsets()
    }

    open func set(barHeight: CGFloat, animated: Bool = false) {
        self._barHeight = barHeight
        self.setNeedLayout()
        self._updateAdditionalEdgeInsets()
        if self.isLoaded == true {
            if animated == true {
                UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }

    open func set(barHidden: Bool, animated: Bool = false) {
        self._barHidden = barHidden
        self.setNeedLayout()
        self._updateAdditionalEdgeInsets()
        if self.isLoaded == true {
            if animated == true {
                UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }

    open func set(viewControllers: [IQPageViewController], mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        self._viewControllers.forEach({
            self._disappear(viewController: $0)
            self._remove(childViewController: $0)
        })
        self._viewControllers = viewControllers
        self._viewControllers.forEach({ self._add(childViewController: $0) })
        if self.isLoaded == true {
            self._update(viewController: self.currentViewController, mode: mode, updation: {
                if let pagebar = self._barView {
                    let pagebarItems = self._viewControllers.compactMap({ return $0.item })
                    let selectedPagebarItem = self.currentViewController?.item
                    switch mode {
                    case .none:
                        pagebar.items = pagebarItems
                        pagebar.setSelectedItem(selectedPagebarItem, animated: true)
                    case .backward,
                         .forward:
                        pagebar.performBatchUpdates({
                            pagebar.deleteItem(pagebar.items)
                            pagebar.appendItem(pagebarItems)
                        }, completion: { _ in
                            pagebar.setSelectedItem(selectedPagebarItem, animated: true)
                        })
                    }
                }
            }, completion: completion)
        }
    }

    open func set(currentViewController: IQPageViewController, mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        guard self._viewControllers.contains(where: { currentViewController === $0 }) == true else { return }
        if self.isLoaded == true {
            self._update(viewController: currentViewController, mode: mode, updation: {
                if let pagebar = self._barView {
                    pagebar.setSelectedItem(currentViewController.item, animated: mode.isAnimating)
                }
            }, completion: completion)
        } else {
            self.currentViewController = currentViewController
        }
    }

    open func didUpdate(viewController: IQPageViewController, animated: Bool) {
        guard let pagebar = self._barView else { return }
        guard let index = self._viewControllers.firstIndex(where: { $0 === viewController }) else { return }
        guard let pagebarItem = viewController.item else { return }
        pagebar.replaceItem(pagebarItem, index: index)
    }
    
}

// MARK: - Private -

extension QPageContainerViewController {

    private func _displayed(viewController: IQPageViewController?) -> (IQPageViewController?, IQPageViewController?, IQPageViewController?) {
        var displayedBackward: IQPageViewController?
        var displayedCurrent: IQPageViewController?
        var displayedForward: IQPageViewController?
        if self._viewControllers.contains(where: { viewController === $0 }) == true {
            displayedCurrent = viewController
        } else {
            displayedCurrent = self._viewControllers.first
        }
        if let current = displayedCurrent {
            if let index = self._viewControllers.firstIndex(where: { $0 === current }) {
                displayedBackward = (index != self._viewControllers.startIndex) ? self._viewControllers[index - 1] : nil
                displayedForward = (index != self._viewControllers.endIndex - 1) ? self._viewControllers[index + 1] : nil
            } else {
                displayedForward = (self._viewControllers.count > 1) ? self._viewControllers[self._viewControllers.startIndex + 1] : nil
            }
        }
        return (displayedBackward, displayedCurrent, displayedForward)
    }

    private func _update(viewController: IQPageViewController?, mode: QPageViewControllerAnimationMode, updation: (() -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        let currently = (self.backwardViewController, self.currentViewController, self.forwardViewController)
        let displayed = self._displayed(viewController: viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._forwardViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
            updation?()
            if mode.isAnimating == true, let currentViewController = currently.1, let targetViewController = displayed.1 {
                var animation: IQPageViewControllerAnimation
                switch mode {
                case .none: fatalError("Invalid mode")
                case .backward: animation = self._backwardAnimation(viewController: currentViewController)
                case .forward: animation = self._forwardAnimation(viewController: currentViewController)
                }
                self.isAnimating = true
                animation.animate(
                    contentView: self.view,
                    currentViewController: currentViewController,
                    targetViewController: targetViewController,
                    animated: true,
                    complete: { [weak self] in
                        guard let strong = self else { return }
                        strong._disappear(old: currently, new: displayed)
                        strong.isAnimating = false
                        completion?()
                    }
                )
            } else {
                if let vc = currently.1 {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                }
                if let vc = displayed.1 {
                    vc.willPresent(animated: false)
                    vc.didPresent(animated: false)
                }
                self._disappear(old: currently, new: displayed)
                completion?()
            }
        } else {
            updation?()
            self._disappear(old: currently, new: displayed)
            completion?()
        }
    }
    
    private func _add(childViewController: IQPageViewController) {
        childViewController.parentViewController = self
    }
    
    private func _remove(childViewController: IQPageViewController) {
        childViewController.parentViewController = nil
    }

    private func _appear(viewController: IQPageViewController, frame: CGRect) {
        viewController.view.frame = frame
        if viewController.view.superview !== self.view {
            if let pagebar = self._barView {
                self.view.insertSubview(viewController.view, belowSubview: pagebar)
            } else {
                self.view.addSubview(viewController.view)
            }
        }
    }

    private func _disappear(old: (IQPageViewController?, IQPageViewController?, IQPageViewController?), new: (IQPageViewController?, IQPageViewController?, IQPageViewController?)) {
        if let vc = old.0, (new.0 !== vc) && (new.1 !== vc) && (new.2 !== vc) {
            self._disappear(viewController: vc)
        }
        if let vc = old.1, (new.0 !== vc) && (new.1 !== vc) && (new.2 !== vc) {
            self._disappear(viewController: vc)
        }
        if let vc = old.2, (new.0 !== vc) && (new.1 !== vc) && (new.2 !== vc) {
            self._disappear(viewController: vc)
        }
    }

    private func _disappear(viewController: IQPageViewController) {
        viewController.view.removeFromSuperview()
    }

    private func _forwardAnimation(viewController: IQPageViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.forwardAnimation { return animation }
        return self.forwardAnimation
    }

    private func _backwardAnimation(viewController: IQPageViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.backwardAnimation { return animation }
        return self.backwardAnimation
    }

    private func _interactiveAnimation(viewController: IQPageViewController) -> IQPageViewControllerInteractiveAnimation? {
        if let animation = viewController.interactiveAnimation { return animation }
        return self.interactiveAnimation
    }

    private func _updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: (self._barView != nil && self._barHidden == false) ? self._barHeight : 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }

    private func _currentViewControllerFrame() -> CGRect {
        return self.view.bounds
    }

    private func _forwardViewControllerFrame() -> CGRect {
        let current = self._currentViewControllerFrame()
        return CGRect(
            x: current.origin.x + current.size.width,
            y: current.origin.y,
            width: current.size.width,
            height: current.size.height
        )
    }

    private func _backwardViewControllerFrame() -> CGRect {
        let current = self._currentViewControllerFrame()
        return CGRect(
            x: current.origin.x - current.size.width,
            y: current.origin.y,
            width: current.size.width,
            height: current.size.height
        )
    }

    private func _barFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self._barHeight + edgeInsets.top
        if self._barHidden == true {
            return CGRect(
                x: bounds.origin.x,
                y: bounds.origin.y - fullHeight,
                width: bounds.size.width,
                height: fullHeight
            )
        }
        return CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width,
            height: fullHeight
        )
    }

    private func _barEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

    @objc
    private func _handleInteractiveGesture(_ sender: Any) {
        let position = self.interactiveGesture.location(in: nil)
        let velocity = self.interactiveGesture.velocity(in: nil)
        switch self.interactiveGesture.state {
        case .began:
            guard
                let currentViewController = self.currentViewController,
                let animation = self._interactiveAnimation(viewController: currentViewController)
                else { return }
            self._activeInteractiveBackwardViewController = self.backwardViewController
            self._activeInteractiveForwardViewController = self.forwardViewController
            self._activeInteractiveCurrentViewController = currentViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                backwardViewController: self.backwardViewController,
                currentViewController: currentViewController,
                forwardViewController: self.forwardViewController,
                position: position,
                velocity: velocity
            )
            break
        case .changed:
            guard let animation = self._activeInteractiveAnimation else { return }
            animation.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard let animation = self._activeInteractiveAnimation else { return }
            if animation.canFinish == true {
                animation.finish({ [weak self] (completed: Bool) in
                    guard let strong = self else { return }
                    switch animation.finishMode {
                    case .none: strong._endInteractive()
                    case .backward: strong._endInteractive(viewController: strong._activeInteractiveBackwardViewController)
                    case .forward: strong._endInteractive(viewController: strong._activeInteractiveForwardViewController)
                    }
                })
            } else {
                animation.cancel({ [weak self] (completed: Bool) in
                    guard let strong = self else { return }
                    strong._endInteractive()
                })
            }
            break
        default:
            break
        }
    }

    private func _endInteractive(viewController: IQPageViewController?) {
        let currently = (
            self._activeInteractiveBackwardViewController,
            self._activeInteractiveCurrentViewController,
            self._activeInteractiveForwardViewController
        )
        let displayed = self._displayed(viewController: viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._forwardViewControllerFrame()
                self._appear(viewController: vc, frame: frame)
            }
        }
        self._disappear(old: currently, new: displayed)
        if let pagebar = self._barView {
            pagebar.setSelectedItem(self.currentViewController?.item, animated: true)
        }
        self._endInteractive()
    }

    private func _endInteractive() {
        self._activeInteractiveBackwardViewController = nil
        self._activeInteractiveCurrentViewController = nil
        self._activeInteractiveForwardViewController = nil
        self._activeInteractiveAnimation = nil
        self.isAnimating = false
    }

}

// MARK: - QPagebarDelegate -

extension QPageContainerViewController : QPagebarDelegate {

    public func pagebar(_ pagebar: QPagebar, didSelectItem: QPagebarItem) {
        guard let index = self._viewControllers.firstIndex(where: { return $0.item === didSelectItem }) else { return }
        let viewController = self._viewControllers[index]
        var mode: QPageViewControllerAnimationMode = .forward
        if let currentViewController = self.currentViewController {
            if let currentIndex = self._viewControllers.firstIndex(where: { return $0 === currentViewController }) {
                mode = (currentIndex > index) ? .backward : .forward
            }
        }
        self._update(viewController: viewController, mode: mode)
    }

}

// MARK: - UIGestureRecognizerDelegate -

extension QPageContainerViewController : UIGestureRecognizerDelegate {
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer == self.interactiveGesture else { return false }
        if let pagebar = self._barView {
            let location = touch.location(in: self.view)
            if pagebar.point(inside: location, with: nil) == true {
                return false
            }
        }
        return true
    }

}
