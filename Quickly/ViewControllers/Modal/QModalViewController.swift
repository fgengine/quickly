//
//  Quickly
//

open class QModalViewController : QViewController, IQModalViewController {

    open private(set) var modalContentViewController: IQModalContentViewController
    open var modalPresentAnimation: IQModalViewControllerFixedAnimation?
    open var modalDismissAnimation: IQModalViewControllerFixedAnimation?
    open var modalInteractiveDismissAnimation: IQModalViewControllerInteractiveAnimation?

    public init(_ contentViewController: IQModalContentViewController) {
        self.modalContentViewController = contentViewController
        super.init()
    }

    open override func setup() {
        super.setup()

        self.modalContentViewController.parent = self
    }

    open override func didLoad() {
        self.modalContentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.modalContentViewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.modalContentViewController.view.frame = bounds
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.modalContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.modalContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.modalContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.modalContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.modalContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.modalContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.modalContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.modalContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.modalContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.modalContentViewController.didDismiss(animated: animated)
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.modalContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.modalContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.modalContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.modalContentViewController.preferedStatusBarAnimation()
    }

}
