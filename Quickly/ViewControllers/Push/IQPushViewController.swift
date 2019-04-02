//
//  Quickly
//

// MARK: - QPushViewControllerState -

public enum QPushViewControllerState {
    case hide
    case show
}

// MARK: - IQPushViewControllerFixedAnimation -

public protocol IQPushViewControllerFixedAnimation : IQFixedAnimation {

    func prepare(viewController: IQPushViewController)

}

// MARK: - IQPushViewControllerInteractiveAnimation -

public protocol IQPushViewControllerInteractiveAnimation : IQInteractiveAnimation {

    func prepare(viewController: IQPushViewController, position: CGPoint, velocity: CGPoint)

}

// MARK: - IQPushContainerViewController -

public protocol IQPushContainerViewController : IQViewController {

    var viewControllers: [IQPushViewController] { get }
    var currentViewController: IQPushViewController? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { set get }
    var isAnimating: Bool { get }

    func presentPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismissPush(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQPushViewController -

public protocol IQPushViewController : IQViewController {

    var pushContainerViewController: IQPushContainerViewController? { get }
    var pushContentViewController: IQPushContentViewController { get }
    var pushState: QPushViewControllerState { set get }
    var pushOffset: CGFloat { set get }
    var pushDisplayTime: TimeInterval? { get }
    var pushPresentAnimation: IQPushViewControllerFixedAnimation? { get }
    var pushDismissAnimation: IQPushViewControllerFixedAnimation? { get }
    var pushInteractiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { get }

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?)

}

public extension IQPushViewController {

    var pushContainerViewController: IQPushContainerViewController? {
        get { return self.parent as? IQPushContainerViewController }
    }

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.pushContainerViewController else { return }
        vc.dismissPush(viewController: self, animated: animated, completion: completion)
    }

}

// MARK: - IQPushContentViewController -

public protocol IQPushContentViewController : IQViewController {

    var pushViewController: IQPushViewController? { get }

    func didTimeout()
    func didPressed()

}

public extension IQPushContentViewController {

    var pushViewController: IQPushViewController? {
        get { return self.parentOf() }
    }

}
