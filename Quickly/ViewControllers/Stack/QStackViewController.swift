//
//  Quickly
//

open class QStackViewController : QViewController, IQStackViewController {

    open var viewControllers: [IQStackPageViewController]
    open var currentViewController: IQStackPageViewController? {
        get { return self.viewControllers.last }
    }
    open var previousViewController: IQStackPageViewController? {
        get {
            guard self.viewControllers.count > 1 else { return nil }
            return self.viewControllers[self.viewControllers.endIndex - 2]
        }
    }
    open var presentAnimation: IQStackViewControllerPresentAnimation
    open var dismissAnimation: IQStackViewControllerDismissAnimation
    open var interactiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation?
    open lazy var interactiveDismissGesture: UIScreenEdgePanGestureRecognizer = self._prepareInteractiveDismissGesture()
    open private(set) var isAnimating: Bool = false

    private var activeInteractiveCurrentViewController: IQStackPageViewController?
    private var activeInteractivePreviousViewController: IQStackPageViewController?
    private var activeInteractiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation?

    public init(rootViewController: IQStackPageViewController) {
        self.viewControllers = [ rootViewController ]
        self.presentAnimation = QStackViewControllerPresentAnimation()
        self.dismissAnimation = QStackViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QStackViewControllerinteractiveDismissAnimation()
        super.init()
    }

    open override func didLoad() {
        self.view.addGestureRecognizer(self.interactiveDismissGesture)

        if let viewController = self.currentViewController {
            self._present(viewController, animated: false, completion: nil)
        }
    }

    open override func layout(bounds: CGRect) {
        if self.isAnimating == false {
            if let vc = self.currentViewController {
                vc.view.frame = self.view.bounds
            }
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

    open func presentStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self.viewControllers.append(viewController)
        viewController.stackViewController = self
        if self.isLoaded == true {
            self._present(viewController, animated: animated, completion: completion)
        }
    }

    open func presentStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        let stackPageViewController = QStackPageViewController.init(contentViewController: viewController)
        self.presentStack(stackPageViewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        self._dismiss(viewController, animated: animated, skipInteractiveDismiss: true, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackContentViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        guard let stackPageViewController = viewController.stackPageViewController else { return }
        self.dismissStack(stackPageViewController, animated: animated, completion: completion)
    }

    private func _present(_ viewController: IQStackPageViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        if let pvc = self.previousViewController {
            self._appearViewController(viewController)
            self.setNeedUpdateStatusBar()
            if animated == true {
                self.isAnimating = true
                let presentAnimation = self._preparePresentAnimation(viewController)
                presentAnimation.prepare(
                    contentView: self.view,
                    currentViewController: pvc,
                    nextViewController: viewController
                )
                presentAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.isAnimating = false
                        strongify._disappearViewController(pvc)
                    }
                    completion?()
                })
            } else {
                self._disappearViewController(pvc)
                completion?()
            }
        } else {
            self._appearViewController(viewController)
            self.setNeedUpdateStatusBar()
            completion?()
        }
    }

    private func _dismiss(_ viewController: IQStackPageViewController, animated: Bool, skipInteractiveDismiss: Bool, completion: (() -> Void)?) {
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            let currentViewController = self.currentViewController
            let previousViewController = self.previousViewController
            self.viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateStatusBar()
                if currentViewController === viewController, let pvc = previousViewController {
                    if skipInteractiveDismiss == true && self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    if animated == true {
                        self._appearViewController(pvc)
                        self.isAnimating = true
                        let dismissAnimation = self._prepareDismissAnimation(pvc)
                        dismissAnimation.prepare(
                            contentView: self.view,
                            currentViewController: viewController,
                            previousViewController: pvc
                        )
                        dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                            if let strongify = self {
                                strongify.isAnimating = false
                                strongify._disappearViewController(viewController)
                            }
                            completion?()
                        })
                    } else {
                        self._disappearViewController(viewController)
                        completion?()
                    }
                } else {
                    self._disappearViewController(viewController)
                    completion?()
                }
            }
        }
    }

    private func _appearViewController(_ viewController: IQStackPageViewController) {
        if viewController.parent !== self {
            viewController.parent = self
            viewController.view.bounds = self.view.bounds
            self.view.addSubview(viewController.view)
        }
    }

    private func _disappearViewController(_ viewController: IQStackPageViewController) {
        if viewController.parent === self {
            viewController.view.removeFromSuperview()
            viewController.parent = nil
        }
    }

    private func _preparePresentAnimation(_ viewController: IQStackPageViewController) -> IQStackViewControllerPresentAnimation {
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQStackPageViewController) -> IQStackViewControllerDismissAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQStackPageViewController) -> IQStackViewControllerinteractiveDismissAnimation? {
        if let animation = viewController.interactiveDismissAnimation { return animation }
        return self.interactiveDismissAnimation
    }

    private func _prepareInteractiveDismissGesture() -> UIScreenEdgePanGestureRecognizer {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self._interactiveDismissGestureHandler(_:)))
        gesture.delaysTouchesBegan = true
        gesture.edges = [ .left ]
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
                let cvc = self.currentViewController,
                let pvc = self.previousViewController,
                let idc = self._prepareinteractiveDismissAnimation(cvc)
                else { return }
            self.activeInteractiveCurrentViewController = cvc
            self.activeInteractivePreviousViewController = pvc
            self.activeInteractiveDismissAnimation = idc
            self._appearViewController(pvc)
            self.isAnimating = true
            idc.prepare(
                contentView: self.view,
                currentViewController: cvc,
                previousViewController: pvc,
                position: position,
                velocity: velocity
            )
            break
        case .changed:
            guard let idc = self.activeInteractiveDismissAnimation else { return }
            idc.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard
                let cvc = self.activeInteractiveCurrentViewController,
                let pvc = self.activeInteractivePreviousViewController,
                let idc = self.activeInteractiveDismissAnimation
                else { return }
            if idc.canFinish == true {
                idc.finish({ [weak self] (completed: Bool) in
                    guard let strongify = self else { return }
                    strongify.isAnimating = false
                    strongify._dismiss(cvc, animated: false, skipInteractiveDismiss: false, completion: {
                        strongify._endInteractiveDismiss()
                    })
                })
            } else {
                idc.cancel({ [weak self] (completed: Bool) in
                    guard let strongify = self else { return }
                    strongify._disappearViewController(pvc)
                    strongify.isAnimating = false
                    strongify._endInteractiveDismiss()
                })
            }
            break
        default:
            break
        }
    }

    private func _endInteractiveDismiss() {
        self.activeInteractiveCurrentViewController = nil
        self.activeInteractivePreviousViewController = nil
        self.activeInteractiveDismissAnimation = nil
    }

}

extension QStackViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        guard self.viewControllers.count > 1 else { return false }
        return true
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        return true
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        let location = touch.location(in: self.view)
        return self.view.point(inside: location, with: nil)
    }

}
