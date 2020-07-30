//
//  Quickly
//

open class QStackViewController : QViewController, IQStackViewController, IQModalContentViewController, IQHamburgerContentViewController, IQJalousieContentViewController {

    open var barView: QStackbar? {
        set(value) { self.set(barView: value) }
        get { return self._barView }
    }
    open var barSize: QStackViewControllerBarSize {
        set(value) { self.set(barSize: value) }
        get { return self._barSize }
    }
    open var barHidden: Bool {
        set(value) { self.set(barHidden: value) }
        get { return self._barHidden }
    }
    open private(set) var viewController: IQStackContentViewController
    open var presentAnimation: IQStackViewControllerPresentAnimation?
    open var dismissAnimation: IQStackViewControllerDismissAnimation?
    open var interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation?
    
    private var _barView: QStackbar?
    private var _barSize: QStackViewControllerBarSize
    private var _barHidden: Bool

    public init(
        barSize: QStackViewControllerBarSize = .fixed(height: 50),
        barHidden: Bool = false,
        viewController: IQStackContentViewController,
        presentAnimation: IQStackViewControllerPresentAnimation? = nil,
        dismissAnimation: IQStackViewControllerDismissAnimation? = nil,
        interactiveDismissAnimation: IQStackViewControllerInteractiveDismissAnimation? = nil
    ) {
        self._barSize = barSize
        self._barHidden = false
        self.viewController = viewController
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.interactiveDismissAnimation = interactiveDismissAnimation
        super.init()
    }

    open override func setup() {
        super.setup()

        self.viewController.parentViewController = self
    }

    open override func didLoad() {
        self._updateAdditionalEdgeInsets()

        self.viewController.view.frame = self.view.bounds
        self.view.addSubview(self.viewController.view)

        if let barView = self._barView {
            barView.edgeInsets = self._barEdgeInsets()
            barView.frame = self._barFrame(bounds: self.view.bounds)
            self.view.addSubview(barView)
        }
    }

    open override func layout(bounds: CGRect) {
        self.viewController.view.frame = bounds
        if let barView = self._barView {
            barView.edgeInsets = self._barEdgeInsets()
            barView.frame = self._barFrame(bounds: bounds)
        }
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.viewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.viewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.viewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.viewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.viewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.viewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.viewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.viewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.viewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.viewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.viewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.viewController.didTransition(size: size)
    }
    
    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.viewController.supportedOrientations()
    }
    
    open override func preferedStatusBarHidden() -> Bool {
        return self.viewController.preferedStatusBarHidden()
    }
    
    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.viewController.preferedStatusBarStyle()
    }
    
    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.viewController.preferedStatusBarAnimation()
    }

    open func set(barView: QStackbar?, animated: Bool = false) {
        if self._barView != barView {
            if self.isLoaded == true && self.isLoading == false {
                if let view = self._barView {
                    view.removeFromSuperview()
                }
                self._barView = barView
                if let view = self._barView {
                    view.frame = self._barFrame(bounds: self.view.bounds)
                    view.edgeInsets = self._barEdgeInsets()
                    self.view.insertSubview(view, aboveSubview: self.viewController.view)
                }
                self.setNeedLayout()
            } else {
                self._barView = barView
            }
            self._updateAdditionalEdgeInsets()
        }
    }

    open func set(barSize: QStackViewControllerBarSize, animated: Bool = false) {
        if self._barSize != barSize {
            self._barSize = barSize
            self._updateAdditionalEdgeInsets()
            if self.isLoaded == true && self.isLoading == false {
                self.setNeedLayout()
                if animated == true {
                    UIView.animate(withDuration: 0.1, delay: 0, options: [ .beginFromCurrentState ], animations: {
                        self.layoutIfNeeded()
                    })
                }
            }
        }
    }

    open func set(barHidden: Bool, animated: Bool = false) {
        if self._barHidden != barHidden {
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
    }
    
    // MARK: IQContentOwnerViewController
    
    open func beginUpdateContent() {
    }
    
    open func updateContent() {
        if let view = self._barView {
            view.frame = self._barFrame(bounds: self.view.bounds)
        }
    }
    
    open func finishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if self._barHidden == true {
            return nil
        }
        switch self._barSize {
        case .fixed(_):
            return nil
        case .range(let minHeight, let maxHeight):
            let edgeInsets = self.inheritedEdgeInsets
            let contentOffset = self.viewController.contentOffset
            let interactiveBarHeight = maxHeight - contentOffset.y
            let normalizedBarHeight = max(minHeight, min(interactiveBarHeight, maxHeight)) + edgeInsets.top
            let minimalBarHeight = minHeight + edgeInsets.top
            let maximalBarHeight = maxHeight + edgeInsets.top
            if (normalizedBarHeight > minimalBarHeight) && (normalizedBarHeight < maximalBarHeight) {
                let middleBarHeight = minimalBarHeight + ((maximalBarHeight - minimalBarHeight) / 2)
                return CGPoint(
                    x: contentOffset.x,
                    y: normalizedBarHeight > middleBarHeight ? -maximalBarHeight : -minimalBarHeight
                )
            }
            return nil
        }
    }
    
    open func endUpdateContent() {
        if let view = self._barView {
            view.frame = self._barFrame(bounds: self.view.bounds)
        }
    }
    
    // MARK: IQContentViewController
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }
    
    open func notifyBeginUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.beginUpdateContent()
        }
    }
    
    open func notifyUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if let viewController = self.contentOwnerViewController {
            return viewController.finishUpdateContent(velocity: velocity)
        }
        return nil
    }
    
    open func notifyEndUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.endUpdateContent()
        }
    }
    
    // MARK: IQModalContentViewController
    
    open func modalShouldInteractive() -> Bool {
        guard let currentViewController = self.viewController as? IQModalContentViewController else { return false }
        return currentViewController.modalShouldInteractive()
    }
    
    // MARK: IQHamburgerContentViewController
    
    open func hamburgerShouldInteractive() -> Bool {
        guard let currentViewController = self.viewController as? IQHamburgerContentViewController else { return false }
        return currentViewController.hamburgerShouldInteractive()
    }
    
    // MARK: IQJalousieContentViewController
    
    open func jalousieShouldInteractive() -> Bool {
        guard let currentViewController = self.viewController as? IQJalousieContentViewController else { return false }
        return currentViewController.jalousieShouldInteractive()
    }
    
}

// MARK: Private

private extension QStackViewController {

    func _updateAdditionalEdgeInsets() {
        guard self._barView != nil && self._barHidden == false else {
            self.additionalEdgeInsets = UIEdgeInsets.zero
            return
        }
        switch self._barSize {
        case .fixed(let height):
            self.additionalEdgeInsets = UIEdgeInsets(
                top: height,
                left: 0,
                bottom: 0,
                right: 0
            )
        case .range(_, let max):
            self.additionalEdgeInsets = UIEdgeInsets(
                top: max,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
    }

    func _barFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        var barHeight: CGFloat
        switch self._barSize {
        case .fixed(let height):
            barHeight = height + edgeInsets.top
        case .range(let minHeight, let maxHeight):
            let contentOffset = self.viewController.contentOffset
            let interactiveBarHeight = maxHeight - contentOffset.y
            barHeight = max(minHeight, min(interactiveBarHeight, maxHeight)) + edgeInsets.top
        }
        if self._barHidden == true {
            return CGRect(x: bounds.origin.x, y: bounds.origin.y - barHeight, width: bounds.size.width, height: barHeight)
        }
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: barHeight)
    }

    func _barEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

}
