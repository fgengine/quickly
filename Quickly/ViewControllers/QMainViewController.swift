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
            }
            vc.parent = nil
        }
        didSet {
            guard let vc = self.backgroundViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self.appendBackgroundController(vc)
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
            }
            vc.parent = nil
        }
        didSet {
            guard let vc = self.contentViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self.appendContentController(vc)
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
            }
            vc.parent = nil
        }
        didSet {
            guard let vc = self.pushContainerViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self.appendPushContainer(vc)
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
            }
            vc.parent = nil
        }
        didSet {
            guard let vc = self.dialogContainerViewController else { return }
            vc.parent = self
            if self.isLoaded == true {
                self.appendDialogContainer(vc)
                vc.willPresent(animated: false)
                vc.didPresent(animated: false)
            }
        }
    }

    open override func didLoad() {
        if let vc = self.backgroundViewController {
            self.appendBackgroundController(vc)
        }
        if let vc = self.contentViewController {
            self.appendContentController(vc)
        }
        if let vc = self.pushContainerViewController {
            self.appendPushContainer(vc)
        }
        if let vc = self.dialogContainerViewController {
            self.appendDialogContainer(vc)
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

    private func appendBackgroundController(_ viewController: IQViewController) {
        viewController.view.frame = self.view.bounds
        self.view.insertSubview(viewController.view, at: 0)
    }

    private func appendContentController(_ viewController: IQViewController) {
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

    private func appendPushContainer(_ viewController: IQPushContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.dialogContainerViewController {
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

    private func appendDialogContainer(_ viewController: IQDialogContainerViewController) {
        viewController.view.frame = self.view.bounds
        if let vc = self.pushContainerViewController {
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

}
