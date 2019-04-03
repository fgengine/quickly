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
        set(value) { self.changeState(value, animated: false) }
        get { return self._state }
    }
    open var contentViewController: IQHamburgerViewController {
        set(value) { self._change(contentViewController: value, animated: false) }
        get { return self._contentViewController }
    }
    open var leftViewController: IQHamburgerViewController? {
        set(value) { self._change(leftViewController: value, animated: false) }
        get { return self.leftViewController }
    }
    open var rightViewController: IQHamburgerViewController? {
        set(value) { self._change(rightViewController: value, animated: false) }
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
    private var _contentViewController: IQHamburgerViewController
    private var _leftViewController: IQHamburgerViewController?
    private var _rightViewController: IQHamburgerViewController?
    private var _activeInteractiveContentViewController: IQHamburgerViewController?
    private var _activeInteractiveLeftViewController: IQHamburgerViewController?
    private var _activeInteractiveRightViewController: IQHamburgerViewController?
    private var _activeInteractiveAnimation: IQHamburgerViewControllerInteractiveAnimation?

    public init(
        contentViewController: IQHamburgerViewController,
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
        
        self._add(childViewController: self._contentViewController)
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
        
        self._appear(viewController: self._contentViewController)
        if let vc = self._leftViewController {
            self._appear(viewController: vc)
        }
        if let vc = self._rightViewController {
            self._appear(viewController: vc)
        }
        self._apply(state: self.state, animated: false, completion: nil)
    }
    
    open override func layout(bounds: CGRect) {
        if self.isAnimating == false {
            self._apply(state: self.state, animated: false, completion: nil)
        }
    }
    
    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self._contentViewController.prepareInteractivePresent()
        self._leftViewController?.prepareInteractivePresent()
        self._rightViewController?.prepareInteractivePresent()
    }
    
    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self._contentViewController.cancelInteractivePresent()
        self._leftViewController?.cancelInteractivePresent()
        self._rightViewController?.cancelInteractivePresent()
    }
    
    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self._contentViewController.finishInteractivePresent()
        self._leftViewController?.finishInteractivePresent()
        self._rightViewController?.finishInteractivePresent()
    }
    
    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._contentViewController.willPresent(animated: animated)
        self._leftViewController?.willPresent(animated: animated)
        self._rightViewController?.willPresent(animated: animated)
    }
    
    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self._contentViewController.didPresent(animated: animated)
        self._leftViewController?.didPresent(animated: animated)
        self._rightViewController?.didPresent(animated: animated)
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self._contentViewController.prepareInteractiveDismiss()
        self._leftViewController?.prepareInteractiveDismiss()
        self._rightViewController?.prepareInteractiveDismiss()
    }
    
    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self._contentViewController.cancelInteractiveDismiss()
        self._leftViewController?.cancelInteractiveDismiss()
        self._rightViewController?.cancelInteractiveDismiss()
    }
    
    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self._contentViewController.finishInteractiveDismiss()
        self._leftViewController?.finishInteractiveDismiss()
        self._rightViewController?.finishInteractiveDismiss()
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self._contentViewController.willDismiss(animated: animated)
        self._leftViewController?.willDismiss(animated: animated)
        self._rightViewController?.willDismiss(animated: animated)
    }
    
    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._contentViewController.didDismiss(animated: animated)
        self._leftViewController?.didDismiss(animated: animated)
        self._rightViewController?.didDismiss(animated: animated)
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self._contentViewController.willTransition(size: size)
        self._leftViewController?.willTransition(size: size)
        self._rightViewController?.willTransition(size: size)
    }
    
    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self._contentViewController.didTransition(size: size)
        self._leftViewController?.didTransition(size: size)
        self._rightViewController?.didTransition(size: size)
    }
    
    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self._contentViewController.supportedOrientations()
    }
    
    open override func preferedStatusBarHidden() -> Bool {
        return self._contentViewController.preferedStatusBarHidden()
    }
    
    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self._contentViewController.preferedStatusBarStyle()
    }
    
    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self._contentViewController.preferedStatusBarAnimation()
    }
    
    public func change(contentViewController: IQHamburgerViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._contentViewController !== contentViewController {
            self._disappear(viewController: self._contentViewController)
            self._remove(childViewController: self._contentViewController)
            self._contentViewController = contentViewController
            self._add(childViewController: self._contentViewController)
            self._appear(viewController: self._contentViewController)
            self._apply(state: self._state, animated: false, completion: completion)
        } else {
            completion?()
        }
    }
    
    public func change(leftViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._leftViewController !== leftViewController {
            if animated == true && self._state == .left {
                self._apply(state: .idle, animated: true, completion: { [weak self] in
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
                    strong._apply(state: strong._state, animated: true, completion: completion)
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
                self._apply(state: self._state, animated: false, completion: completion)
            }
        } else {
            completion?()
        }
    }
    
    public func change(rightViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._rightViewController !== rightViewController {
            if animated == true && self._state == .right {
                self._apply(state: .idle, animated: true, completion: { [weak self] in
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
                    strong._apply(state: strong._state, animated: true, completion: completion)
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
                self._apply(state: self._state, animated: false, completion: completion)
            }
        } else {
            completion?()
        }
    }
    
    public func changeState(_ state: QHamburgerViewControllerState, animated: Bool, completion: (() -> Void)? = nil) {
        if self.state != state {
            self._state = state
            self._apply(state: state, animated: animated, completion: completion)
        }
    }
    
}

// MARK: - Private -

extension QHamburgerContainerViewController {
    
    private func _apply(state: QHamburgerViewControllerState, animated: Bool, completion: (() -> Void)?) {
        self.isAnimating = true
        self.animation.prepare(
            contentView: self.view,
            state: self.state,
            contentViewController: self._contentViewController,
            leftViewController: self._leftViewController,
            rightViewController: self._rightViewController
        )
        self.animation.update(animated: false, complete: { [weak self] (completed: Bool) in
            guard let strong = self else { return }
            strong.isAnimating = false
        })
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
            guard let leftViewController = self._leftViewController, let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = self._contentViewController
            self._activeInteractiveLeftViewController = leftViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                currentState: self._state,
                availableState: .left,
                contentViewController: self._contentViewController,
                leftViewController: leftViewController,
                rightViewController: nil,
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
                    strong._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] (completed: Bool) in
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
            guard let rightViewController = self._rightViewController, let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = self._contentViewController
            self._activeInteractiveRightViewController = rightViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                currentState: self._state,
                availableState: .right,
                contentViewController: self._contentViewController,
                leftViewController: nil,
                rightViewController: rightViewController,
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
                    strong._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] (completed: Bool) in
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
    private func _handleInteractiveDismissGesture(_ sender: Any) {
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
        if gestureRecognizer == self.leftInteractivePresentGesture {
            guard self.leftViewController != nil, self._state == .idle else { return false }
            return self.contentViewController.shouldInteractive()
        } else if gestureRecognizer == self.rightInteractivePresentGesture {
            guard self.rightViewController != nil, self._state == .idle else { return false }
            return self.contentViewController.shouldInteractive()
        } else if gestureRecognizer == self.interactiveDismissGesture {
            guard self._state != .idle else { return false }
            let location = gestureRecognizer.location(in: self.contentViewController.view)
            return self.contentViewController.view.point(inside: location, with: nil)
        }
        return false
    }

}
