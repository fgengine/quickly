//
//  Quickly
//

public enum QDialogViewControllerSizeBehaviour {
    case fit(min: CGFloat, max: CGFloat)
    case fill(before: CGFloat, after: CGFloat)
}

public enum QDialogViewControllerVerticalAlignment {
    case top(offset: CGFloat)
    case center(offset: CGFloat)
    case bottom(offset: CGFloat)

    public var offset: CGFloat {
        get {
            switch self {
            case .top(let offset): return offset
            case .center(let offset): return offset
            case .bottom(let offset): return offset
            }
        }
    }
}

public enum QDialogViewControllerHorizontalAlignment {
    case left(offset: CGFloat)
    case center(offset: CGFloat)
    case right(offset: CGFloat)

    public var offset: CGFloat {
        get {
            switch self {
            case .left(let offset): return offset
            case .center(let offset): return offset
            case .right(let offset): return offset
            }
        }
    }
}

public protocol IQDialogViewControllerFixedAnimation : IQFixedAnimation {

    typealias ViewControllerType = QPlatformViewController & IQDialogViewController

    func prepare(viewController: ViewControllerType)

}

public protocol IQDialogViewControllerInteractiveAnimation : IQInteractiveAnimation {

    typealias ViewControllerType = QPlatformViewController & IQDialogViewController

    func prepare(viewController: ViewControllerType, position: CGPoint, velocity: CGPoint)

}

public protocol IQDialogViewController : IQBaseViewController {

    typealias ContainerViewControllerType = QPlatformViewController & IQDialogContainerViewController
    typealias ContentViewControllerType = QPlatformViewController & IQDialogContentViewController

    weak var containerViewController: ContainerViewControllerType? { set get }

    var contentViewController: ContentViewControllerType { set get }
    var widthBehaviour: QDialogViewControllerSizeBehaviour { set get }
    var heightBehaviour: QDialogViewControllerSizeBehaviour { set get }
    var verticalAlignment: QDialogViewControllerVerticalAlignment { set get }
    var horizontalAlignment: QDialogViewControllerHorizontalAlignment { set get }
    var presentAnimation: IQDialogViewControllerFixedAnimation? { get }
    var dismissAnimation: IQDialogViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation? { get }

    func dismissDialog(animated: Bool, completion: (() -> Swift.Void)?)

}

public protocol IQDialogContentViewController : IQBaseViewController {

    typealias DialogViewControllerType = QPlatformViewController & IQDialogViewController

    weak var dialogViewController: DialogViewControllerType? { set get }

    func didPressedOutsideContent()

}

public extension IQDialogViewController where Self : QPlatformViewController {

    public func dismissDialog(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let containerViewController: IQDialogContainerViewController = self.containerViewController else {
            return
        }
        containerViewController.dismissDialog(viewController: self, animated: animated, completion: completion)
    }

}

public protocol IQDialogContainerViewController : IQBaseViewController {

    typealias ViewControllerType = QPlatformViewController & IQDialogViewController
    typealias BackgroundViewType = QPlatformView & IQDialogContainerBackgroundView

    var viewControllers: [ViewControllerType] { get }
    var currentViewController: ViewControllerType? { get }
    var backgroundView: BackgroundViewType? { get }
    var presentAnimation: IQDialogViewControllerFixedAnimation { get }
    var dismissAnimation: IQDialogViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation? { get }

    func presentDialog(viewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissDialog(viewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)

}

public protocol IQDialogContainerBackgroundView : class {

    typealias ContainerViewControllerType = QPlatformViewController & IQDialogContainerViewController
    typealias ViewControllerType = QPlatformViewController & IQDialogViewController

    weak var containerViewController: ContainerViewControllerType? { set get }

    func presentDialog(viewController: ViewControllerType, isFirst: Bool, animated: Bool)
    func dismissDialog(viewController: ViewControllerType, isLast: Bool, animated: Bool)

}
