//
//  Quickly
//

open class QInputViewController : QViewController, IQInputViewController {
    
    open var toolbar: QToolbar?
    open private(set) var viewController: IQInputContentViewController
    open var height: CGFloat
    
    public init(
        toolbar: QToolbar? = nil,
        viewController: IQInputContentViewController,
        height: CGFloat = 300
    ) {
        self.toolbar = toolbar
        self.viewController = viewController
        self.height = height
        super.init()
    }
    
    open override func setup() {
        super.setup()
        
        self.edgesForExtendedLayout = [ .left, .right, .bottom ]
        self.viewController.parentViewController = self
    }
    
    open override func didLoad() {
        self.view.frame = self._frame()
        self.viewController.view.frame = self.view.bounds
        self.view.addSubview(self.viewController.view)
    }
    
    open override func layout(bounds: CGRect) {
        self.viewController.view.frame = bounds
    }
    
    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if self.isLoaded == true {
            self.view.frame = self._frame()
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
    
    open func updateContent() {
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
    
}

private extension QInputViewController {
    
    func _frame() -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: edgeInsets.top + self.height + edgeInsets.bottom)
    }
    
}
