//
//  Quickly
//

open class QPageContainerViewController : QViewController, IQPageContainerViewController, IQStackContentViewController, IQGroupContentViewController, IQModalContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open var pagebar: QPagebar? {
        set(value) { self.setPagebar(value) }
        get { return self._pagebar }
    }
    open var pagebarHeight: CGFloat {
        set(value) { self.setPagebarHeight(value) }
        get { return self._pagebarHeight }
    }
    open var pagebarHidden: Bool {
        set(value) { self.setPagebarHidden(value) }
        get { return self._pagebarHidden }
    }
    open var viewControllers: [IQPageViewController] {
        set(value) { self.setViewControllers(value) }
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
            if let pagebar = self._pagebar {
                pagebar.isUserInteractionEnabled = self.isAnimating == false
            }
        }
    }
    public private(set) lazy var interactiveGesture: UIPanGestureRecognizer = self._prepareInteractiveGesture()
    
    private var _pagebar: QPagebar?
    private var _pagebarHeight: CGFloat
    private var _pagebarHidden: Bool
    private var _viewControllers: [IQPageViewController]
    private var _activeInteractiveCurrentViewController: IQPageViewController?
    private var _activeInteractiveForwardViewController: IQPageViewController?
    private var _activeInteractiveBackwardViewController: IQPageViewController?
    private var _activeInteractiveAnimation: IQPageViewControllerInteractiveAnimation?

    public override init() {
        self._pagebarHeight = 44
        self._pagebarHidden = false
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

        let displayed = self._displayedViewController(self.currentViewController)
        if let vc = displayed.0 {
            self._appearViewController(vc, frame: self._backwardViewControllerFrame())
            self.backwardViewController = vc
        }
        if let vc = displayed.1 {
            self._appearViewController(vc, frame: self._currentViewControllerFrame())
            self.currentViewController = vc
        }
        if let vc = displayed.2 {
            self._appearViewController(vc, frame: self._forwardViewControllerFrame())
            self.forwardViewController = vc
        }
        if let pagebar = self._pagebar {
            pagebar.items = self._viewControllers.compactMap({ return $0.pageItem })
            pagebar.setSelectedItem(self.currentViewController?.pageItem, animated: false)
            self.view.addSubview(pagebar)
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
        if let pagebar = self._pagebar {
            pagebar.edgeInsets = self._pagebarEdgeInsets()
            pagebar.frame = self._pagebarFrame(bounds: bounds)
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

    open func setPagebar(_ pagebar: QPagebar?, animated: Bool = false) {
        if self.isLoaded == true {
            if let pagebar = self._pagebar {
                pagebar.removeFromSuperview()
                pagebar.delegate = nil
            }
            self._pagebar = pagebar
            if let pagebar = self._pagebar {
                pagebar.frame = self._pagebarFrame(bounds: self.view.bounds)
                pagebar.edgeInsets = self._pagebarEdgeInsets()
                pagebar.delegate = self
                self.view.addSubview(pagebar)
            }
            self.setNeedLayout()
        } else {
            if let pagebar = self._pagebar {
                pagebar.delegate = nil
            }
            self._pagebar = pagebar
            if let pagebar = self._pagebar {
                pagebar.delegate = self
            }
        }
        self._updateAdditionalEdgeInsets()
    }

    open func setPagebarHeight(_ value: CGFloat, animated: Bool = false) {
        self._pagebarHeight = value
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

    open func setPagebarHidden(_ value: Bool, animated: Bool = false) {
        self._pagebarHidden = value
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

    open func setViewControllers(_ viewControllers: [IQPageViewController], mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        self._viewControllers.forEach({
            self._disappearViewController($0)
            self._removeChildViewController($0)
        })
        self._viewControllers = viewControllers
        self._viewControllers.forEach({ self._addChildViewController($0) })
        if self.isLoaded == true {
            self._updateViewControllers(self.currentViewController, mode: mode, updation: {
                if let pagebar = self._pagebar {
                    let pagebarItems = self._viewControllers.compactMap({ return $0.pageItem })
                    let selectedPagebarItem = self.currentViewController?.pageItem
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

    open func setCurrentViewController(_ viewController: IQPageViewController, mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        guard self._viewControllers.contains(where: { viewController === $0 }) == true else { return }
        if self.isLoaded == true {
            self._updateViewControllers(viewController, mode: mode, updation: {
                if let pagebar = self._pagebar {
                    pagebar.setSelectedItem(viewController.pageItem, animated: mode.isAnimating)
                }
            }, completion: completion)
        } else {
            self.currentViewController = viewController
        }
    }

    open func updatePageItem(_ viewController: IQPageViewController, animated: Bool) {
        guard let pagebar = self._pagebar else { return }
        guard let index = self._viewControllers.firstIndex(where: { $0 === viewController }) else { return }
        guard let pagebarItem = viewController.pageItem else { return }
        pagebar.replaceItem(pagebarItem, index: index)
    }

    private func _displayedViewController(_ viewController: IQPageViewController?) -> (IQPageViewController?, IQPageViewController?, IQPageViewController?) {
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

    private func _updateViewControllers(_ viewController: IQPageViewController?, mode: QPageViewControllerAnimationMode, updation: (() -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        let currently = (self.backwardViewController, self.currentViewController, self.forwardViewController)
        let displayed = self._displayedViewController(viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
            updation?()
            if mode.isAnimating == true, let currentViewController = currently.1, let targetViewController = displayed.1 {
                var animation: IQPageViewControllerAnimation
                switch mode {
                case .none: fatalError("Invalid mode")
                case .backward: animation = self._prepareBackwardAnimation(currentViewController)
                case .forward: animation = self._prepareForwardAnimation(currentViewController)
                }
                self.isAnimating = true
                animation.prepare(
                    contentView: self.view,
                    currentViewController: currentViewController,
                    targetViewController: targetViewController
                )
                animation.update(animated: true, complete: { [weak self] _ in
                    guard let strong = self else { return }
                    strong._disappearViewControllers(currently, displayed)
                    strong.isAnimating = false
                    completion?()
                })
            } else {
                if let vc = currently.1 {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                }
                if let vc = displayed.1 {
                    vc.willPresent(animated: false)
                    vc.didPresent(animated: false)
                }
                self._disappearViewControllers(currently, displayed)
                completion?()
            }
        } else {
            updation?()
            self._disappearViewControllers(currently, displayed)
            completion?()
        }
    }
    
    private func _addChildViewController(_ viewController: IQPageViewController) {
        viewController.parent = self
    }
    
    private func _removeChildViewController(_ viewController: IQPageViewController) {
        viewController.parent = nil
    }

    private func _appearViewController(_ viewController: IQPageViewController, frame: CGRect) {
        viewController.view.frame = frame
        if viewController.view.superview !== self.view {
            if let pagebar = self._pagebar {
                self.view.insertSubview(viewController.view, belowSubview: pagebar)
            } else {
                self.view.addSubview(viewController.view)
            }
        }
    }

    private func _disappearViewControllers(_ oldViewControllers: (IQPageViewController?, IQPageViewController?, IQPageViewController?), _ newViewControllers: (IQPageViewController?, IQPageViewController?, IQPageViewController?)) {
        if let vc = oldViewControllers.0, (newViewControllers.0 !== vc) && (newViewControllers.1 !== vc) && (newViewControllers.2 !== vc) {
            self._disappearViewController(vc)
        }
        if let vc = oldViewControllers.1, (newViewControllers.0 !== vc) && (newViewControllers.1 !== vc) && (newViewControllers.2 !== vc) {
            self._disappearViewController(vc)
        }
        if let vc = oldViewControllers.2, (newViewControllers.0 !== vc) && (newViewControllers.1 !== vc) && (newViewControllers.2 !== vc) {
            self._disappearViewController(vc)
        }
    }

    private func _disappearViewController(_ viewController: IQPageViewController) {
        viewController.view.removeFromSuperview()
    }

    private func _prepareForwardAnimation(_ viewController: IQPageViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.pageForwardAnimation { return animation }
        return self.forwardAnimation
    }

    private func _prepareBackwardAnimation(_ viewController: IQPageViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.pageBackwardAnimation { return animation }
        return self.backwardAnimation
    }

    private func _prepareInteractiveAnimation(_ viewController: IQPageViewController) -> IQPageViewControllerInteractiveAnimation? {
        if let animation = viewController.pageInteractiveAnimation { return animation }
        return self.interactiveAnimation
    }

    private func _prepareInteractiveGesture() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._interactiveGestureHandler(_:)))
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        return gesture
    }

    private func _updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: (self._pagebar != nil && self._pagebarHidden == false) ? self._pagebarHeight : 0,
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

    private func _pagebarFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self._pagebarHeight + edgeInsets.top
        if self._pagebarHidden == true {
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

    private func _pagebarEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

    @objc
    private func _interactiveGestureHandler(_ sender: Any) {
        let position = self.interactiveGesture.location(in: nil)
        let velocity = self.interactiveGesture.velocity(in: nil)
        switch self.interactiveGesture.state {
        case .began:
            guard
                let currentViewController = self.currentViewController,
                let animation = self._prepareInteractiveAnimation(currentViewController)
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
                    case .backward: strong._endInteractive(strong._activeInteractiveBackwardViewController)
                    case .forward: strong._endInteractive(strong._activeInteractiveForwardViewController)
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

    private func _endInteractive(_ viewController: IQPageViewController?) {
        let currently = (
            self._activeInteractiveBackwardViewController,
            self._activeInteractiveCurrentViewController,
            self._activeInteractiveForwardViewController
        )
        let displayed = self._displayedViewController(viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._backwardViewControllerFrame()
                self._appearViewController(vc, frame: frame)
            }
        }
        self._disappearViewControllers(currently, displayed)
        if let pagebar = self._pagebar {
            pagebar.setSelectedItem(self.currentViewController?.pageItem, animated: true)
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

extension QPageContainerViewController : QPagebarDelegate {

    public func pagebar(_ pagebar: QPagebar, didSelectItem: QPagebarItem) {
        guard let index = self._viewControllers.firstIndex(where: { return $0.pageItem === didSelectItem }) else { return }
        let viewController = self._viewControllers[index]
        var mode: QPageViewControllerAnimationMode = .forward
        if let currentViewController = self.currentViewController {
            if let currentIndex = self._viewControllers.firstIndex(where: { return $0 === currentViewController }) {
                mode = (currentIndex > index) ? .backward : .forward
            }
        }
        self._updateViewControllers(viewController, mode: mode)
    }

}

extension QPageContainerViewController : UIGestureRecognizerDelegate {
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer == self.interactiveGesture else { return false }
        if let pagebar = self._pagebar {
            let location = touch.location(in: self.view)
            if pagebar.point(inside: location, with: nil) == true {
                return false
            }
        }
        return true
    }

}
