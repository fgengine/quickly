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
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = self._prepareInteractiveDismissGesture()
    private var deferredViewControllers: [(Bool, IQModalViewController, Bool, (() -> Void)?)]
    private var activeInteractiveCurrentViewController: IQModalViewController?
    private var activeInteractivePreviousViewController: IQModalViewController?
    private var activeInteractiveDismissAnimation: IQModalViewControllerInteractiveAnimation?

    public override init() {
        self.viewControllers = []
        self.presentAnimation = QModalViewControllerPresentAnimation()
        self.dismissAnimation = QModalViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QModalViewControllerInteractiveDismissAnimation()
        self.isAnimating = false
        self.deferredViewControllers = []
        super.init()
    }

    open override func didLoad() {
        super.didLoad()

        self.view.addGestureRecognizer(self.interactiveDismissGesture)

        if let vc = self.currentViewController {
            self._present(vc, animated: false, completion: nil)
        }
    }

    open override func layout(bounds: CGRect) {
        guard self.isAnimating == true else {
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

    open func presentModal(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isLoaded == true {
            if self.isAnimating == true {
                self.deferredViewControllers.append((true, viewController, animated, completion))
            } else {
                self._present(viewController, animated: animated, completion: completion)
            }
        } else {
            self.viewControllers.append(viewController)
            completion?()
        }
    }

    open func dismissModal(viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isAnimating == true {
            self.deferredViewControllers.append((false, viewController, animated, completion))
        } else {
            self._dismiss(viewController, animated: animated, completion: completion)
        }
    }

    private func _present(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        if self.viewControllers.contains(where: { return $0 === viewController }) == false {
            self.viewControllers.append(viewController)
        }
        self.isAnimating = true
        self._appearViewController(viewController)
        self.setNeedUpdateStatusBar()
        let presentAnimation = self._preparePresentAnimation(viewController)
        presentAnimation.prepare(
            contentView: self.view,
            previousViewController: self.previousViewController,
            currentViewController: viewController
        )
        presentAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
            if let strong = self {
                strong.isAnimating = false
                strong._processDeferred()
            }
            completion?()
        })
    }

    private func _dismiss(_ viewController: IQModalViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
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
        let dismissAnimation = self._prepareDismissAnimation(currentViewController)
        dismissAnimation.prepare(
            contentView: self.view,
            previousViewController: previousViewController,
            currentViewController: currentViewController
        )
        dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
            if let strong = self {
                strong._disappearViewController(currentViewController)
                strong.isAnimating = false
                strong._processDeferred()
            }
            completion?()
        })
    }

    private func _processDeferred() {
        if self.deferredViewControllers.count > 0 {
            let deferred = self.deferredViewControllers.remove(at: 0)
            if deferred.0 == true {
                self._present(deferred.1, animated: deferred.2, completion: deferred.3)
            } else {
                self._dismiss(deferred.1, animated: deferred.2, completion: deferred.3)
            }
        }
    }

    private func _appearViewController(_ viewController: IQModalViewController) {
        viewController.parent = self
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
    }

    private func _disappearViewController(_ viewController: IQModalViewController) {
        viewController.view.removeFromSuperview()
        viewController.parent = nil
    }

    private func _preparePresentAnimation(_ viewController: IQModalViewController) -> IQModalViewControllerFixedAnimation {
        if let animation = viewController.modalPresentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQModalViewController) -> IQModalViewControllerFixedAnimation {
        if let animation = viewController.modalDismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQModalViewController) -> IQModalViewControllerInteractiveAnimation? {
        if let animation = viewController.modalInteractiveDismissAnimation { return animation }
        return self.interactiveDismissAnimation
    }

    private func _prepareInteractiveDismissGesture() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._interactiveDismissGestureHandler(_:)))
        gesture.delegate = self
        return gesture
    }

    @objc
    private func _interactiveDismissGestureHandler(_ sender: Any) {
        let position = self.interactiveDismissGesture.location(in: nil)
        let velocity = self.interactiveDismissGesture.velocity(in: nil)
        switch self.interactiveDismissGesture.state {
        case .began:
            guard
                let viewController = self.currentViewController,
                let dismissAnimation = self._prepareinteractiveDismissAnimation(viewController)
                else { return }
            self.activeInteractiveCurrentViewController = viewController
            self.activeInteractivePreviousViewController = self.previousViewController
            self.activeInteractiveDismissAnimation = dismissAnimation
            dismissAnimation.prepare(
                contentView: self.view,
                previousViewController: self.previousViewController,
                currentViewController: viewController,
                position: position,
                velocity: velocity
            )
            break
        case .changed:
            guard let dismissAnimation = self.activeInteractiveDismissAnimation else { return }
            dismissAnimation.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard let dismissAnimation = self.activeInteractiveDismissAnimation else { return }
            if dismissAnimation.canFinish == true {
                dismissAnimation.finish({ [weak self] (completed: Bool) in
                    guard let strong = self else { return }
                    strong._finishInteractiveDismiss()
                })
            } else {
                dismissAnimation.cancel({ [weak self] (completed: Bool) in
                    guard let strong = self else { return }
                    strong._cancelInteractiveDismiss()
                })
            }
            break
        default:
            break
        }
    }

    private func _finishInteractiveDismiss() {
        guard let currentViewController = self.activeInteractiveCurrentViewController else {
            self._endInteractiveDismiss()
            return
        }
        self._disappearViewController(currentViewController)
        if let index = self.viewControllers.index(where: { return $0 === currentViewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
        }
        self._endInteractiveDismiss()
    }

    private func _cancelInteractiveDismiss() {
        self._endInteractiveDismiss()
    }

    private func _endInteractiveDismiss() {
        self.activeInteractiveCurrentViewController = nil
        self.activeInteractivePreviousViewController = nil
        self.activeInteractiveDismissAnimation = nil
    }

}

extension QModalContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewController = self.currentViewController else {
            return false
        }
        let location = gestureRecognizer.location(in: viewController.modalContentViewController.view)
        return viewController.modalContentViewController.view.point(inside: location, with: nil)
    }

}
