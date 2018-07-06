//
//  Quickly
//

open class QStackViewController : QViewController, IQStackViewController {

    open weak var stackContainerViewController: IQStackContainerViewController?
    open private(set) var stackbar: QStackbar?
    open private(set) var stackbarHeight: CGFloat
    open private(set) var stackbarHidden: Bool
    open private(set) var stackContentViewController: IQStackContentViewController
    open var stackPresentAnimation: IQStackViewControllerPresentAnimation?
    open var stackDismissAnimation: IQStackViewControllerDismissAnimation?
    open var stackInteractiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?

    public init(_ contentViewController: IQStackContentViewController) {
        self.stackbarHeight = 50
        self.stackbarHidden = false
        self.stackContentViewController = contentViewController
        super.init()
    }

    open override func setup() {
        super.setup()

        self.stackContentViewController.parent = self
    }

    open override func didLoad() {
        self._updateAdditionalEdgeInsets()

        self.stackContentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.stackContentViewController.view)

        if let stackbar = self.stackbar {
            self.view.addSubview(stackbar)
        }
    }

    open override func layout(bounds: CGRect) {
        self.stackContentViewController.view.frame = bounds
        if let stackbar = self.stackbar {
            stackbar.edgeInsets = self._stackbarEdgeInsets()
            stackbar.frame = self._stackbarFrame(bounds: bounds)
        }
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.stackContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.stackContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.stackContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.stackContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.stackContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.stackContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.stackContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.stackContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.stackContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.stackContentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.stackContentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.stackContentViewController.didTransition(size: size)
    }

    open func setStackbar(_ stackbar: QStackbar?, animated: Bool = false) {
        if self.isLoaded == true {
            if let stackbar = self.stackbar {
                stackbar.removeFromSuperview()
            }
            self.stackbar = stackbar
            if let stackbar = self.stackbar {
                stackbar.frame = self._stackbarFrame(bounds: self.view.bounds)
                stackbar.edgeInsets = self._stackbarEdgeInsets()
                self.view.insertSubview(stackbar, aboveSubview: self.stackContentViewController.view)
            }
            self.setNeedLayout()
        } else {
            self.stackbar = stackbar
        }
        self._updateAdditionalEdgeInsets()
    }

    open func setStackbarHeight(_ value: CGFloat, animated: Bool = false) {
    }

    open func setStackbarHidden(_ value: Bool, animated: Bool = false) {
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.stackContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.stackContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.stackContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.stackContentViewController.preferedStatusBarAnimation()
    }

    private func _updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: (self.stackbar != nil && self.stackbarHidden == false) ? self.stackbarHeight : 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }

    private func _stackbarFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self.stackbarHeight + edgeInsets.top
        if self.stackbarHidden == true {
            return CGRect(
                x: bounds.origin.x,
                y: bounds.origin.y - fullHeight,
                width: bounds.size.width,
                height: fullHeight
            )
        }
        return CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width,
            height: fullHeight
        )
    }

    private func _stackbarEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

}
