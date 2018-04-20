//
//  Quickly
//

open class QDialogContainerViewController : QViewController, IQDialogContainerViewController {
    
    open var viewControllers: [IQDialogViewController] = []
    open var currentViewController: IQDialogViewController? {
        get { return self.viewControllers.first }
    }
    open var backgroundView: BackgroundView? {
        willSet {
            if let backgroundView = self.backgroundView {
                backgroundView.containerViewController = nil
                if self.isLoaded == true {
                    backgroundView.removeFromSuperview()
                }
                backgroundView.removeGestureRecognizer(self.interactiveDismissGesture)
            }
        }
        didSet {
            if let backgroundView = self.backgroundView {
                backgroundView.containerViewController = self
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
    open lazy var interactiveDismissGesture: UIPanGestureRecognizer = self._prepareInteractiveDismissGesture()

    private var activeInteractiveViewController: IQDialogViewController?
    private var activeInteractiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?

    public override init() {
        self.presentAnimation = QDialogViewControllerPresentAnimation()
        self.dismissAnimation = QDialogViewControllerDismissAnimation()
        self.interactiveDismissAnimation = QDialogViewControllerinteractiveDismissAnimation()
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
        super.layout(bounds: bounds)

        if let view = self.backgroundView {
            view.frame = bounds
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
        viewController.containerViewController = self
        if currentViewController == nil && self.isLoaded == true {
            self._present(viewController, animated: animated, completion: completion)
        }
    }

    open func dismissDialog(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(viewController, currentAnimated: animated, nextAnimated: animated, skipInteractiveDismiss: true, completion: completion)
    }

    private func _present(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if let backgroundView = self.backgroundView {
            backgroundView.presentDialog(
                viewController: viewController,
                isFirst: self.viewControllers.count == 1,
                animated: animated
            )
        }
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

    private func _dismiss(_ viewController: IQDialogViewController, currentAnimated: Bool, nextAnimated: Bool, skipInteractiveDismiss: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.index(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateStatusBar()
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

    private func _dismiss(_ viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if let backgroundView = self.backgroundView {
            backgroundView.dismissDialog(
                viewController: viewController,
                isLast: self.viewControllers.isEmpty,
                animated: animated
            )
        }
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
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    private func _prepareDismissAnimation(_ viewController: IQDialogViewController) -> IQDialogViewControllerFixedAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    private func _prepareinteractiveDismissAnimation(_ viewController: IQDialogViewController) -> IQDialogViewControllerInteractiveAnimation? {
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
                let idc = self._prepareinteractiveDismissAnimation(vc)
                else { return }
            self.activeInteractiveViewController = vc
            self.activeInteractiveDismissAnimation = idc
            idc.prepare(viewController: vc, position: position, velocity: velocity)
            break
        case .changed:
            guard let idc = self.activeInteractiveDismissAnimation else { return }
            idc.update(position: position, velocity: velocity)
            break
        case .ended, .failed, .cancelled:
            guard
                let vc = self.activeInteractiveViewController,
                let idc = self.activeInteractiveDismissAnimation
                else { return }
            if idc.canFinish == true {
                idc.finish({ [weak self] (completed: Bool) in
                    guard let strongify = self else { return }
                    strongify._dismiss(vc, currentAnimated: false, nextAnimated: true, skipInteractiveDismiss: false, completion: {
                        strongify._endInteractiveDismiss()
                    })
                })
            } else {
                idc.cancel({ [weak self] (completed: Bool) in
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

extension QDialogContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let vc = self.currentViewController else { return false }
        let location = gestureRecognizer.location(in: vc.contentViewController.view)
        return vc.contentViewController.view.point(inside: location, with: nil)
    }

}
