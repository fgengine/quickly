//
//  Quickly
//

open class QPageViewController : QViewController, IQPageViewController {
    
    open private(set) var pageContentViewController: IQPageContentViewController
    open var pageItem: QPagebarItem?
    open var pageForwardAnimation: IQPageViewControllerAnimation?
    open var pageBackwardAnimation: IQPageViewControllerAnimation?
    open var pageInteractiveAnimation: IQPageViewControllerInteractiveAnimation?

    public init(_ contentViewController: IQPageContentViewController) {
        self.pageContentViewController = contentViewController
        super.init()
    }

    public init(_ pagebarItem: QPagebarItem?, _ contentViewController: IQPageContentViewController) {
        self.pageItem = pagebarItem
        self.pageContentViewController = contentViewController
        super.init()
    }

    open override func setup() {
        super.setup()

        self.pageContentViewController.parent = self
    }

    open override func didLoad() {
        self.pageContentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.pageContentViewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.pageContentViewController.view.frame = bounds
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.pageContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.pageContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.pageContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.pageContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.pageContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.pageContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.pageContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.pageContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.pageContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.pageContentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.pageContentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.pageContentViewController.didTransition(size: size)
    }

    open func setPageItem(_ item: QPagebarItem?, animated: Bool) {
        self.pageItem = item
        if let vc = self.pageContainerViewController {
            vc.updatePageItem(self, animated: animated)
        }
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.pageContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.pageContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.pageContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.pageContentViewController.preferedStatusBarAnimation()
    }

}
