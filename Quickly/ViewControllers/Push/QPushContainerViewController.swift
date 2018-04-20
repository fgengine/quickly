//
//  Quickly
//

open class QPushContainerViewController : QViewController, IQPushContainerViewController {

    open var viewControllers: [IQPushViewController] = []
    open var currentViewController: IQPushViewController? {
        get { return self.viewControllers.first }
    }
    open var presentAnimation: IQPushViewControllerFixedAnimation = QPushViewControllerPresentAnimation()
    open var dismissAnimation: IQPushViewControllerFixedAnimation = QPushViewControllerDismissAnimation()
    open var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? = QPushViewControllerInteractiveDismissAnimation()
    open lazy var interactiveDismissGesture: UIPanGestureRecognizer = self._prepareInteractiveDismissGesture()
    private var activeInteractiveViewController: IQPushViewController?
    private var activeInteractiveDismissAnimation: IQPushViewControllerInteractiveAnimation?

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
        viewController.containerViewController = self
        if self.isLoaded == true && currentViewController == nil {
            self._present(viewController, animated: animated, completion: completion)
        }
    }

    open func dismissPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(viewController, currentAnimated: animated, nextAnimated: animated, skipInteractiveDismiss: true, completion: completion)
    }

    private func _present(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        self._appearViewController(viewController)
        self.setNeedUpdateStatusBar()
        if animated == true {
            let presentAnimation = self._preparePresentAnimation(viewController)
            presentAnimation.prepare(viewController: viewController)
            presentAnimation.update(animated: animated, complete: { (completed: Bool) in
                completion?()
            })
        } else {
            completion?()
        }
    }

    private func _dismiss(_ viewController: IQPushViewController, currentAnimated: Bool, nextAnimated: Bool, skipInteractiveDismiss: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
            if self.isLoaded == true {
                if currentViewController === viewController {
                    if skipInteractiveDismiss == true && self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    if let nextViewController = self.currentViewController {
                        self._dismiss(viewController, animated: currentAnimated, completion: { [weak self] in
                            viewController.containerViewController = nil
                            if let strongify = self {
                                strongify._present(nextViewController, animated: nextAnimated, completion: {
                                    completion?()
                                })
                            } else {
                                completion?()
                            }
                        })
                    } else {
                        self._dismiss(viewController, animated: currentAnimated, completion: {
                            viewController.containerViewController = nil
                            completion?()
                        })
                    }
                } else {
                    self._dismiss(viewController, animated: false, completion: {
                        viewController.containerViewController = nil
                        completion?()
                    })
                }
            }
        }
    }

    private func _dismiss(_ viewController: IQPushViewController, animated: Bool, completion: (() -> Void)?) {
        if animated == true {
            let dismissAnimation = self._prepareDismissAnimation(viewController)
            dismissAnimation.prepare(viewController: viewController)
            dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                if let strongify = self {
                    strongify._disappearViewController(viewController)
                }
                completion?()
            })
        } else {
            self._disappearViewController(viewController)
            completion?()
        }
    }

    private func _appearViewController(_ viewController: IQPushViewController) {
        viewController.parent = self
        viewController.view.frame = self.view.bounds
        viewController.view.addGestureRecognizer(self.interactiveDismissGesture)
        self.view.addSubview(viewController.view)
    }

    private func _disappearViewController(_ viewController: IQPushViewController) {
        viewController.view.removeGestureRecognizer(self.interactiveDismissGesture)
        viewController.view.removeFromSuperview()
        viewController.parent = nil
    }

    private func _preparePresentAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerFixedAnimation {
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerFixedAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQPushViewController) -> IQPushViewControllerInteractiveAnimation? {
        if let animation = viewController.interactiveDismissAnimation { return animation }
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
                let vc = self.currentViewController,
                let ida = self._prepareinteractiveDismissAnimation(vc)
                else { return }
            self.activeInteractiveViewController = vc
            self.activeInteractiveDismissAnimation = interactiveDismissAnimation
            ida.prepare(viewController: vc, position: position, velocity: velocity)
            break
        case .changed:
            guard let ida = self.activeInteractiveDismissAnimation else { return }
            ida.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard
                let vc = self.activeInteractiveViewController,
                let ida = self.activeInteractiveDismissAnimation
                else { return }
            if ida.canFinish == true {
                ida.finish({ [weak self] (completed: Bool) in
                    guard let strongify = self else { return }
                    strongify._dismiss(vc, currentAnimated: false, nextAnimated: true, skipInteractiveDismiss: false, completion: {
                        strongify._endInteractiveDismiss()
                    })
                })
            } else {
                ida.cancel({ [weak self] (completed: Bool) in
                    guard let strongify = self else { return }
                    strongify._endInteractiveDismiss()
                })
            }
            break
        default:
            break
        }
    }

    private func _endInteractiveDismiss() {
        self.activeInteractiveViewController = nil
        self.activeInteractiveDismissAnimation = nil
    }

}

extension QPushContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewController = self.currentViewController else {
            return false
        }
        let location = gestureRecognizer.location(in: viewController.contentViewController.view)
        return viewController.contentViewController.view.point(inside: location, with: nil)
    }

}
