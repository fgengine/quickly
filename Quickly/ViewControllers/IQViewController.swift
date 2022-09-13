//
//  Quickly
//

import UIKit

public protocol IQViewControllerDelegate : AnyObject {

    func requestUpdateStatusBar(viewController: IQViewController)
    func requestUpdateOrientation(viewController: IQViewController)

}

public protocol IQViewController : AnyObject {

    var delegate: IQViewControllerDelegate? { set get }
    var parentViewController: IQViewController? { set get }
    var childViewControllers: [IQViewController] { get }
    var edgesForExtendedLayout: UIRectEdge { set get }
    var additionalEdgeInsets: UIEdgeInsets { set get }
    var inheritedEdgeInsets: UIEdgeInsets { get }
    var adjustedContentInset: UIEdgeInsets { get }
    var view: QDisplayView { get }
    var isLoading: Bool { get }
    var isLoaded: Bool { get }
    var isPresented: Bool { get }

    func setup()

    func loadViewIfNeeded()
    func didLoad()

    func setNeedLayout()
    func layoutIfNeeded()
    func layout(bounds: CGRect)

    func didChangeContentEdgeInsets()

    func prepareInteractivePresent()
    func cancelInteractivePresent()
    func finishInteractivePresent()

    func willPresent(animated: Bool)
    func didPresent(animated: Bool)

    func prepareInteractiveDismiss()
    func cancelInteractiveDismiss()
    func finishInteractiveDismiss()

    func willDismiss(animated: Bool)
    func didDismiss(animated: Bool)

    func willTransition(size: CGSize)
    func didTransition(size: CGSize)

    func parentViewControllerOf< ParentType >() -> ParentType?

    func add(childViewController viewController: IQViewController)
    func remove(childViewController viewController: IQViewController)

    func supportedOrientations() -> UIInterfaceOrientationMask
    func setNeedUpdateOrientations()

    func preferedStatusBarHidden() -> Bool
    func preferedStatusBarStyle() -> UIStatusBarStyle
    func preferedStatusBarAnimation() -> UIStatusBarAnimation
    func setNeedUpdateStatusBar()
    
    func snapshot() -> UIImage?

}

public extension IQViewController {
    
    var rootViewController: IQViewController? {
        get {
            var vc: IQViewController = self
            while vc.parentViewController != nil {
                vc = vc.parentViewController!
            }
            return vc
        }
    }
    
}
