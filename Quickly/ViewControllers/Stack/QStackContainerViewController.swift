//
//  Quickly
//

open class QStackContainerViewController : QViewController, IQStackContainerViewController, IQModalContentViewController, IQHamburgerContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get { return CGSize.zero }
    }
    open var viewControllers: [IQStackViewController] {
        set(value) { self.set(viewControllers: value, animated: false, completion: nil) }
        get { return self._viewControllers }
    }
    open var rootViewController: IQStackViewController? {
        get { return self._viewControllers.first }
    }
    open var currentViewController: IQStackViewController? {
        get { return self._viewControllers.last }
    }
    open var previousViewController: IQStackViewController? {
        get {
            guard self._viewControllers.count > 1 else { return nil }
            return self._viewControllers[self._viewControllers.endIndex - 2]
        }
    }
    open var presentAnimation: IQStackViewControllerPresentAnimation
    open var dismissAnimation: IQStackViewControllerDismissAnimation
    open var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?
    open var hidesGroupbarWhenPushed: Bool
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self._handleInteractiveDismissGesture(_:)))
        gesture.delaysTouchesBegan = true
        gesture.edges = [ .left ]
        gesture.delegate = self
        return gesture
    }()
    
    private var _viewControllers: [IQStackViewController]
    private var _activeInteractiveCurrentViewController: IQStackViewController?
    private var _activeInteractivePreviousViewController: IQStackViewController?
    private var _activeInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?

    public init(
        viewControllers: [IQStackViewController] = [],
        presentAnimation: IQStackViewControllerPresentAnimation = QStackViewControllerPresentAnimation(),
        dismissAnimation: IQStackViewControllerDismissAnimation = QStackViewControllerDismissAnimation(),
        interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? = QStackViewControllerinteractiveDismissAnimation()
    ) {
        self._viewControllers = viewControllers
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.interactiveDismissAnimation = interactiveDismissAnimation
        self.hidesGroupbarWhenPushed = false
        self.isAnimating = false
        super.init()
        viewControllers.forEach({
            self._add(childViewController: $0)
        })
    }

    open override func didLoad() {
        self.view.addGestureRecognizer(self.interactiveDismissGesture)

        if let vc = self.currentViewController {
            self._present(viewController: vc, animated: false, completion: nil)
        }
    }

    open override func layout(bounds: CGRect) {
        guard self.isAnimating == false else {
            return
        }
        if let vc = self.currentViewController {
            vc.view.frame = bounds
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
    
    open func set(viewControllers: [IQStackViewController], animated: Bool, completion: (() -> Swift.Void)?) {
        if self.isLoaded == true {
            self._viewControllers.forEach({
                self._disappear(viewController: $0)
                self._remove(childViewController: $0)
            })
            self._viewControllers = viewControllers
            self._viewControllers.forEach({
                self._add(childViewController: $0)
            })
            if let vc = self.currentViewController {
                self._present(viewController: vc, animated: false, completion: completion)
            } else {
                completion?()
            }
        } else {
            self._viewControllers.forEach({
                self._remove(childViewController: $0)
            })
            self._viewControllers = viewControllers
            self._viewControllers.forEach({
                self._add(childViewController: $0)
            })
            completion?()
        }
    }

    open func push(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self._viewControllers.append(viewController)
        self._add(childViewController: viewController)
        self._present(viewController: viewController, animated: animated, completion: completion)
    }

    open func push(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        let stackViewController = QStackViewController(viewController: viewController)
        self.push(viewController: stackViewController, animated: animated, completion: completion)
    }
    
    open func replace(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        let currentViewController = self.currentViewController
        self.push(viewController: viewController, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            if let currentViewController = currentViewController {
                self.pop(viewController: currentViewController, animated: false)
            }
        })
    }
    
    open func replace(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        let stackViewController = QStackViewController(viewController: viewController)
        self.replace(viewController: stackViewController, animated: animated, completion: completion)
    }

    open func pop(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self._dismiss(viewController: viewController, animated: animated, completion: completion)
    }

    open func pop(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let stackViewController = viewController.stackViewController else { return }
        self.pop(viewController: stackViewController, animated: animated, completion: completion)
    }

    open func popTo(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        if self.currentViewController === viewController {
            completion?()
            return
        }
        if self.previousViewController === viewController {
            self._dismiss(viewController: self.currentViewController!, animated: animated, completion: completion)
        } else if self._viewControllers.count > 2 {
            if let index = self._viewControllers.firstIndex(where: { return $0 === viewController }) {
                let startIndex = self._viewControllers.index(index, offsetBy: 1)
                let endIndex = self._viewControllers.index(self._viewControllers.endIndex, offsetBy: -1)
                if endIndex - startIndex > 0 {
                    let hiddenViewControllers = self._viewControllers[startIndex..<endIndex]
                    hiddenViewControllers.forEach({ (hiddenViewController) in
                        self._dismiss(viewController: hiddenViewController, animated: false, completion: nil)
                    })
                }
                self._dismiss(viewController: self.currentViewController!, animated: animated, completion: completion)
            }
        }
    }

    open func popTo(viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let stackPageViewController = viewController.stackViewController else { return }
        self.popTo(viewController: stackPageViewController, animated: animated, completion: completion)
    }
    
}

// MARK: - Private -

extension QStackContainerViewController {

    private func _present(viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        if self.isLoaded == true {
            if let previousViewController = self.previousViewController {
                self._appear(viewController: viewController)
                self.setNeedUpdateStatusBar()
                self.isAnimating = true
                let presentAnimation = self._presentAnimation(viewController: viewController)
                presentAnimation.animate(
                    containerViewController: self,
                    contentView: self.view,
                    currentViewController: previousViewController,
                    currentGroupbarVisibility: self._groupbarVisibility(viewController: previousViewController),
                    nextViewController: viewController,
                    nextGroupbarVisibility: self._groupbarVisibility(viewController: viewController),
                    animated: animated,
                    complete: { [weak self] in
                        if let self = self {
                            self._disappear(viewController: previousViewController)
                            self.isAnimating = false
                        }
                        completion?()
                    }
                )
            } else {
                self._appear(viewController: viewController)
                self.setNeedUpdateStatusBar()
                completion?()
            }
        } else {
            completion?()
        }
    }

    private func _dismiss(viewController: IQStackViewController, animated: Bool, completion: (() -> Void)?) {
        if let index = self._viewControllers.firstIndex(where: { return $0 === viewController }) {
            let currentViewController = self.currentViewController
            let previousViewController = self.previousViewController
            self._viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateStatusBar()
                if currentViewController === viewController, let previousViewController = previousViewController {
                    if self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    self._appear(viewController: previousViewController)
                    self.isAnimating = true
                    let dismissAnimation = self._dismissAnimation(viewController: previousViewController)
                    dismissAnimation.animate(
                        containerViewController: self,
                        contentView: self.view,
                        currentViewController: viewController,
                        currentGroupbarVisibility: self._groupbarVisibility(viewController: viewController),
                        previousViewController: previousViewController,
                        previousGroupbarVisibility: self._groupbarVisibility(viewController: previousViewController),
                        animated: animated,
                        complete: { [weak self] in
                            if let self = self {
                                self._disappear(viewController: viewController)
                                self._remove(childViewController: viewController)
                                self.isAnimating = false
                            }
                            completion?()
                        }
                    )
                } else {
                    self._disappear(viewController: viewController)
                    self._remove(childViewController: viewController)
                    completion?()
                }
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    private func _add(childViewController: IQStackViewController) {
        childViewController.parentViewController = self
    }
    
    private func _remove(childViewController: IQStackViewController) {
        childViewController.parentViewController = nil
    }

    private func _appear(viewController: IQStackViewController) {
        viewController.view.bounds = self.view.bounds
        self.view.addSubview(viewController.view)
    }

    private func _disappear(viewController: IQStackViewController) {
        viewController.view.removeFromSuperview()
    }
    
    private func _groupbarVisibility(viewController: IQStackViewController) -> CGFloat {
        if self.hidesGroupbarWhenPushed == true {
            return self._viewControllers.first === viewController ? 1 : 0
        }
        return 1
    }

    private func _presentAnimation(viewController: IQStackViewController) -> IQStackViewControllerPresentAnimation {
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    private func _dismissAnimation(viewController: IQStackViewController) -> IQStackViewControllerDismissAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _interactiveDismissAnimation(viewController: IQStackViewController) -> IQStackViewControllerInteractiveDismissAnimation? {
        if let animation = viewController.interactiveDismissAnimation { return animation }
        return self.interactiveDismissAnimation
    }

    @objc
    private func _handleInteractiveDismissGesture(_ sender: Any) {
        let position = self.interactiveDismissGesture.location(in: nil)
        let velocity = self.interactiveDismissGesture.velocity(in: nil)
        switch self.interactiveDismissGesture.state {
        case .began:
            guard
                let currentViewController = self.currentViewController,
                let previousViewController = self.previousViewController,
                let dismissAnimation = self._interactiveDismissAnimation(viewController: currentViewController)
                else { return }
            self._activeInteractiveCurrentViewController = currentViewController
            self._activeInteractivePreviousViewController = previousViewController
            self._activeInteractiveDismissAnimation = dismissAnimation
            self._appear(viewController: previousViewController)
            self.isAnimating = true
            dismissAnimation.prepare(
                containerViewController: self,
                contentView: self.view,
                currentViewController: currentViewController,
                currentGroupbarVisibility: self._groupbarVisibility(viewController: currentViewController),
                previousViewController: previousViewController,
                previousGroupbarVisibility: self._groupbarVisibility(viewController: previousViewController),
                position: position,
                velocity: velocity
            )
            break
        case .changed:
            guard let dismissAnimation = self._activeInteractiveDismissAnimation else { return }
            dismissAnimation.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard let dismissAnimation = self._activeInteractiveDismissAnimation else { return }
            if dismissAnimation.canFinish == true {
                dismissAnimation.finish({ [weak self] (completed: Bool) in
                    guard let self = self else { return }
                    self._finishInteractiveDismiss()
                })
            } else {
                dismissAnimation.cancel({ [weak self] (completed: Bool) in
                    guard let self = self else { return }
                    self._cancelInteractiveDismiss()
                })
            }
            break
        default:
            break
        }
    }

    private func _finishInteractiveDismiss() {
        if let vc = self._activeInteractiveCurrentViewController {
            if let index = self._viewControllers.firstIndex(where: { return $0 === vc }) {
                self._viewControllers.remove(at: index)
            }
            self._disappear(viewController: vc)
        }
        self.setNeedUpdateStatusBar()
        self._endInteractiveDismiss()
    }

    private func _cancelInteractiveDismiss() {
        if let vc = self._activeInteractivePreviousViewController {
            self._disappear(viewController: vc)
        }
        self._endInteractiveDismiss()
    }

    private func _endInteractiveDismiss() {
        self._activeInteractiveCurrentViewController = nil
        self._activeInteractivePreviousViewController = nil
        self._activeInteractiveDismissAnimation = nil
        self.isAnimating = false
    }

}

// MARK: - UIGestureRecognizerDelegate -

extension QStackContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        guard self._viewControllers.count > 1 else { return false }
        return true
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        guard let gestureRecognizerView = gestureRecognizer.view, let otherGestureRecognizerView = otherGestureRecognizer.view else { return false }
        return otherGestureRecognizerView.isDescendant(of: gestureRecognizerView)
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        let location = touch.location(in: self.view)
        return self.view.point(inside: location, with: nil)
    }

}
