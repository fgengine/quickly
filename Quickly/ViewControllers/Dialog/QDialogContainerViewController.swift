//
//  Quickly
//

open class QDialogContainerViewController : QViewController, IQDialogContainerViewController {
    
    open private(set) var viewControllers: [IQDialogViewController]
    open var currentViewController: IQDialogViewController? {
        get { return self.viewControllers.first }
    }
    open var backgroundView: BackgroundView? {
        willSet {
            if let backgroundView = self.backgroundView {
                backgroundView.dialogContainerViewController = nil
                if self.isLoaded == true {
                    backgroundView.removeFromSuperview()
                }
                backgroundView.removeGestureRecognizer(self.interactiveDismissGesture)
            }
        }
        didSet {
            if let backgroundView = self.backgroundView {
                backgroundView.dialogContainerViewController = self
                if self.isLoaded == true {
                    self.view.insertSubview(backgroundView, at: 0)
                }
                backgroundView.addGestureRecognizer(self.interactiveDismissGesture)
            }
        }
    }
    open var presentAnimation: IQDialogViewControllerFixedAnimation
    open var dismissAnimation: IQDialogViewControllerFixedAnimation
    open var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = self._prepareInteractiveDismissGesture()
    private var activeInteractiveViewController: IQDialogViewController?
    private var activeInteractiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?

    public override init() {
        self.viewControllers = []
        self.presentAnimation = QDialogViewControllerPresentAnimation()
        self.dismissAnimation = QDialogViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QDialogViewControllerinteractiveDismissAnimation()
        self.isAnimating = false
        super.init()
    }

    open override func setup() {
        super.setup()

        self.edgesForExtendedLayout = []
    }

    open override func didLoad() {
        super.didLoad()

        if let view = self.backgroundView {
            view.frame = self.view.bounds
            self.view.addSubview(view)
        }
        if let vc = self.currentViewController {
            self._present(vc, animated: false, completion: nil)
        }
    }

    open override func layout(bounds: CGRect) {
        if let view = self.backgroundView {
            view.frame = bounds
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

    open func presentDialog(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        self.viewControllers.append(viewController)
        if currentViewController == nil {
            self._present(viewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

    open func dismissDialog(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(viewController, animated: animated, completion: completion)
    }

    private func _present(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isLoaded == true {
            if let backgroundView = self.backgroundView {
                backgroundView.presentDialog(
                    viewController: viewController,
                    isFirst: self.viewControllers.count == 1,
                    animated: animated
                )
            }
            self._appearViewController(viewController)
            self.setNeedUpdateStatusBar()
            self.isAnimating = true
            let presentAnimation = self._preparePresentAnimation(viewController)
            presentAnimation.prepare(viewController: viewController)
            presentAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
                if let strong = self {
                    strong.isAnimating = true
                }
                completion?()
            })
        } else {
            completion?()
        }
    }

    private func _dismiss(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateStatusBar()
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

    private func _dismissOne(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if let backgroundView = self.backgroundView {
            backgroundView.dismissDialog(
                viewController: viewController,
                isLast: self.viewControllers.isEmpty,
                animated: animated
            )
        }
        let dismissAnimation = self._prepareDismissAnimation(viewController)
        dismissAnimation.prepare(viewController: viewController)
        dismissAnimation.update(animated: animated, complete: { [weak self] (completed: Bool) in
            if let strong = self {
                strong._disappearViewController(viewController)
                strong.isAnimating = true
            }
            completion?()
        })
    }

    private func _appearViewController(_ viewController: IQDialogViewController) {
        viewController.parent = self
        viewController.view.bounds = self.view.bounds
        viewController.view.addGestureRecognizer(self.interactiveDismissGesture)
        self.view.addSubview(viewController.view)
    }

    private func _disappearViewController(_ viewController: IQDialogViewController) {
        viewController.view.removeGestureRecognizer(self.interactiveDismissGesture)
        viewController.view.removeFromSuperview()
        viewController.parent = nil
    }

    private func _preparePresentAnimation(_ viewController: IQDialogViewController) -> IQDialogViewControllerFixedAnimation {
        if let animation = viewController.dialogPresentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQDialogViewController) -> IQDialogViewControllerFixedAnimation {
        if let animation = viewController.dialogDismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQDialogViewController) -> IQDialogViewControllerInteractiveAnimation? {
        if let animation = viewController.dialogInteractiveDismissAnimation { return animation }
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
            self.activeInteractiveViewController = viewController
            self.activeInteractiveDismissAnimation = dismissAnimation
            self.isAnimating = true
            dismissAnimation.prepare(viewController: viewController, position: position, velocity: velocity)
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
        guard let viewController = self.activeInteractiveViewController else {
            self._endInteractiveDismiss()
            return
        }
        self._disappearViewController(viewController)
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateStatusBar()
            if let backgroundView = self.backgroundView {
                backgroundView.dismissDialog(
                    viewController: viewController,
                    isLast: self.viewControllers.isEmpty,
                    animated: true
                )
            }
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
        self.activeInteractiveViewController = nil
        self.activeInteractiveDismissAnimation = nil
        self.isAnimating = false
    }

}

extension QDialogContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let vc = self.currentViewController else { return false }
        let location = gestureRecognizer.location(in: vc.dialogContentViewController.view)
        return vc.dialogContentViewController.view.point(inside: location, with: nil)
    }

}
