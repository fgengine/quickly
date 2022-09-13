//
//  Quickly
//

import UIKit

open class QDialogContainerViewController : QViewController, IQDialogContainerViewController {
    
    open private(set) var viewControllers: [IQDialogViewController]
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
    open private(set) var isAnimating: Bool
    public private(set) lazy var interactiveDismissGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleInteractiveDismissGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private var _activeInteractiveViewController: IQDialogViewController?
    private var _activeInteractiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?

    public init(
        backgroundView: BackgroundView? = nil,
        presentAnimation: IQDialogViewControllerFixedAnimation = QDialogViewControllerPresentAnimation(),
        dismissAnimation: IQDialogViewControllerFixedAnimation = QDialogViewControllerDismissAnimation(),
        interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation? = QDialogViewControllerinteractiveDismissAnimation()
    ) {
        self.viewControllers = []
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.interactiveDismissAnimation = interactiveDismissAnimation
        self.isAnimating = false
        super.init()
        self.backgroundView = backgroundView
    }

    open override func didLoad() {
        super.didLoad()

        if let view = self.backgroundView {
            view.frame = self.view.bounds
            self.view.addSubview(view)
        }
        if let vc = self.currentViewController {
            self._present(viewController: vc, animated: false, completion: nil)
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

    open func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        self.viewControllers.append(viewController)
        self._add(childViewController: viewController)
        if currentViewController == nil {
            self._present(viewController: viewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }

    open func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(viewController: viewController, animated: animated, completion: completion)
    }
    
}
    
// MARK: Private

private extension QDialogContainerViewController {

    func _present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if self.isLoaded == true {
            if let backgroundView = self.backgroundView {
                backgroundView.present(
                    viewController: viewController,
                    isFirst: self.viewControllers.count == 1,
                    animated: animated
                )
            }
            self._appear(viewController: viewController)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            self.isAnimating = true
            let presentAnimation = self._presentAnimation(viewController: viewController)
            presentAnimation.animate(
                viewController: viewController,
                animated: animated,
                complete: { [weak self] in
                    if let self = self {
                        self.isAnimating = true
                    }
                    completion?()
                }
            )
        } else {
            completion?()
        }
    }

    func _dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        let currentViewController = self.currentViewController
        if let index = self.viewControllers.firstIndex(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            if self.isLoaded == true {
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                if currentViewController === viewController {
                    if self.interactiveDismissGesture.state != .possible {
                        let enabled = self.interactiveDismissGesture.isEnabled
                        self.interactiveDismissGesture.isEnabled = false
                        self.interactiveDismissGesture.isEnabled = enabled
                    }
                    if let nextViewController = self.currentViewController {
                        self._dismissOne(viewController: viewController, animated: animated, completion: { [weak self] in
                            if let self = self {
                                self._present(viewController: nextViewController, animated: animated, completion: completion)
                            } else {
                                completion?()
                            }
                        })
                    } else {
                        self._dismissOne(viewController: viewController, animated: animated, completion: completion)
                    }
                } else {
                    self._dismissOne(viewController: viewController, animated: false, completion: completion)
                }
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }

    func _dismissOne(viewController: IQDialogViewController, animated: Bool, completion: (() -> Void)?) {
        if let backgroundView = self.backgroundView {
            backgroundView.dismiss(
                viewController: viewController,
                isLast: self.viewControllers.isEmpty,
                animated: animated
            )
        }
        let dismissAnimation = self._dismissAnimation(viewController: viewController)
        dismissAnimation.animate(
            viewController: viewController,
            animated: animated,
            complete: { [weak self] in
                if let self = self {
                    self._disappear(viewController: viewController)
                    self._remove(childViewController: viewController)
                    self.isAnimating = true
                }
                completion?()
            }
        )
    }
    
    func _add(childViewController: IQDialogViewController) {
        childViewController.parentViewController = self
    }
    
    func _remove(childViewController: IQDialogViewController) {
        childViewController.parentViewController = nil
    }

    func _appear(viewController: IQDialogViewController) {
        viewController.view.bounds = self.view.bounds
        viewController.view.addGestureRecognizer(self.interactiveDismissGesture)
        self.view.addSubview(viewController.view)
    }

    func _disappear(viewController: IQDialogViewController) {
        viewController.view.removeGestureRecognizer(self.interactiveDismissGesture)
        viewController.view.removeFromSuperview()
    }

    func _presentAnimation(viewController: IQDialogViewController) -> IQDialogViewControllerFixedAnimation {
        if let animation = viewController.presentAnimation { return animation }
        return self.presentAnimation
    }

    func _dismissAnimation(viewController: IQDialogViewController) -> IQDialogViewControllerFixedAnimation {
        if let animation = viewController.dismissAnimation { return animation }
        return self.dismissAnimation
    }

    func _interactiveDismissAnimation(viewController: IQDialogViewController) -> IQDialogViewControllerInteractiveAnimation? {
        if let animation = viewController.interactiveDismissAnimation { return animation }
        return self.interactiveDismissAnimation
    }

    @objc
    func _handleInteractiveDismissGesture(_ sender: Any) {
        let position = self.interactiveDismissGesture.location(in: nil)
        let velocity = self.interactiveDismissGesture.velocity(in: nil)
        switch self.interactiveDismissGesture.state {
        case .began:
            guard
                let viewController = self.currentViewController,
                let dismissAnimation = self._interactiveDismissAnimation(viewController: viewController)
                else { return }
            self._activeInteractiveViewController = viewController
            self._activeInteractiveDismissAnimation = dismissAnimation
            self.isAnimating = true
            dismissAnimation.prepare(viewController: viewController, position: position, velocity: velocity)
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

    func _finishInteractiveDismiss() {
        guard let viewController = self._activeInteractiveViewController else {
            self._endInteractiveDismiss()
            return
        }
        self._disappear(viewController: viewController)
        if let index = self.viewControllers.firstIndex(where: { return $0 === viewController }) {
            self.viewControllers.remove(at: index)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            if let backgroundView = self.backgroundView {
                backgroundView.dismiss(
                    viewController: viewController,
                    isLast: self.viewControllers.isEmpty,
                    animated: true
                )
            }
            if let nextViewController = self.currentViewController {
                self._present(viewController: nextViewController, animated: true, completion: { [weak self] in
                    guard let self = self else { return }
                    self._endInteractiveDismiss()
                })
            } else {
                self._endInteractiveDismiss()
            }
        } else {
            self._endInteractiveDismiss()
        }
    }

    func _cancelInteractiveDismiss() {
        self._endInteractiveDismiss()
    }

    func _endInteractiveDismiss() {
        self._activeInteractiveViewController = nil
        self._activeInteractiveDismissAnimation = nil
        self.isAnimating = false
    }

}

// MARK: UIGestureRecognizerDelegate

extension QDialogContainerViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let vc = self.currentViewController else { return false }
        let location = gestureRecognizer.location(in: vc.viewController.view)
        return vc.viewController.view.point(inside: location, with: nil)
    }

}
