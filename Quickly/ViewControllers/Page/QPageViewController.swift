//
//  Quickly
//

open class QPageViewController : QViewController, IQPageViewController, IQStackContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open private(set) var pagebar: QPagebar?
    open private(set) var pagebarHeight: CGFloat
    open private(set) var pagebarHidden: Bool
    open private(set) var viewControllers: [IQPageSlideViewController]
    open private(set) var currentViewController: IQPageSlideViewController?
    open private(set) var forwardViewController: IQPageSlideViewController?
    open private(set) var backwardViewController: IQPageSlideViewController?
    open var forwardAnimation: IQPageViewControllerAnimation
    open var backwardAnimation: IQPageViewControllerAnimation
    open var interactiveAnimation: IQPageViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool {
        didSet {
            if let pagebar = self.pagebar {
                pagebar.isUserInteractionEnabled = self.isAnimating == false
            }
        }
    }
    public private(set) lazy var interactiveGesture: UIPanGestureRecognizer = self._prepareInteractiveGesture()
    private var activeInteractiveCurrentViewController: IQPageSlideViewController?
    private var activeInteractiveForwardViewController: IQPageSlideViewController?
    private var activeInteractiveBackwardViewController: IQPageSlideViewController?
    private var activeInteractiveAnimation: IQPageViewControllerInteractiveAnimation?

    public override init() {
        self.pagebarHeight = 44
        self.pagebarHidden = false
        self.viewControllers = []
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
        if let pagebar = self.pagebar {
            pagebar.items = self.viewControllers.compactMap({ return $0.pagebarItem })
            pagebar.setSelectedItem(self.currentViewController?.pagebarItem, animated: false)
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
        if let pagebar = self.pagebar {
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

    open func setPagebar(_ pagebar: QPagebar?, animated: Bool = false) {
        if self.isLoaded == true {
            if let pagebar = self.pagebar {
                pagebar.removeFromSuperview()
                pagebar.delegate = nil
            }
            self.pagebar = pagebar
            if let pagebar = self.pagebar {
                pagebar.frame = self._pagebarFrame(bounds: self.view.bounds)
                pagebar.edgeInsets = self._pagebarEdgeInsets()
                pagebar.delegate = self
                self.view.addSubview(pagebar)
            }
            self.setNeedLayout()
        } else {
            if let pagebar = self.pagebar {
                pagebar.delegate = nil
            }
            self.pagebar = pagebar
            if let pagebar = self.pagebar {
                pagebar.delegate = self
            }
        }
        self._updateAdditionalEdgeInsets()
    }

    open func setPagebarHeight(_ value: CGFloat, animated: Bool = false) {
    }

    open func setPagebarHidden(_ value: Bool, animated: Bool = false) {
    }

    open func setViewControllers(_ viewControllers: [IQPageSlideViewController], mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        self.viewControllers = viewControllers
        if self.isLoaded == true {
            self._updateViewControllers(self.currentViewController, mode: mode, updation: {
                if let pagebar = self.pagebar {
                    let pagebarItems = self.viewControllers.compactMap({ return $0.pagebarItem })
                    let selectedPagebarItem = self.currentViewController?.pagebarItem
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

    open func setCurrentViewController(_ viewController: IQPageSlideViewController, mode: QPageViewControllerAnimationMode = .none, completion: (() -> Swift.Void)? = nil) {
        guard self.viewControllers.contains(where: { $0 === viewController }) == true else { return }
        if self.isLoaded == true {
            self._updateViewControllers(viewController, mode: mode, updation: {
                if let pagebar = self.pagebar {
                    pagebar.setSelectedItem(viewController.pagebarItem, animated: mode.isAnimating)
                }
            }, completion: completion)
        } else {
            self.currentViewController = viewController
        }
    }

    open func updatePagebarItem(_ viewController: IQPageSlideViewController, animated: Bool) {
        guard let pagebar = self.pagebar else { return }
        guard let index = self.viewControllers.index(where: { $0 === viewController }) else { return }
        guard let pagebarItem = viewController.pagebarItem else { return }
        pagebar.replaceItem(pagebarItem, index: index)
    }

    private func _displayedViewController(_ viewController: IQPageSlideViewController?) -> (IQPageSlideViewController?, IQPageSlideViewController?, IQPageSlideViewController?) {
        var displayedBackward: IQPageSlideViewController?
        var displayedCurrent: IQPageSlideViewController?
        var displayedForward: IQPageSlideViewController?
        if let vc = viewController {
            displayedCurrent = vc
        } else {
            displayedCurrent = self.viewControllers.first
        }
        if let current = displayedCurrent {
            if let index = self.viewControllers.index(where: { $0 === current }) {
                displayedBackward = (index != self.viewControllers.startIndex) ? self.viewControllers[index - 1] : nil
                displayedForward = (index != self.viewControllers.endIndex - 1) ? self.viewControllers[index + 1] : nil
            } else {
                displayedForward = (self.viewControllers.count > 1) ? self.viewControllers[self.viewControllers.startIndex + 1] : nil
            }
        }
        return (displayedBackward, displayedCurrent, displayedForward)
    }

    private func _updateViewControllers(_ viewController: IQPageSlideViewController?, mode: QPageViewControllerAnimationMode, updation: (() -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        let currently = (self.backwardViewController, self.currentViewController, self.forwardViewController)
        let displayed = self._displayedViewController(viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._backwardViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
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
            self._disappearViewControllers(currently, displayed)
            updation?()
            completion?()
        }
    }

    private func _appearViewController(_ viewController: IQPageSlideViewController, frame: CGRect) {
        viewController.parent = self
        viewController.view.frame = frame
        if let pagebar = self.pagebar {
            self.view.insertSubview(viewController.view, belowSubview: pagebar)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _disappearViewControllers(_ oldViewControllers: (IQPageSlideViewController?, IQPageSlideViewController?, IQPageSlideViewController?), _ newViewControllers: (IQPageSlideViewController?, IQPageSlideViewController?, IQPageSlideViewController?)) {
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

    private func _disappearViewController(_ viewController: IQPageSlideViewController) {
        viewController.view.removeFromSuperview()
        viewController.parent = nil
    }

    private func _prepareForwardAnimation(_ viewController: IQPageSlideViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.forwardAnimation { return animation }
        return self.forwardAnimation
    }

    private func _prepareBackwardAnimation(_ viewController: IQPageSlideViewController) -> IQPageViewControllerAnimation {
        if let animation = viewController.backwardAnimation { return animation }
        return self.backwardAnimation
    }

    private func _prepareInteractiveAnimation(_ viewController: IQPageSlideViewController) -> IQPageViewControllerInteractiveAnimation? {
        if let animation = viewController.interactiveAnimation { return animation }
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
            top: (self.pagebar != nil && self.pagebarHidden == false) ? self.pagebarHeight : 0,
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
        let fullHeight = self.pagebarHeight + edgeInsets.top
        if self.pagebarHidden == true {
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
            self.activeInteractiveBackwardViewController = self.backwardViewController
            self.activeInteractiveForwardViewController = self.forwardViewController
            self.activeInteractiveCurrentViewController = currentViewController
            self.activeInteractiveAnimation = animation
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
            guard let animation = self.activeInteractiveAnimation else { return }
            animation.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard let animation = self.activeInteractiveAnimation else { return }
            if animation.canFinish == true {
                animation.finish({ [weak self] (completed: Bool) in
                    guard let strong = self else { return }
                    switch animation.finishMode {
                    case .none: strong._endInteractive()
                    case .backward: strong._endInteractive(strong.activeInteractiveBackwardViewController)
                    case .forward: strong._endInteractive(strong.activeInteractiveForwardViewController)
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

    private func _endInteractive(_ viewController: IQPageSlideViewController?) {
        let currently = (
            self.activeInteractiveBackwardViewController,
            self.activeInteractiveCurrentViewController,
            self.activeInteractiveForwardViewController
        )
        let displayed = self._displayedViewController(viewController)
        if currently.0 !== displayed.0 {
            self.backwardViewController = displayed.0
            if let vc = self.backwardViewController {
                let frame = self._backwardViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
            }
        }
        if currently.1 !== displayed.1 {
            self.currentViewController = displayed.1
            if let vc = self.currentViewController {
                let frame = self._currentViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
            }
        }
        if currently.2 !== displayed.2 {
            self.forwardViewController = displayed.2
            if let vc = self.forwardViewController {
                let frame = self._backwardViewControllerFrame()
                if vc.parent !== self {
                    self._appearViewController(vc, frame: frame)
                } else {
                    vc.view.frame = frame
                }
            }
        }
        self._disappearViewControllers(currently, displayed)
        if let pagebar = self.pagebar {
            pagebar.setSelectedItem(self.currentViewController?.pagebarItem, animated: true)
        }
        self._endInteractive()
    }

    private func _endInteractive() {
        self.activeInteractiveBackwardViewController = nil
        self.activeInteractiveCurrentViewController = nil
        self.activeInteractiveForwardViewController = nil
        self.activeInteractiveAnimation = nil
        self.isAnimating = false
    }

}

extension QPageViewController : QPagebarDelegate {

    public func pagebar(_ pagebar: QPagebar, didSelectItem: QPagebarItem) {
        guard let index = self.viewControllers.index(where: { return $0.pagebarItem === didSelectItem }) else { return }
        let viewController = self.viewControllers[index]
        var mode: QPageViewControllerAnimationMode = .forward
        if let currentViewController = self.currentViewController {
            if let currentIndex = self.viewControllers.index(where: { return $0 === currentViewController }) {
                mode = (currentIndex > index) ? .backward : .forward
            }
        }
        self._updateViewControllers(viewController, mode: mode)
    }

}

extension QPageViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveGesture else { return false }
        guard let gestureRecognizerView = gestureRecognizer.view, let otherGestureRecognizerView = otherGestureRecognizer.view else { return false }
        return otherGestureRecognizerView.isDescendant(of: gestureRecognizerView)
    }

}
