//
//  Quickly
//

open class QStackContainerViewController : QViewController, IQStackContainerViewController {

    open private(set) var viewControllers: [IQStackViewController]
    open var rootViewController: IQStackViewController? {
        get { return self.viewControllers.first }
    }
    open var currentViewController: IQStackViewController? {
        get { return self.viewControllers.last }
    }
    open var previousViewController: IQStackViewController? {
        get {
            guard self.viewControllers.count > 1 else { return nil }
            return self.viewControllers[self.viewControllers.endIndex - 2]
        }
    }
    open var presentAnimation: IQStackViewControllerPresentAnimation
    open var dismissAnimation: IQStackViewControllerDismissAnimation
    open var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIScreenEdgePanGestureRecognizer = self._prepareInteractiveDismissGesture()
    private var activeInteractiveCurrentViewController: IQStackViewController?
    private var activeInteractivePreviousViewController: IQStackViewController?
    private var activeInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?

    public init(_ rootViewController: IQStackViewController) {
        self.viewControllers = [ rootViewController ]
        self.presentAnimation = QStackViewControllerPresentAnimation()
        self.dismissAnimation = QStackViewControllerDismissAnimation()
        self.isAnimating = false
        self.interactiveDismissAnimation = QStackViewControllerinteractiveDismissAnimation()
        super.init()
    }

    open override func didLoad() {
        self.view.addGestureRecognizer(self.interactiveDismissGesture)

        if let vc = self.currentViewController {
            self._present(vc, animated: false, completion: nil)
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

    open func presentStack(_ viewController: IQStackViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        self.viewControllers.append(viewController)
        self._present(viewController, animated: animated, completion: completion)
    }

    open func presentStack(_ viewController: IQStackContentViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        let stackPageViewController = QStackViewController(viewController)
        self.presentStack(stackPageViewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        self._dismiss(viewController, animated: animated, completion: completion)
    }

    open func dismissStack(_ viewController: IQStackContentViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        guard let stackPageViewController = viewController.stackViewController else { return }
        self.dismissStack(stackPageViewController, animated: animated, completion: completion)
    }

    open func dismissStack(to viewController: IQStackViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        if self.previousViewController === viewController {
            self._dismiss(self.currentViewController!, animated: animated, completion: completion)
        } else if self.viewControllers.count > 3 {
            if let index = self.viewControllers.index(where: { return $0 === viewController }) {
                let startIndex = self.viewControllers.index(index, offsetBy: 2)
                let endIndex = self.viewControllers.index(self.viewControllers.endIndex, offsetBy: -1)
                if endIndex - startIndex > 2 {
                    let hiddenViewControllers = self.viewControllers[startIndex..<endIndex]
                    hiddenViewControllers.forEach({ (hiddenViewController) in
                        self._dismiss(hiddenViewController, animated: false, completion: nil)
                    })
                } else {

                }
            }
        }
    }

    open func dismissStack(to viewController: IQStackContentViewController, animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        guard let stackPageViewController = viewController.stackViewController else { return }
        self.dismissStack(to: stackPageViewController, animated: animated, completion: completion)
    }

    private func _present(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Swift.Void)?) {
        if self.isLoaded == true {
            if let previousViewController = self.previousViewController {
                self._appearViewController(viewController)
                self.setNeedUpdateStatusBar()
                self.isAnimating = true
                let presentAnimation = self._preparePresentAnimation(viewController)
                presentAnimation.prepare(
                    contentView: self.view,
                    currentViewController: previousViewController,
                    nextViewController: viewController
                )
                presentAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                    if let strong = self {
                        strong._disappearViewController(previousViewController)
                        strong.isAnimating = false
                    }
                    completion?()
                })
            } else {
                self._appearViewController(viewController)
                self.setNeedUpdateStatusBar()
                completion?()
            }
        } else {
            completion?()
        }
    }

    private func _dismiss(_ viewController: IQStackViewController, animated: Bool, completion: (() -> Void)?) {
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            let currentViewController = self.currentViewController
            let previousViewController = self.previousViewController
            self.viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateStatusBar()
                if currentViewController === viewController, let previousViewController = previousViewController {
                    if self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    self._appearViewController(previousViewController)
                    self.isAnimating = true
                    let dismissAnimation = self._prepareDismissAnimation(previousViewController)
                    dismissAnimation.prepare(
                        contentView: self.view,
                        currentViewController: viewController,
                        previousViewController: previousViewController
                    )
                    dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                        if let strong = self {
                            strong._disappearViewController(viewController)
                            strong.isAnimating = false
                        }
                        completion?()
                    })
                } else {
                    self._disappearViewController(viewController)
                    completion?()
                }
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }

    private func _appearViewController(_ viewController: IQStackViewController) {
        if viewController.parent !== self {
            viewController.parent = self
            viewController.view.bounds = self.view.bounds
            self.view.addSubview(viewController.view)
        }
    }

    private func _disappearViewController(_ viewController: IQStackViewController) {
        if viewController.parent === self {
            viewController.view.removeFromSuperview()
            viewController.parent = nil
        }
    }

    private func _preparePresentAnimation(_ viewController: IQStackViewController) -> IQStackViewControllerPresentAnimation {
        if let animation = viewController.stackPresentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQStackViewController) -> IQStackViewControllerDismissAnimation {
        if let animation = viewController.stackDismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareInteractiveDismissAnimation(_ viewController: IQStackViewController) -> IQStackViewControllerInteractiveDismissAnimation? {
        if let animation = viewController.stackInteractiveDismissAnimation { return animation }
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
                let currentViewController = self.currentViewController,
                let previousViewController = self.previousViewController,
                let dismissAnimation = self._prepareInteractiveDismissAnimation(currentViewController)
                else { return }
            self.activeInteractiveCurrentViewController = currentViewController
            self.activeInteractivePreviousViewController = previousViewController
            self.activeInteractiveDismissAnimation = dismissAnimation
            self._appearViewController(previousViewController)
            self.isAnimating = true
            dismissAnimation.prepare(
                contentView: self.view,
                currentViewController: currentViewController,
                previousViewController: previousViewController,
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
        if let vc = self.activeInteractiveCurrentViewController {
            if let index = self.viewControllers.index(where: { return $0 === vc }) {
                self.viewControllers.remove(at: index)
            }
            self._disappearViewController(vc)
        }
        self.setNeedUpdateStatusBar()
        self._endInteractiveDismiss()
    }

    private func _cancelInteractiveDismiss() {
        if let vc = self.activeInteractivePreviousViewController {
            self._disappearViewController(vc)
        }
        self._endInteractiveDismiss()
    }

    private func _endInteractiveDismiss() {
        self.activeInteractiveCurrentViewController = nil
        self.activeInteractivePreviousViewController = nil
        self.activeInteractiveDismissAnimation = nil
        self.isAnimating = false
    }

}

extension QStackContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactiveDismissGesture else { return false }
        guard self.viewControllers.count > 1 else { return false }
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
