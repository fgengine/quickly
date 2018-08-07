//
//  Quickly
//

public protocol IQViewControllerDelegate : class {

    func requestUpdateStatusBar(viewController: IQViewController)

}

public protocol IQViewController : class {

    typealias ViewType = UIView & IQViewControllerView

    var delegate: IQViewControllerDelegate? { set get }
    var parent: IQViewController? { set get }
    var child: [IQViewController] { get }
    var edgesForExtendedLayout: UIRectEdge { set get }
    var additionalEdgeInsets: UIEdgeInsets { set get }
    var inheritedEdgeInsets: UIEdgeInsets { get }
    var adjustedContentInset: UIEdgeInsets { get }
    var view: ViewType { get }
    var isLoaded: Bool { get }
    var isPresented: Bool { get }

    func setup()

    func load() -> ViewType

    func loadViewIfNeeded()
    func didLoad()

    func setNeedLayout()
    func layoutIfNeeded()
    func layout(bounds: CGRect)

    func didChangeAdditionalEdgeInsets()

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

    func parentOf< ParentType >() -> ParentType?

    func addChild(_ viewController: IQViewController)
    func removeChild(_ viewController: IQViewController)

    func supportedOrientations() -> UIInterfaceOrientationMask

    func preferedStatusBarHidden() -> Bool
    func preferedStatusBarStyle() -> UIStatusBarStyle
    func preferedStatusBarAnimation() -> UIStatusBarAnimation
    func setNeedUpdateStatusBar()

}

public protocol IQViewControllerView : IQView {

    var viewController: IQViewController? { get }

}
