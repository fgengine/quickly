//
//  Quickly
//

public enum QPushViewControllerState {
    case hide
    case show
}

public protocol IQPushViewControllerFixedAnimation : IQFixedAnimation {

    typealias ViewControllerType = QPlatformViewController & IQPushViewController

    func prepare(viewController: ViewControllerType)

}

public protocol IQPushViewControllerInteractiveAnimation : IQInteractiveAnimation {

    typealias ViewControllerType = QPlatformViewController & IQPushViewController

    func prepare(viewController: ViewControllerType, position: CGPoint, velocity: CGPoint)

}

public protocol IQPushViewController : IQBaseViewController {

    typealias ContainerViewControllerType = QPlatformViewController & IQPushContainerViewController
    typealias ContentViewControllerType = QPlatformViewController & IQPushContentViewController

    var containerViewController: ContainerViewControllerType? { set get }

    var contentViewController: ContentViewControllerType { set get }
    var state: QPushViewControllerState { set get }
    var offset: CGFloat { set get }
    var edgeInsets: QPlatformEdgeInsets { set get }
    var displayTime: TimeInterval? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation? { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { get }

    func beginInteractiveDismiss()
    func cancelInteractiveDismiss()
    func funishInteractiveDismiss()

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?)

}

public protocol IQPushContentViewController : IQBaseViewController {

    typealias PushViewControllerType = QPlatformViewController & IQPushViewController

    var pushViewController: PushViewControllerType? { set get }

    func didTimeout()
    func didPressed()

}

public extension IQPushViewController where Self : QPlatformViewController {

    public func dismissPush(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismissPush(viewController: self, animated: animated, completion: completion)
    }

}

public protocol IQPushContainerViewController : IQBaseViewController {

    typealias ViewControllerType = QPlatformViewController & IQPushViewController

    var viewControllers: [ViewControllerType] { get }
    var currentViewController: ViewControllerType? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { set get }

    func presentPush(viewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissPush(viewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)

}
