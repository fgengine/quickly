//
//  Quickly
//

public enum QPushViewControllerState {
    case hide
    case show
}

public protocol IQPushViewControllerFixedAnimation : IQFixedAnimation {

    func prepare(viewController: IQPushViewController)

}

public protocol IQPushViewControllerInteractiveAnimation : IQInteractiveAnimation {

    func prepare(viewController: IQPushViewController, position: CGPoint, velocity: CGPoint)

}

public protocol IQPushViewController : IQViewController {

    var containerViewController: IQPushContainerViewController? { set get }
    var contentViewController: IQPushContentViewController { get }
    var state: QPushViewControllerState { set get }
    var offset: CGFloat { set get }
    var displayTime: TimeInterval? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation? { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { get }

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?)

}

public protocol IQPushContentViewController : IQViewController {

    var pushViewController: IQPushViewController? { set get }

    func didTimeout()
    func didPressed()

}

public extension IQPushViewController {

    public func dismissPush(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismissPush(viewController: self, animated: animated, completion: completion)
    }

}

public protocol IQPushContainerViewController : IQViewController {

    var viewControllers: [IQPushViewController] { get }
    var currentViewController: IQPushViewController? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { set get }

    func presentPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}
