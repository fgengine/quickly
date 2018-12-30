//
//  Quickly
//

open class QPushContainerViewController : QViewController, IQPushContainerViewController {

    open private(set) var viewControllers: [IQPushViewController]
    open var currentViewController: IQPushViewController? {
        get { return self.viewControllers.first }
    }
    open var presentAnimation: IQPushViewControllerFixedAnimation
    open var dismissAnimation: IQPushViewControllerFixedAnimation
    open var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = self._prepareInteractiveDismissGesture()
    
    private var _activeInteractiveViewController: IQPushViewController?
    private var _activeInteractiveDismissAnimation: IQPushViewControllerInteractiveAnimation?

    public override init() {
        self.viewControllers = []
        self.presentAnimation = QPushViewControllerPresentAnimation()
        self.dismissAnimation = QPushViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QPushViewControllerInteractiveDismissAnimation()
        self.isAnimating = false
        super.init()
    }

    open override func didLoad() {
        super.didLoad()

        if let vc = self.currentViewController {
            self._present(vc, animated: false, completion: nil)
        }
    }

    open override func layout(bounds: CGRect) {
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

    open func presentPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        self.viewControllers.append(viewController)
        self._addChildViewController(viewController)
        if currentViewController == nil {
            self._present(viewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

    open func dismissPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(viewController, animated: animated, completion: completion)
    }

    private func _present(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isLoaded == true {
            self._appearViewController(viewController)
            self.setNeedUpdateStatusBar()
            self.isAnimating = true
            let presentAnimation = self._preparePresentAnimation(viewController)
            presentAnimation.prepare(viewController: viewController)
            presentAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                if let strong = self {
                    strong.isAnimating = false
                }
                completion?()
            })
        } else {
            completion?()
        }
    }

    private func _dismiss(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
            if self.isLoaded == true {
                if currentViewController === viewController {
                    if self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    if let nextViewController = self.currentViewController {
                        self._dismissOne(viewController, animated: animated, completion: { [weak self] in
                            if let strong = self {
                                strong._present(nextViewController, animated: animated, completion: completion)
                            } else {
                                completion?()
                            }
                        })
                    } else {
                        self._dismissOne(viewController, animated: animated, completion: completion)
                    }
                } else {
                    self._dismissOne(viewController, animated: false, completion: completion)
                }
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }

    private func _dismissOne(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        let dismissAnimation = self._prepareDismissAnimation(viewController)
        self.isAnimating = true
        dismissAnimation.prepare(viewController: viewController)
        dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
            if let strong = self {
                strong._disappearViewController(viewController)
                strong._removeChildViewController(viewController)
                strong.isAnimating = false
            }
            completion?()
        })
    }
    
    private func _addChildViewController(_ viewController: IQPushViewController) {
        viewController.parent = self
    }
    
    private func _removeChildViewController(_ viewController: IQPushViewController) {
        viewController.parent = nil
    }

    private func _appearViewController(_ viewController: IQPushViewController) {
        viewController.view.frame = self.view.bounds
        viewController.view.addGestureRecognizer(self.interactiveDismissGesture)
        self.view.addSubview(viewController.view)
    }

    private func _disappearViewController(_ viewController: IQPushViewController) {
        viewController.view.removeGestureRecognizer(self.interactiveDismissGesture)
        viewController.view.removeFromSuperview()
    }

    private func _preparePresentAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerFixedAnimation {
        if let animation = viewController.pushPresentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerFixedAnimation {
        if let animation = viewController.pushDismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerInteractiveAnimation? {
        if let animation = viewController.pushInteractiveDismissAnimation { return animation }
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
            self._activeInteractiveViewController = viewController
            self._activeInteractiveDismissAnimation = dismissAnimation
            self.isAnimating = true
            dismissAnimation.prepare(
                viewController: viewController,
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
        guard let viewController = self._activeInteractiveViewController else {
            self._endInteractiveDismiss()
            return
        }
        self._disappearViewController(viewController)
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
            if let nextViewController = self.currentViewController {
                self._present(nextViewController, animated: true, completion: { [weak self] in
                    guard let strong = self else { return }
                    strong._endInteractiveDismiss()
                })
            } else {
                self._endInteractiveDismiss()
            }
        } else {
            self._endInteractiveDismiss()
        }
    }

    private func _cancelInteractiveDismiss() {
        self._endInteractiveDismiss()
    }

    private func _endInteractiveDismiss() {
        self._activeInteractiveViewController = nil
        self._activeInteractiveDismissAnimation = nil
        self.isAnimating = false
    }

}

extension QPushContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewController = self.currentViewController else {
            return false
        }
        let location = gestureRecognizer.location(in: viewController.pushContentViewController.view)
        return viewController.pushContentViewController.view.point(inside: location, with: nil)
    }

}
