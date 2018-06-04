//
//  Quickly
//

open class QPageSlideViewController : QViewController, IQPageSlideViewController {
    
    open private(set) var contentViewController: IQPageContentViewController
    open var pagebarItem: QPagebarItem?
    open var forwardAnimation: IQPageViewControllerAnimation?
    open var backwardAnimation: IQPageViewControllerAnimation?
    open var interactiveAnimation: IQPageViewControllerInteractiveAnimation?

    public init(pagebarItem: QPagebarItem? = nil, contentViewController: IQPageContentViewController) {
        self.pagebarItem = pagebarItem
        self.contentViewController = contentViewController
        super.init()
    }

    open override func setup() {
        super.setup()

        self.contentViewController.parent = self
    }

    open override func didLoad() {
        self.contentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.contentViewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.contentViewController.view.frame = bounds
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

    open func setPagebarItem(_ item: QPagebarItem?, animated: Bool) {
        self.pagebarItem = item
        if let vc = self.pageViewController {
            vc.updatePagebarItem(self, animated: animated)
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
