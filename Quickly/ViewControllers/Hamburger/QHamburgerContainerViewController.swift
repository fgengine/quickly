//
//  Quickly
//

open class QHamburgerContainerViewController : QViewController, IQHamburgerContainerViewController {
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open var state: QHamburgerViewControllerState {
        set(value) { self.change(state: value, animated: false) }
        get { return self._state }
    }
    open var contentViewController: IQHamburgerViewController? {
        set(value) { self.change(contentViewController: value, animated: false) }
        get { return self._contentViewController }
    }
    open var leftViewController: IQHamburgerViewController? {
        set(value) { self.change(leftViewController: value, animated: false) }
        get { return self._leftViewController }
    }
    open var rightViewController: IQHamburgerViewController? {
        set(value) { self.change(rightViewController: value, animated: false) }
        get { return self._rightViewController }
    }
    open var animation: IQHamburgerViewControllerFixedAnimation
    open var interactiveAnimation: IQHamburgerViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var leftInteractivePresentGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self._handleLeftInteractivePresentGesture(_:)))
        gesture.delaysTouchesBegan = true
        gesture.edges = [ .left ]
        gesture.delegate = self
        return gesture
    }()
    public private(set) lazy var rightInteractivePresentGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self._handleRightInteractivePresentGesture(_:)))
        gesture.delaysTouchesBegan = true
        gesture.edges = [ .right ]
        gesture.delegate = self
        return gesture
    }()
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleInteractiveDismissGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private var _state: QHamburgerViewControllerState
    private var _contentViewController: IQHamburgerViewController?
    private var _leftViewController: IQHamburgerViewController?
    private var _rightViewController: IQHamburgerViewController?
    private var _activeInteractiveContentViewController: IQHamburgerViewController?
    private var _activeInteractiveLeftViewController: IQHamburgerViewController?
    private var _activeInteractiveRightViewController: IQHamburgerViewController?
    private var _activeInteractiveAnimation: IQHamburgerViewControllerInteractiveAnimation?

    public init(
        contentViewController: IQHamburgerViewController? = nil,
        leftViewController: IQHamburgerViewController? = nil,
        rightViewController: IQHamburgerViewController? = nil
    ) {
        self._state = .idle
        self._contentViewController = contentViewController
        self._leftViewController = leftViewController
        self._rightViewController = rightViewController
        self.animation = QHamburgerViewControllerAnimation()
        self.interactiveAnimation = QHamburgerViewControllerInteractiveAnimation()
        self.isAnimating = false
        super.init()
    }
    
    open override func setup() {
        super.setup()
        
        if let vc = self._contentViewController {
            self._add(childViewController: vc)
        }
        if let vc = self._leftViewController {
            self._add(childViewController: vc)
        }
        if let vc = self._rightViewController {
            self._add(childViewController: vc)
        }
    }
    
    open override func didLoad() {
        super.didLoad()
        
        self.view.addGestureRecognizer(self.leftInteractivePresentGesture)
        self.view.addGestureRecognizer(self.rightInteractivePresentGesture)
        self.view.addGestureRecognizer(self.interactiveDismissGesture)
        
        if let vc = self._contentViewController {
            self._appear(viewController: vc)
        }
        if let vc = self._leftViewController {
            self._appear(viewController: vc)
        }
        if let vc = self._rightViewController {
            self._appear(viewController: vc)
        }
        self._apply(state: self.state)
    }
    
    open override func layout(bounds: CGRect) {
        if self.isAnimating == false {
            self._apply(state: self.state)
        }
    }
    
    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self._contentViewController?.prepareInteractivePresent()
        self._leftViewController?.prepareInteractivePresent()
        self._rightViewController?.prepareInteractivePresent()
    }
    
    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self._contentViewController?.cancelInteractivePresent()
        self._leftViewController?.cancelInteractivePresent()
        self._rightViewController?.cancelInteractivePresent()
    }
    
    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self._contentViewController?.finishInteractivePresent()
        self._leftViewController?.finishInteractivePresent()
        self._rightViewController?.finishInteractivePresent()
    }
    
    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._contentViewController?.willPresent(animated: animated)
        self._leftViewController?.willPresent(animated: animated)
        self._rightViewController?.willPresent(animated: animated)
    }
    
    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self._contentViewController?.didPresent(animated: animated)
        self._leftViewController?.didPresent(animated: animated)
        self._rightViewController?.didPresent(animated: animated)
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self._contentViewController?.prepareInteractiveDismiss()
        self._leftViewController?.prepareInteractiveDismiss()
        self._rightViewController?.prepareInteractiveDismiss()
    }
    
    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self._contentViewController?.cancelInteractiveDismiss()
        self._leftViewController?.cancelInteractiveDismiss()
        self._rightViewController?.cancelInteractiveDismiss()
    }
    
    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self._contentViewController?.finishInteractiveDismiss()
        self._leftViewController?.finishInteractiveDismiss()
        self._rightViewController?.finishInteractiveDismiss()
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self._contentViewController?.willDismiss(animated: animated)
        self._leftViewController?.willDismiss(animated: animated)
        self._rightViewController?.willDismiss(animated: animated)
    }
    
    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._contentViewController?.didDismiss(animated: animated)
        self._leftViewController?.didDismiss(animated: animated)
        self._rightViewController?.didDismiss(animated: animated)
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self._contentViewController?.willTransition(size: size)
        self._leftViewController?.willTransition(size: size)
        self._rightViewController?.willTransition(size: size)
    }
    
    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self._contentViewController?.didTransition(size: size)
        self._leftViewController?.didTransition(size: size)
        self._rightViewController?.didTransition(size: size)
    }
    
    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        guard let vc = self._contentViewController else { return super.supportedOrientations() }
        return vc.supportedOrientations()
    }
    
    open override func preferedStatusBarHidden() -> Bool {
        guard let vc = self._contentViewController else { return super.preferedStatusBarHidden() }
        return vc.preferedStatusBarHidden()
    }
    
    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        guard let vc = self._contentViewController else { return super.preferedStatusBarStyle() }
        return vc.preferedStatusBarStyle()
    }
    
    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        guard let vc = self._contentViewController else { return super.preferedStatusBarAnimation() }
        return vc.preferedStatusBarAnimation()
    }
    
    public func change(contentViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._contentViewController !== contentViewController {
            if let vc = self._contentViewController {
                self._disappear(viewController: vc)
                self._remove(childViewController: vc)
            }
            self._contentViewController = contentViewController
            if let vc = self._contentViewController {
                self._add(childViewController: vc)
                self._appear(viewController: vc)
            }
            self._apply(state: self._state)
            completion?()
        } else {
            completion?()
        }
    }
    
    public func change(leftViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._leftViewController !== leftViewController {
            if animated == true && self._state == .left {
                self._change(currentState: self._state, availableState: .idle, animated: true, completion: { [weak self] in
                    guard let strong = self else { return }
                    if let vc = strong._leftViewController {
                        strong._disappear(viewController: vc)
                        strong._remove(childViewController: vc)
                    }
                    strong._leftViewController = leftViewController
                    if let vc = strong._leftViewController {
                        strong._add(childViewController: vc)
                        strong._appear(viewController: vc)
                    }
                    strong._change(currentState: .idle, availableState: strong._state, animated: true, completion: completion)
                })
            } else {
                if let vc = self._leftViewController {
                    self._disappear(viewController: vc)
                    self._remove(childViewController: vc)
                }
                self._leftViewController = leftViewController
                if let vc = self._leftViewController {
                    self._add(childViewController: vc)
                    self._appear(viewController: vc)
                }
                self._apply(state: self._state)
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    public func change(rightViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._rightViewController !== rightViewController {
            if animated == true && self._state == .right {
                self._change(currentState: self._state, availableState: .idle, animated: true, completion: { [weak self] in
                    guard let strong = self else { return }
                    if let vc = strong._rightViewController {
                        strong._disappear(viewController: vc)
                        strong._remove(childViewController: vc)
                    }
                    strong._rightViewController = rightViewController
                    if let vc = strong._rightViewController {
                        strong._add(childViewController: vc)
                        strong._appear(viewController: vc)
                    }
                    strong._change(currentState: .idle, availableState: strong._state, animated: true, completion: completion)
                })
            } else {
                if let vc = self._rightViewController {
                    self._disappear(viewController: vc)
                    self._remove(childViewController: vc)
                }
                self._rightViewController = rightViewController
                if let vc = self._rightViewController {
                    self._add(childViewController: vc)
                    self._appear(viewController: vc)
                }
                self._apply(state: self._state)
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    public func change(state: QHamburgerViewControllerState, animated: Bool, completion: (() -> Void)? = nil) {
        if self.state != state {
            let oldState = self._state
            self._state = state
            self._change(currentState: oldState, availableState: state, animated: animated, completion: completion)
        }
    }
    
}

// MARK: - Private -

extension QHamburgerContainerViewController {
    
    private func _apply(state: QHamburgerViewControllerState) {
        self.animation.layout(
            contentView: self.view,
            state: state,
            contentViewController: self._contentViewController,
            leftViewController: self._leftViewController,
            rightViewController: self._rightViewController
        )
    }
    
    private func _change(currentState: QHamburgerViewControllerState, availableState: QHamburgerViewControllerState, animated: Bool, completion: (() -> Void)?) {
        self.isAnimating = true
        self.animation.animate(
            contentView: self.view,
            currentState: currentState,
            availableState: availableState,
            contentViewController: self._contentViewController,
            leftViewController: self._leftViewController,
            rightViewController: self._rightViewController,
            animated: animated,
            complete: { [weak self] in
                guard let strong = self else { return }
                strong.isAnimating = false
                completion?()
            }
        )
    }
    
    private func _add(childViewController: IQHamburgerViewController) {
        childViewController.parent = self
    }
    
    private func _remove(childViewController: IQHamburgerViewController) {
        childViewController.parent = nil
    }
    
    private func _appear(viewController: IQHamburgerViewController) {
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
    }
    
    private func _disappear(viewController: IQHamburgerViewController) {
        if viewController.isLoaded == true {
            viewController.view.removeFromSuperview()
        }
    }
    
    @objc
    private func _handleLeftInteractivePresentGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let position = gesture.location(in: nil)
        let velocity = gesture.velocity(in: nil)
        switch gesture.state {
        case .began:
            guard let contentViewController = self._contentViewController, let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = contentViewController
            self._activeInteractiveLeftViewController = self._leftViewController
            self._activeInteractiveRightViewController = self._rightViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                currentState: self._state,
                availableState: .left,
                contentViewController: contentViewController,
                leftViewController: self._leftViewController,
                rightViewController: self._rightViewController,
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
                animation.finish({ [weak self] (state) in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            }
            break
        default:
            break
        }
    }
    
    @objc
    private func _handleRightInteractivePresentGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let position = gesture.location(in: nil)
        let velocity = gesture.velocity(in: nil)
        switch gesture.state {
        case .began:
            guard let contentViewController = self._contentViewController, let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = contentViewController
            self._activeInteractiveLeftViewController = self._leftViewController
            self._activeInteractiveRightViewController = self._rightViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                currentState: self._state,
                availableState: .right,
                contentViewController: contentViewController,
                leftViewController: self._leftViewController,
                rightViewController: self._rightViewController,
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
                animation.finish({ [weak self] (state) in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            }
            break
        default:
            break
        }
    }
    
    @objc
    private func _handleInteractiveDismissGesture(_ gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: nil)
        let velocity = gesture.velocity(in: nil)
        switch gesture.state {
        case .began:
            guard let contentViewController = self._contentViewController, let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = contentViewController
            self._activeInteractiveLeftViewController = self._leftViewController
            self._activeInteractiveRightViewController = self._rightViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                currentState: self._state,
                availableState: .idle,
                contentViewController: contentViewController,
                leftViewController: self._leftViewController,
                rightViewController: self._rightViewController,
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
                animation.finish({ [weak self] (state) in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] in
                    guard let strong = self else { return }
                    strong._endInteractiveAnimation()
                })
            }
            break
        default:
            break
        }
    }
    
    private func _endInteractiveAnimation() {
        self._activeInteractiveContentViewController = nil
        self._activeInteractiveLeftViewController = nil
        self._activeInteractiveRightViewController = nil
        self._activeInteractiveAnimation = nil
        self.isAnimating = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate -

extension QHamburgerContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let contentViewController = self._contentViewController else { return false }
        if gestureRecognizer == self.leftInteractivePresentGesture {
            guard self.leftViewController != nil, self._state == .idle else { return false }
            return contentViewController.shouldInteractive()
        } else if gestureRecognizer == self.rightInteractivePresentGesture {
            guard self.rightViewController != nil, self._state == .idle else { return false }
            return contentViewController.shouldInteractive()
        } else if gestureRecognizer == self.interactiveDismissGesture {
            guard self._state != .idle else { return false }
            let location = gestureRecognizer.location(in: contentViewController.view)
            return contentViewController.view.point(inside: location, with: nil)
        }
        return false
    }

}
