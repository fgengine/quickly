//
//  Quickly
//

open class QStackViewController : QViewController, IQStackViewController {

    open var barView: QStackbar? {
        set(value) { self.set(barView: value) }
        get { return self._barView }
    }
    open var barHeight: CGFloat {
        set(value) { self.set(barHeight: value) }
        get { return self._barHeight }
    }
    open var barHidden: Bool {
        set(value) { self.set(barHidden: value) }
        get { return self._barHidden }
    }
    open private(set) var contentViewController: IQStackContentViewController
    open var presentAnimation: IQStackViewControllerPresentAnimation?
    open var dismissAnimation: IQStackViewControllerDismissAnimation?
    open var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?
    
    private var _barView: QStackbar?
    private var _barHeight: CGFloat
    private var _barHidden: Bool

    public init(_ contentViewController: IQStackContentViewController) {
        self._barHeight = 50
        self._barHidden = false
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

        if let stackbar = self._barView {
            self.view.addSubview(stackbar)
        }
    }

    open override func layout(bounds: CGRect) {
        self.contentViewController.view.frame = bounds
        if let stackbar = self._barView {
            stackbar.edgeInsets = self._barEdgeInsets()
            stackbar.frame = self._barFrame(bounds: bounds)
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

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.contentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.contentViewController.didTransition(size: size)
    }

    open func set(barView: QStackbar?, animated: Bool = false) {
        if self.isLoaded == true {
            if let view = self._barView {
                view.removeFromSuperview()
            }
            self._barView = barView
            if let view = self._barView {
                view.frame = self._barFrame(bounds: self.view.bounds)
                view.edgeInsets = self._barEdgeInsets()
                self.view.insertSubview(view, aboveSubview: self.contentViewController.view)
            }
            self.setNeedLayout()
        } else {
            self._barView = barView
        }
        self._updateAdditionalEdgeInsets()
    }

    open func set(barHeight: CGFloat, animated: Bool = false) {
        self._barHeight = barHeight
        self.setNeedLayout()
        self._updateAdditionalEdgeInsets()
        if self.isLoaded == true {
            if animated == true {
                UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }

    open func set(barHidden: Bool, animated: Bool = false) {
        self._barHidden = barHidden
        self.setNeedLayout()
        self._updateAdditionalEdgeInsets()
        if self.isLoaded == true {
            if animated == true {
                UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.layoutIfNeeded()
                })
            }
        }
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
    
}

extension QStackViewController {

    private func _updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: (self._barView != nil && self._barHidden == false) ? self._barHeight : 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }

    private func _barFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self._barHeight + edgeInsets.top
        if self._barHidden == true {
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

    private func _barEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

}
