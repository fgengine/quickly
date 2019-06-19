//
//  Quickly
//

open class QModalContainerViewController : QViewController, IQModalContainerViewController {

    open private(set) var viewControllers: [IQModalViewController]
    open var currentViewController: IQModalViewController? {
        get { return self.viewControllers.last }
    }
    open var previousViewController: IQModalViewController? {
        get {
            guard self.viewControllers.count > 1 else { return nil }
            return self.viewControllers[self.viewControllers.endIndex - 2]
        }
    }
    open var presentAnimation: IQModalViewControllerFixedAnimation
    open var dismissAnimation: IQModalViewControllerFixedAnimation
    open var interactiveDismissAnimation: IQModalViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleInteractiveDismissGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private var _deferredViewControllers: [(Bool, IQModalViewController, Bool, (() -> Void)?)]
    private var _activeInteractiveCurrentViewController: IQModalViewController?
    private var _activeInteractivePreviousViewController: IQModalViewController?
    private var _activeInteractiveDismissAnimation: IQModalViewControllerInteractiveAnimation?

    public override init() {
        self.viewControllers = []
        self.presentAnimation = QModalViewControllerPresentAnimation()
        self.dismissAnimation = QModalViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QModalViewControllerInteractiveDismissAnimation()
        self.isAnimating = false
        self._deferredViewControllers = []
        super.init()
    }

    open override func didLoad() {
        super.didLoad()

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

    open func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isLoaded == true {
            if self.isAnimating == true {
                self._deferredViewControllers.append((true, viewController, animated, completion))
            } else {
                self._present(viewController: viewController, animated: animated, completion: completion)
            }
        } else {
            self.viewControllers.append(viewController)
            self._add(childViewController: viewController)
            completion?()
        }
    }

    open func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isAnimating == true {
            self._deferredViewControllers.append((false, viewController, animated, completion))
        } else {
            self._dismiss(viewController: viewController, animated: animated, completion: completion)
        }
    }
    
}

// MARK: - Private -

extension QModalContainerViewController {

    private func _present(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.viewControllers.contains(where: { return $0 === viewController }) == false {
            self.viewControllers.append(viewController)
            self._add(childViewController: viewController)
        }
        self.isAnimating = true
        self._appear(viewController: viewController)
        self.setNeedUpdateStatusBar()
        let presentAnimation = self._presentAnimation(viewController: viewController)
        presentAnimation.animate(
            contentView: self.view,
            previousViewController: self.previousViewController,
            currentViewController: viewController,
            animated: animated,
            complete: { [weak self] in
                if let self = self {
                    self.isAnimating = false
                    self._processDeferred()
                }
                completion?()
            }
        )
    }

    private func _dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.firstIndex(where: { return $0 === viewController }) {
            var targetViewController: IQModalViewController?
            if index > self.viewControllers.startIndex {
                targetViewController = self.viewControllers[index - 1]
            }
            self.isAnimating = true
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
            if self.isLoaded == true {
                if currentViewController === viewController {
                    if self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    self._dismiss(targetViewController, viewController, animated: animated, completion: completion)
                } else {
                    self._dismiss(targetViewController, viewController, animated: false, completion: completion)
                }
            } else {
                self.isAnimating = false
                self._processDeferred()
                completion?()
            }
        } else {
            self._processDeferred()
            completion?()
        }
    }

    private func _dismiss(_ previousViewController: IQModalViewController?, _ currentViewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        let dismissAnimation = self._dismissAnimation(viewController: currentViewController)
        dismissAnimation.animate(
            contentView: self.view,
            previousViewController: previousViewController,
            currentViewController: currentViewController,
            animated: animated,
            complete: { [weak self] in
                if let self = self {
                    self._disappear(viewController: currentViewController)
                    self._remove(childViewController: currentViewController)
                    self.isAnimating = false
                    self._processDeferred()
                }
                completion?()
            }
        )
    }

    private func _processDeferred() {
        if self._deferredViewControllers.count > 0 {
            let deferred = self._deferredViewControllers.remove(at: 0)
            if deferred.0 == true {
                self._present(viewController: deferred.1, animated: deferred.2, completion: deferred.3)
            } else {
                self._dismiss(viewController: deferred.1, animated: deferred.2, completion: deferred.3)
            }
        }
    }
    
    private func _add(childViewController: IQModalViewController) {
        childViewController.parentViewController = self
    }
    
    private func _remove(childViewController: IQModalViewController) {
        childViewController.parentViewController = nil
    }

    private func _appear(viewController: IQModalViewController) {
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
    }

    private func _disappear(viewController: IQModalViewController) {
        viewController.view.removeFromSuperview()
    }

    private func _presentAnimation(viewController: IQModalViewController) -> IQModalViewControllerFixedAnimation {
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    private func _dismissAnimation(viewController: IQModalViewController) -> IQModalViewControllerFixedAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _interactiveDismissAnimation(viewController: IQModalViewController) -> IQModalViewControllerInteractiveAnimation? {
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
                let viewController = self.currentViewController,
                let dismissAnimation = self._interactiveDismissAnimation(viewController: viewController)
                else { return }
            self._activeInteractiveCurrentViewController = viewController
            self._activeInteractivePreviousViewController = self.previousViewController
            self._activeInteractiveDismissAnimation = dismissAnimation
            dismissAnimation.prepare(
                contentView: self.view,
                previousViewController: self.previousViewController,
                currentViewController: viewController,
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
        guard let currentViewController = self._activeInteractiveCurrentViewController else {
            self._endInteractiveDismiss()
            return
        }
        self._disappear(viewController: currentViewController)
        if let index = self.viewControllers.firstIndex(where: { return $0 === currentViewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
        }
        self._endInteractiveDismiss()
    }

    private func _cancelInteractiveDismiss() {
        self._endInteractiveDismiss()
    }

    private func _endInteractiveDismiss() {
        self._activeInteractiveCurrentViewController = nil
        self._activeInteractivePreviousViewController = nil
        self._activeInteractiveDismissAnimation = nil
    }

}

// MARK: - UIGestureRecognizerDelegate -

extension QModalContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewController = self.currentViewController else {
            return false
        }
        let location = gestureRecognizer.location(in: viewController.viewController.view)
        return viewController.viewController.view.point(inside: location, with: nil)
    }

}
