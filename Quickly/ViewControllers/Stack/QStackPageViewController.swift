//
//  Quickly
//

open class QStackPageViewController : QViewController, IQStackPageViewController {

    open weak var stackViewController: IQStackViewController?
    open private(set) var stackbar: QStackbar?
    open private(set) var stackbarHeight: CGFloat {
        didSet {
            self._updateAdditionalEdgeInsets()
            self.setNeedLayout()
        }
    }
    open private(set) var stackbarHidden: Bool
    open private(set) var contentViewController: IQStackContentViewController
    open var presentAnimation: IQStackViewControllerPresentAnimation?
    open var dismissAnimation: IQStackViewControllerDismissAnimation?
    open var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?

    public init(contentViewController: IQStackContentViewController) {
        self.stackbarHeight = 50
        self.stackbarHidden = false
        self.contentViewController = contentViewController
        super.init()
    }

    open override func setup() {
        super.setup()

        self.contentViewController.parent = self
    }

    open override func didLoad() {
        self._updateAdditionalEdgeInsets()

        self.contentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.contentViewController.view)

        if let stackbar = self.stackbar {
            self.view.addSubview(stackbar)
        }
    }

    open override func layout(bounds: CGRect) {
        self.contentViewController.view.frame = bounds
        if let stackbar = self.stackbar {
            stackbar.edgeInsets = self._stackbarEdgeInsets()
            stackbar.frame = self._stackbarFrame(bounds: bounds)
        }
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.contentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.contentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.contentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.contentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.contentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.contentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.contentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.contentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.contentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.contentViewController.didDismiss(animated: animated)
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
                self.view.insertSubview(stackbar, aboveSubview: self.contentViewController.view)
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
        return self.contentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.contentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.contentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.contentViewController.preferedStatusBarAnimation()
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
