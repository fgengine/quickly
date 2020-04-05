//
//  Quickly
//

open class QJalousieContainerViewController : QViewController, IQJalousieContainerViewController {

    open var state: QJalousieViewControllerState {
        set(value) { self.change(state: value, animated: false) }
        get { return self._state }
    }
    open var contentViewController: IQJalousieViewController? {
        set(value) { self.change(contentViewController: value, animated: false) }
        get { return self._contentViewController }
    }
    open var detailViewController: IQJalousieViewController? {
        set(value) { self.change(detailViewController: value, animated: false) }
        get { return self._detailViewController }
    }
    open var animation: IQJalousieViewControllerFixedAnimation
    open var interactiveAnimation: IQJalousieViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleInteractiveGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private var _state: QJalousieViewControllerState
    private var _contentViewController: IQJalousieViewController?
    private var _detailViewController: IQJalousieViewController?
    private var _activeInteractiveContentViewController: IQJalousieViewController?
    private var _activeInteractiveDetailViewController: IQJalousieViewController?
    private var _activeInteractiveAnimation: IQJalousieViewControllerInteractiveAnimation?

    public init(
        state: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController? = nil,
        detailViewController: IQJalousieViewController? = nil,
        animation: IQJalousieViewControllerFixedAnimation = QJalousieViewControllerAnimation(),
        interactiveAnimation: IQJalousieViewControllerInteractiveAnimation = QJalousieViewControllerInteractiveAnimation()
    ) {
        self._state = state
        self._contentViewController = contentViewController
        self._detailViewController = detailViewController
        self.animation = animation
        self.interactiveAnimation = interactiveAnimation
        self.isAnimating = false
        super.init()
    }
    
    deinit {
        if let vc = self._detailViewController {
            self._disappear(viewController: vc)
        }
        if let vc = self._contentViewController {
            self._disappear(viewController: vc)
        }
    }
    
    open override func setup() {
        super.setup()
        
        if let vc = self._contentViewController {
            self._add(childViewController: vc)
        }
        if let vc = self._detailViewController {
            self._add(childViewController: vc)
        }
    }
    
    open override func didLoad() {
        super.didLoad()
        
        self.view.addGestureRecognizer(self.interactiveGesture)
        
        if let vc = self._contentViewController {
            self._appear(viewController: vc)
            vc.willPresent(animated: false)
            vc.didPresent(animated: false)
        }
        if let vc = self._detailViewController {
            self._appear(viewController: vc)
            if self.state != .closed {
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
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
        if self.state != .closed {
            self._detailViewController?.prepareInteractivePresent()
        }
    }
    
    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self._contentViewController?.cancelInteractivePresent()
        if self.state != .closed {
            self._detailViewController?.cancelInteractivePresent()
        }
    }
    
    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self._contentViewController?.finishInteractivePresent()
        if self.state != .closed {
            self._detailViewController?.finishInteractivePresent()
        }
    }
    
    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._contentViewController?.willPresent(animated: animated)
        if self.state != .closed {
            self._detailViewController?.willPresent(animated: animated)
        }
    }
    
    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self._contentViewController?.didPresent(animated: animated)
        if self.state != .closed {
            self._detailViewController?.didPresent(animated: animated)
        }
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self._contentViewController?.prepareInteractiveDismiss()
        if self.state != .closed {
            self._detailViewController?.prepareInteractiveDismiss()
        }
    }
    
    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self._contentViewController?.cancelInteractiveDismiss()
        if self.state != .closed {
            self._detailViewController?.cancelInteractiveDismiss()
        }
    }
    
    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self._contentViewController?.finishInteractiveDismiss()
        if self.state != .closed {
            self._detailViewController?.cancelInteractiveDismiss()
        }
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self._contentViewController?.willDismiss(animated: animated)
        if self.state != .closed {
            self._detailViewController?.willDismiss(animated: animated)
        }
    }
    
    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._contentViewController?.didDismiss(animated: animated)
        if self.state != .closed {
            self._detailViewController?.didDismiss(animated: animated)
        }
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self._contentViewController?.willTransition(size: size)
        if self.state != .closed {
            self._detailViewController?.willTransition(size: size)
        }
    }
    
    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self._contentViewController?.didTransition(size: size)
        if self.state != .closed {
            self._detailViewController?.didTransition(size: size)
        }
    }
    
    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        guard let contentViewController = self._contentViewController else { return super.supportedOrientations() }
        return contentViewController.supportedOrientations()
    }
    
    open override func preferedStatusBarHidden() -> Bool {
        guard let contentViewController = self._contentViewController else { return super.preferedStatusBarHidden() }
        return contentViewController.preferedStatusBarHidden()
    }
    
    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        guard let contentViewController = self._contentViewController else { return super.preferedStatusBarStyle() }
        return contentViewController.preferedStatusBarStyle()
    }
    
    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        guard let contentViewController = self._contentViewController else { return super.preferedStatusBarAnimation() }
        return contentViewController.preferedStatusBarAnimation()
    }
    
    public func change(contentViewController: IQJalousieViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._contentViewController !== contentViewController {
            if let vc = self._contentViewController {
                if self.isLoaded == true {
                    self._disappear(viewController: vc)
                }
                self._remove(childViewController: vc)
            }
            self._contentViewController = contentViewController
            if let vc = self._contentViewController {
                self._add(childViewController: vc)
                if self.isLoaded == true {
                    self._appear(viewController: vc)
                }
            }
            completion?()
        } else {
            completion?()
        }
    }
    
    public func change(detailViewController: IQJalousieViewController?, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self._detailViewController !== detailViewController {
            if animated == true && self._state != .closed {
                self._change(currentState: self._state, availableState: .closed, animated: true, completion: { [weak self] in
                    guard let self = self else { return }
                    if let vc = self._detailViewController {
                        if self.isLoaded == true {
                            self._disappear(viewController: vc)
                        }
                        self._remove(childViewController: vc)
                    }
                    self._detailViewController = detailViewController
                    if let vc = self._detailViewController {
                        self._add(childViewController: vc)
                        if self.isLoaded == true {
                            self._appear(viewController: vc)
                        }
                    }
                    self._change(currentState: .closed, availableState: self._state, animated: true, completion: completion)
                })
            } else {
                if let vc = self._detailViewController {
                    if self.isLoaded == true {
                        self._disappear(viewController: vc)
                    }
                    self._remove(childViewController: vc)
                }
                self._detailViewController = detailViewController
                if let vc = self._detailViewController {
                    self._add(childViewController: vc)
                    if self.isLoaded == true {
                        self._appear(viewController: vc)
                    }
                }
                self._apply(state: self._state)
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    public func change(state: QJalousieViewControllerState, animated: Bool, completion: (() -> Void)? = nil) {
        if self.state != state {
            let oldState = self._state
            self._state = state
            self._change(currentState: oldState, availableState: state, animated: animated, completion: completion)
        }
    }
    
    // MARK: IQContentViewController
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get { return self.view.bounds.size }
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
    
    // MARK: IQModalContentViewController
    
    open func modalShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQHamburgerContentViewController
    
    open func hamburgerShouldInteractive() -> Bool {
        return true
    }
    
}

// MARK: Private

private extension QJalousieContainerViewController {
    
    func _apply(state: QJalousieViewControllerState) {
        self.animation.layout(
            contentView: self.view,
            state: state,
            contentViewController: self._contentViewController,
            detailViewController: self._detailViewController
        )
    }
    
    func _change(currentState: QJalousieViewControllerState, availableState: QJalousieViewControllerState, animated: Bool, completion: (() -> Void)?) {
        self.isAnimating = true
        self.animation.animate(
            contentView: self.view,
            currentState: currentState,
            targetState: availableState,
            contentViewController: self._contentViewController,
            detailViewController: self._detailViewController,
            animated: animated,
            complete: { [weak self] in
                if let self = self {
                    self.isAnimating = false
                }
                completion?()
            }
        )
    }
    
    func _add(childViewController: IQJalousieViewController) {
        childViewController.parentViewController = self
    }
    
    func _remove(childViewController: IQJalousieViewController) {
        childViewController.parentViewController = nil
    }
    
    func _appear(viewController: IQJalousieViewController) {
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
    }
    
    func _disappear(viewController: IQJalousieViewController) {
        if viewController.isLoaded == true {
            viewController.view.removeFromSuperview()
        }
    }
    
    @objc
    func _handleInteractiveGesture(_ gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: nil)
        let velocity = gesture.velocity(in: nil)
        switch gesture.state {
        case .began:
            guard let animation = self.interactiveAnimation else { return }
            self._activeInteractiveContentViewController = self._contentViewController
            self._activeInteractiveDetailViewController = self._detailViewController
            self._activeInteractiveAnimation = animation
            self.isAnimating = true
            animation.prepare(
                contentView: self.view,
                state: self._state,
                contentViewController: contentViewController,
                detailViewController: self._detailViewController,
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
                    guard let self = self else { return }
                    self._state = state
                    self._endInteractiveAnimation()
                })
            } else {
                animation.cancel({ [weak self] (state) in
                    guard let self = self else { return }
                    self._state = state
                    self._endInteractiveAnimation()
                })
            }
            break
        default:
            break
        }
    }
    
    func _endInteractiveAnimation() {
        self._activeInteractiveContentViewController = nil
        self._activeInteractiveDetailViewController = nil
        self._activeInteractiveAnimation = nil
        self.isAnimating = false
    }
    
}

// MARK: UIGestureRecognizerDelegate

extension QJalousieContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let detailViewController = self._detailViewController else { return false }
        if gestureRecognizer == self.interactiveGesture {
            if self._state != .closed {
                let location = gestureRecognizer.location(in: detailViewController.view)
                return detailViewController.view.point(inside: location, with: nil)
            }
        }
        return false
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactiveGesture {
            return true
        }
        return false
    }
    
}
