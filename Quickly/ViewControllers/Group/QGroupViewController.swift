//
//  Quickly
//

open class QGroupViewController : QViewController, IQGroupViewController {
    
    open private(set) var groupContentViewController: IQGroupContentViewController
    open var groupbarItem: QGroupbarItem? {
        set(value) { self.setGroupItem(value) }
        get { return self._groupItem }
    }
    open var groupAnimation: IQGroupViewControllerAnimation?
    
    private var _groupItem: QGroupbarItem?

    public init(_ contentViewController: IQGroupContentViewController, _ groupbarItem: QGroupbarItem? = nil) {
        self.groupContentViewController = contentViewController
        self._groupItem = groupbarItem
        super.init()
    }

    open override func setup() {
        super.setup()

        self.groupContentViewController.parent = self
    }

    open override func didLoad() {
        self.groupContentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.groupContentViewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.groupContentViewController.view.frame = bounds
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.groupContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.groupContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.groupContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.groupContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.groupContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.groupContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.groupContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.groupContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.groupContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.groupContentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.groupContentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.groupContentViewController.didTransition(size: size)
    }

    open func setGroupItem(_ item: QGroupbarItem?, animated: Bool = false) {
        if self._groupItem !== item {
            self._groupItem = item
            if let vc = self.groupContainerViewController {
                vc.updateGroupItem(self, animated: animated)
            }
        }
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.groupContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.groupContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.groupContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.groupContentViewController.preferedStatusBarAnimation()
    }

}
