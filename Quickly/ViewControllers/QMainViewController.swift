//
//  Quickly
//

open class QMainViewController : QViewController {

    open var backgroundViewController: IQViewController? {
        willSet {
            guard let vc = self.backgroundViewController else { return }
            if self.isLoaded == true {
                vc.willDismiss(animated: false)
                vc.didDismiss(animated: false)
                if vc.isLoaded == true {
                    vc.view.removeFromSuperview()
                }
            }
            vc.parentViewController = nil
        }
        didSet {
            guard let vc = self.backgroundViewController else { return }
            vc.parentViewController = self
            if self.isLoaded == true {
                self._appendBackgroundController(vc)
                self.layoutIfNeeded()
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }
    open var contentViewController: IQViewController? {
        willSet {
            guard let vc = self.contentViewController else { return }
            if self.isLoaded == true {
                vc.willDismiss(animated: false)
                vc.didDismiss(animated: false)
                if vc.isLoaded == true {
                    vc.view.removeFromSuperview()
                }
            }
            vc.parentViewController = nil
        }
        didSet {
            defer {
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
            }
            guard let vc = self.contentViewController else { return }
            vc.parentViewController = self
            if self.isLoaded == true {
                self._appendContentController(vc)
                self.layoutIfNeeded()
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }
    open var modalContainerViewController: IQModalContainerViewController? {
        willSet {
            guard let vc = self.modalContainerViewController else { return }
            if self.isLoaded == true {
                vc.willDismiss(animated: false)
                vc.didDismiss(animated: false)
                if vc.isLoaded == true {
                    vc.view.removeFromSuperview()
                }
            }
            vc.parentViewController = nil
        }
        didSet {
            defer {
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
            }
            guard let vc = self.modalContainerViewController else { return }
            vc.parentViewController = self
            if self.isLoaded == true {
                self._appendModalContainer(vc)
                self.layoutIfNeeded()
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }
    open var pushContainerViewController: IQPushContainerViewController? {
        willSet {
            guard let vc = self.pushContainerViewController else { return }
            if self.isLoaded == true {
                vc.willDismiss(animated: false)
                vc.didDismiss(animated: false)
                if vc.isLoaded == true {
                    vc.view.removeFromSuperview()
                }
            }
            vc.parentViewController = nil
        }
        didSet {
            guard let vc = self.pushContainerViewController else { return }
            vc.parentViewController = self
            if self.isLoaded == true {
                self._appendPushContainer(vc)
                self.layoutIfNeeded()
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }
    open var dialogContainerViewController: IQDialogContainerViewController? {
        willSet {
            guard let vc = self.dialogContainerViewController else { return }
            if self.isLoaded == true {
                vc.willDismiss(animated: false)
                vc.didDismiss(animated: false)
                if vc.isLoaded == true {
                    vc.view.removeFromSuperview()
                }
            }
            vc.parentViewController = nil
        }
        didSet {
            guard let vc = self.dialogContainerViewController else { return }
            vc.parentViewController = self
            if self.isLoaded == true {
                self._appendDialogContainer(vc)
                self.layoutIfNeeded()
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }
    open var notificationInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 72, right: 12)
    
    private var _notificationView: QDisplayView? {
        willSet {
            guard let notificationView = self._notificationView else { return }
            notificationView.removeFromSuperview()
        }
        didSet {
            guard let notificationView = self._notificationView else { return }
            self.view.addSubview(notificationView)
        }
    }
    private var _notificationTimer: QTimer? {
        willSet {
            guard let notificationTimer = self._notificationTimer else { return }
            notificationTimer.stop()
        }
        didSet {
            guard let notificationTimer = self._notificationTimer else { return }
            notificationTimer.start()
        }
    }
    private var _notificationConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._notificationConstraints) }
        didSet { self.view.addConstraints(self._notificationConstraints) }
    }
    
    deinit {
        self._notificationTimer?.stop()
    }

    open override func didLoad() {
        if let vc = self.backgroundViewController {
            self._appendBackgroundController(vc)
        }
        if let vc = self.contentViewController {
            self._appendContentController(vc)
        }
        if let vc = self.modalContainerViewController {
            self._appendModalContainer(vc)
        }
        if let vc = self.dialogContainerViewController {
            self._appendDialogContainer(vc)
        }
        if let vc = self.pushContainerViewController {
            self._appendPushContainer(vc)
        }
    }

    open override func layout(bounds: CGRect) {
        self.backgroundViewController?.view.frame = bounds
        self.contentViewController?.view.frame = bounds
        self.modalContainerViewController?.view.frame = bounds
        self.dialogContainerViewController?.view.frame = bounds
        self.pushContainerViewController?.view.frame = bounds
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.backgroundViewController?.prepareInteractivePresent()
        self.contentViewController?.prepareInteractivePresent()
        self.modalContainerViewController?.prepareInteractivePresent()
        self.dialogContainerViewController?.prepareInteractivePresent()
        self.pushContainerViewController?.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.backgroundViewController?.cancelInteractivePresent()
        self.contentViewController?.cancelInteractivePresent()
        self.modalContainerViewController?.cancelInteractivePresent()
        self.dialogContainerViewController?.cancelInteractivePresent()
        self.pushContainerViewController?.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.backgroundViewController?.finishInteractivePresent()
        self.contentViewController?.finishInteractivePresent()
        self.modalContainerViewController?.finishInteractivePresent()
        self.dialogContainerViewController?.finishInteractivePresent()
        self.pushContainerViewController?.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.backgroundViewController?.willPresent(animated: animated)
        self.contentViewController?.willPresent(animated: animated)
        self.modalContainerViewController?.willPresent(animated: animated)
        self.dialogContainerViewController?.willPresent(animated: animated)
        self.pushContainerViewController?.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.backgroundViewController?.didPresent(animated: animated)
        self.contentViewController?.didPresent(animated: animated)
        self.modalContainerViewController?.didPresent(animated: animated)
        self.dialogContainerViewController?.didPresent(animated: animated)
        self.pushContainerViewController?.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.backgroundViewController?.prepareInteractiveDismiss()
        self.contentViewController?.prepareInteractiveDismiss()
        self.modalContainerViewController?.prepareInteractiveDismiss()
        self.dialogContainerViewController?.prepareInteractiveDismiss()
        self.pushContainerViewController?.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.backgroundViewController?.cancelInteractiveDismiss()
        self.contentViewController?.cancelInteractiveDismiss()
        self.modalContainerViewController?.cancelInteractiveDismiss()
        self.dialogContainerViewController?.cancelInteractiveDismiss()
        self.pushContainerViewController?.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.backgroundViewController?.finishInteractiveDismiss()
        self.contentViewController?.finishInteractiveDismiss()
        self.modalContainerViewController?.finishInteractiveDismiss()
        self.dialogContainerViewController?.finishInteractiveDismiss()
        self.pushContainerViewController?.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.backgroundViewController?.willDismiss(animated: animated)
        self.contentViewController?.willDismiss(animated: animated)
        self.modalContainerViewController?.willDismiss(animated: animated)
        self.dialogContainerViewController?.willDismiss(animated: animated)
        self.pushContainerViewController?.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.backgroundViewController?.didDismiss(animated: animated)
        self.contentViewController?.didDismiss(animated: animated)
        self.modalContainerViewController?.didDismiss(animated: animated)
        self.dialogContainerViewController?.didDismiss(animated: animated)
        self.pushContainerViewController?.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.backgroundViewController?.willTransition(size: size)
        self.contentViewController?.willTransition(size: size)
        self.modalContainerViewController?.willTransition(size: size)
        self.dialogContainerViewController?.willTransition(size: size)
        self.pushContainerViewController?.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.backgroundViewController?.didTransition(size: size)
        self.contentViewController?.didTransition(size: size)
        self.modalContainerViewController?.didTransition(size: size)
        self.dialogContainerViewController?.didTransition(size: size)
        self.pushContainerViewController?.didTransition(size: size)
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        if let vc = self.modalContainerViewController?.currentViewController { return vc.supportedOrientations() }
        if let vc = self.contentViewController { return vc.supportedOrientations() }
        return super.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        if let vc = self.dialogContainerViewController?.currentViewController { return vc.preferedStatusBarHidden() }
        if let vc = self.modalContainerViewController?.currentViewController { return vc.preferedStatusBarHidden() }
        if let vc = self.contentViewController { return vc.preferedStatusBarHidden() }
        return super.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        if let vc = self.dialogContainerViewController?.currentViewController { return vc.preferedStatusBarStyle() }
        if let vc = self.modalContainerViewController?.currentViewController { return vc.preferedStatusBarStyle() }
        if let vc = self.contentViewController { return vc.preferedStatusBarStyle() }
        return super.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        if let vc = self.dialogContainerViewController?.currentViewController { return vc.preferedStatusBarAnimation() }
        if let vc = self.modalContainerViewController?.currentViewController { return vc.preferedStatusBarAnimation() }
        if let vc = self.contentViewController { return vc.preferedStatusBarAnimation() }
        return super.preferedStatusBarAnimation()
    }
    
    open func present(notificationView: QDisplayView, alignment: NotificationAlignment, duration: TimeInterval) {
        notificationView.alpha = 0
        self._notificationView = notificationView
        self._beganConstraints(notificationView: notificationView, alignment: alignment)
        self.view.layoutIfNeeded()
        self._notificationTimer = QTimer(
            interval: duration,
            onFinished: { [weak self] _ in self?._triggeredNotificationTimer() }
        )
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self._endedConstraints(notificationView: notificationView, alignment: alignment)
            self.view.layoutIfNeeded()
            notificationView.alpha = 1
        })
    }
    
}

// MARK: Public

public extension QMainViewController {
    
    enum NotificationAlignment {
        case leading
        case trailing
    }
    
}

// MARK: Private

private extension QMainViewController {
    
    func _beganConstraints(notificationView: QDisplayView, alignment: NotificationAlignment) {
        switch alignment {
        case .leading:
            self._notificationConstraints = [
                self.view.leadingLayout == notificationView.trailingLayout.offset(-self.notificationInsets.left),
                self.view.bottomLayout == notificationView.bottomLayout.offset(self.notificationInsets.bottom)
            ]
        case .trailing:
            self._notificationConstraints = [
                self.view.trailingLayout == notificationView.trailingLayout.offset(-self.notificationInsets.right),
                self.view.bottomLayout == notificationView.bottomLayout.offset(self.notificationInsets.bottom)
            ]
        }
    }
    
    func _endedConstraints(notificationView: QDisplayView, alignment: NotificationAlignment) {
        switch alignment {
        case .leading:
            self._notificationConstraints = [
                self.view.leadingLayout == notificationView.leadingLayout.offset(-self.notificationInsets.left),
                self.view.trailingLayout >= notificationView.trailingLayout.offset(self.notificationInsets.right),
                self.view.bottomLayout == notificationView.bottomLayout.offset(self.notificationInsets.bottom)
            ]
        case .trailing:
            self._notificationConstraints = [
                self.view.leadingLayout <= notificationView.leadingLayout.offset(-self.notificationInsets.left),
                self.view.trailingLayout == notificationView.trailingLayout.offset(self.notificationInsets.right),
                self.view.bottomLayout == notificationView.bottomLayout.offset(self.notificationInsets.bottom)
            ]
        }
    }

    func _triggeredNotificationTimer() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self._notificationView?.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self._notificationView = nil
            self._notificationTimer = nil
            self._notificationConstraints = []
        })
    }
    
    func _appendBackgroundController(_ viewController: IQViewController) {
        viewController.view.frame = self.view.bounds
        self.view.insertSubview(viewController.view, at: 0)
    }

    func _appendContentController(_ viewController: IQViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.backgroundViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.modalContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else if let vc = self.dialogContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else if let vc = self.pushContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    func _appendModalContainer(_ viewController: IQModalContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.contentViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.backgroundViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.dialogContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else if let vc = self.pushContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    func _appendDialogContainer(_ viewController: IQDialogContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.modalContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.contentViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.backgroundViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.pushContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, belowSubview: vc.view)
        } else {
            self.view.addSubview(viewController.view)
        }
    }
    
    func _appendPushContainer(_ viewController: IQPushContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.dialogContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.modalContainerViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.contentViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else if let vc = self.backgroundViewController, vc.view.superview == self.view {
            self.view.insertSubview(viewController.view, aboveSubview: vc.view)
        } else {
            self.view.addSubview(viewController.view)
        }
    }

}
