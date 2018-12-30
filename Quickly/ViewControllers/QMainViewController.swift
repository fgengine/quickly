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
            vc.parent = nil
        }
        didSet {
            guard let vc = self.backgroundViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self._appendBackgroundController(vc)
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
            vc.parent = nil
        }
        didSet {
            guard let vc = self.contentViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self._appendContentController(vc)
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
            vc.parent = nil
        }
        didSet {
            guard let vc = self.modalContainerViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self._appendModalContainer(vc)
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
            vc.parent = nil
        }
        didSet {
            guard let vc = self.pushContainerViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self._appendPushContainer(vc)
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
            vc.parent = nil
        }
        didSet {
            guard let vc = self.dialogContainerViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self._appendDialogContainer(vc)
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
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
        if let vc = self.pushContainerViewController {
            self._appendPushContainer(vc)
        }
        if let vc = self.dialogContainerViewController {
            self._appendDialogContainer(vc)
        }
    }

    open override func layout(bounds: CGRect) {
        if let vc = self.backgroundViewController {
            vc.view.frame = bounds
        }
        if let vc = self.contentViewController {
            vc.view.frame = bounds
        }
        if let vc = self.modalContainerViewController {
            vc.view.frame = bounds
        }
        if let vc = self.pushContainerViewController {
            vc.view.frame = bounds
        }
        if let vc = self.dialogContainerViewController {
            vc.view.frame = bounds
        }
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        if let vc = self.backgroundViewController {
            vc.prepareInteractivePresent()
        }
        if let vc = self.contentViewController {
            vc.prepareInteractivePresent()
        }
        if let vc = self.modalContainerViewController {
            vc.prepareInteractivePresent()
        }
        if let vc = self.pushContainerViewController {
            vc.prepareInteractivePresent()
        }
        if let vc = self.dialogContainerViewController {
            vc.prepareInteractivePresent()
        }
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        if let vc = self.backgroundViewController {
            vc.cancelInteractivePresent()
        }
        if let vc = self.contentViewController {
            vc.cancelInteractivePresent()
        }
        if let vc = self.modalContainerViewController {
            vc.cancelInteractivePresent()
        }
        if let vc = self.pushContainerViewController {
            vc.cancelInteractivePresent()
        }
        if let vc = self.dialogContainerViewController {
            vc.cancelInteractivePresent()
        }
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        if let vc = self.backgroundViewController {
            vc.finishInteractivePresent()
        }
        if let vc = self.contentViewController {
            vc.finishInteractivePresent()
        }
        if let vc = self.modalContainerViewController {
            vc.finishInteractivePresent()
        }
        if let vc = self.pushContainerViewController {
            vc.finishInteractivePresent()
        }
        if let vc = self.dialogContainerViewController {
            vc.finishInteractivePresent()
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        if let vc = self.backgroundViewController {
            vc.willPresent(animated: animated)
        }
        if let vc = self.contentViewController {
            vc.willPresent(animated: animated)
        }
        if let vc = self.modalContainerViewController {
            vc.willPresent(animated: animated)
        }
        if let vc = self.pushContainerViewController {
            vc.willPresent(animated: animated)
        }
        if let vc = self.dialogContainerViewController {
            vc.willPresent(animated: animated)
        }
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        if let vc = self.backgroundViewController {
            vc.didPresent(animated: animated)
        }
        if let vc = self.contentViewController {
            vc.didPresent(animated: animated)
        }
        if let vc = self.modalContainerViewController {
            vc.didPresent(animated: animated)
        }
        if let vc = self.pushContainerViewController {
            vc.didPresent(animated: animated)
        }
        if let vc = self.dialogContainerViewController {
            vc.didPresent(animated: animated)
        }
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        if let vc = self.backgroundViewController {
            vc.prepareInteractiveDismiss()
        }
        if let vc = self.contentViewController {
            vc.prepareInteractiveDismiss()
        }
        if let vc = self.modalContainerViewController {
            vc.prepareInteractiveDismiss()
        }
        if let vc = self.pushContainerViewController {
            vc.prepareInteractiveDismiss()
        }
        if let vc = self.dialogContainerViewController {
            vc.prepareInteractiveDismiss()
        }
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        if let vc = self.backgroundViewController {
            vc.cancelInteractiveDismiss()
        }
        if let vc = self.contentViewController {
            vc.cancelInteractiveDismiss()
        }
        if let vc = self.modalContainerViewController {
            vc.cancelInteractiveDismiss()
        }
        if let vc = self.pushContainerViewController {
            vc.cancelInteractiveDismiss()
        }
        if let vc = self.dialogContainerViewController {
            vc.cancelInteractiveDismiss()
        }
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        if let vc = self.backgroundViewController {
            vc.finishInteractiveDismiss()
        }
        if let vc = self.contentViewController {
            vc.finishInteractiveDismiss()
        }
        if let vc = self.modalContainerViewController {
            vc.finishInteractiveDismiss()
        }
        if let vc = self.pushContainerViewController {
            vc.finishInteractiveDismiss()
        }
        if let vc = self.dialogContainerViewController {
            vc.finishInteractiveDismiss()
        }
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        if let vc = self.backgroundViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc = self.contentViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc = self.modalContainerViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc = self.pushContainerViewController {
            vc.willDismiss(animated: animated)
        }
        if let vc = self.dialogContainerViewController {
            vc.willDismiss(animated: animated)
        }
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        if let vc = self.backgroundViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc = self.contentViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc = self.modalContainerViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc = self.pushContainerViewController {
            vc.didDismiss(animated: animated)
        }
        if let vc = self.dialogContainerViewController {
            vc.didDismiss(animated: animated)
        }
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let vc = self.backgroundViewController {
            vc.willTransition(size: size)
        }
        if let vc = self.contentViewController {
            vc.willTransition(size: size)
        }
        if let vc = self.modalContainerViewController {
            vc.willTransition(size: size)
        }
        if let vc = self.pushContainerViewController {
            vc.willTransition(size: size)
        }
        if let vc = self.dialogContainerViewController {
            vc.willTransition(size: size)
        }
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        if let vc = self.backgroundViewController {
            vc.didTransition(size: size)
        }
        if let vc = self.contentViewController {
            vc.didTransition(size: size)
        }
        if let vc = self.modalContainerViewController {
            vc.didTransition(size: size)
        }
        if let vc = self.pushContainerViewController {
            vc.didTransition(size: size)
        }
        if let vc = self.dialogContainerViewController {
            vc.didTransition(size: size)
        }
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        guard let cvc = self.contentViewController else { return super.supportedOrientations() }
        return cvc.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        guard let cvc = self.contentViewController else { return super.preferedStatusBarHidden() }
        guard let cdvc = self.dialogContainerViewController?.currentViewController else { return cvc.preferedStatusBarHidden() }
        return cdvc.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        guard let cvc = self.contentViewController else { return super.preferedStatusBarStyle() }
        guard let cdvc = self.dialogContainerViewController?.currentViewController else { return cvc.preferedStatusBarStyle() }
        return cdvc.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        guard let cvc = self.contentViewController else { return super.preferedStatusBarAnimation() }
        guard let cdvc = self.dialogContainerViewController?.currentViewController else { return cvc.preferedStatusBarAnimation() }
        return cdvc.preferedStatusBarAnimation()
    }

    private func _appendBackgroundController(_ viewController: IQViewController) {
        viewController.view.frame = self.view.bounds
        self.view.insertSubview(viewController.view, at: 0)
    }

    private func _appendContentController(_ viewController: IQViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.dialogContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.pushContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.modalContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.backgroundViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _appendModalContainer(_ viewController: IQModalContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.dialogContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.pushContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.contentViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.backgroundViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _appendPushContainer(_ viewController: IQPushContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.dialogContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.modalContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.contentViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.backgroundViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else {
            self.view.addSubview(viewController.view)
        }
    }

    private func _appendDialogContainer(_ viewController: IQDialogContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.pushContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, belowSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.modalContainerViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.contentViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else if let vc = self.backgroundViewController {
            if vc.view.superview == self.view {
                self.view.insertSubview(viewController.view, aboveSubview: vc.view)
            } else {
                self.view.addSubview(viewController.view)
            }
        } else {
            self.view.addSubview(viewController.view)
        }
    }

}
