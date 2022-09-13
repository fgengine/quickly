//
//  Quickly
//

import UIKit

open class QPageViewController : QViewController, IQPageViewController {
    
    open private(set) var viewController: IQPageContentViewController
    open var item: QPagebarItem? {
        set(value) { self.setItem(value) }
        get { return self._item }
    }
    open var forwardAnimation: IQPageViewControllerAnimation?
    open var backwardAnimation: IQPageViewControllerAnimation?
    open var interactiveAnimation: IQPageViewControllerInteractiveAnimation?
    
    private var _item: QPagebarItem?

    public init(viewController: IQPageContentViewController) {
        self.viewController = viewController
        super.init()
    }

    public init(
        item: QPagebarItem?,
        viewController: IQPageContentViewController,
        forwardAnimation: IQPageViewControllerAnimation? = nil,
        backwardAnimation: IQPageViewControllerAnimation? = nil,
        interactiveAnimation: IQPageViewControllerInteractiveAnimation? = nil
    ) {
        self._item = item
        self.viewController = viewController
        self.forwardAnimation = forwardAnimation
        self.backwardAnimation = backwardAnimation
        self.interactiveAnimation = interactiveAnimation
        super.init()
    }

    open override func setup() {
        super.setup()

        self.viewController.parentViewController = self
    }

    open override func didLoad() {
        self.viewController.view.frame = self.view.bounds
        self.view.addSubview(self.viewController.view)
    }

    open override func layout(bounds: CGRect) {
        self.viewController.view.frame = bounds
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
    
    open func setItem(_ item: QPagebarItem?, animated: Bool = false) {
        if self._item !== item {
            self._item = item
            if let vc = self.containerViewController {
                vc.didUpdate(viewController: self, animated: animated)
            }
        }
    }
    
    // MARK: IQContentOwnderViewController
    
    open func beginUpdateContent() {
    }
    
    open func updateContent() {
    }
    
    open func finishUpdateContent(velocity: CGPoint) -> CGPoint? {
        return nil
    }
    
    open func endUpdateContent() {
    }

}
