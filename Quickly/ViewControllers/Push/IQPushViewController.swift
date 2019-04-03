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

    func present(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQPushViewController -

public protocol IQPushViewController : IQViewController {

    var containerViewController: IQPushContainerViewController? { get }
    var contentViewController: IQPushContentViewController { get }
    var state: QPushViewControllerState { set get }
    var offset: CGFloat { set get }
    var displayTime: TimeInterval? { get }
    var presentAnimation: IQPushViewControllerFixedAnimation? { get }
    var dismissAnimation: IQPushViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation? { get }

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?)

}

public extension IQPushViewController {

    var containerViewController: IQPushContainerViewController? {
        get { return self.parent as? IQPushContainerViewController }
    }

    func dismissPush(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismiss(viewController: self, animated: animated, completion: completion)
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
