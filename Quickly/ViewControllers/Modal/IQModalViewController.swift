//
//  Quickly
//

// MARK: - IQModalViewControllerFixedAnimation -

public protocol IQModalViewControllerFixedAnimation : IQFixedAnimation {

    func prepare(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController
    )

}

// MARK: - IQModalViewControllerInteractiveAnimation -

public protocol IQModalViewControllerInteractiveAnimation : IQInteractiveAnimation {

    func prepare(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        position: CGPoint,
        velocity: CGPoint
    )

}

// MARK: - IQModalContainerViewController -

public protocol IQModalContainerViewController : IQViewController {

    var viewControllers: [IQModalViewController] { get }
    var currentViewController: IQModalViewController? { get }
    var previousViewController: IQModalViewController? { get }
    var presentAnimation: IQModalViewControllerFixedAnimation { get }
    var dismissAnimation: IQModalViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQModalViewControllerInteractiveAnimation? { set get }
    var isAnimating: Bool { get }

    func present(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQModalViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: - IQModalViewController -

public protocol IQModalViewController : IQViewController {

    var containerViewController: IQModalContainerViewController? { get }
    var contentViewController: IQModalContentViewController { get }
    var presentAnimation: IQModalViewControllerFixedAnimation? { get }
    var dismissAnimation: IQModalViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQModalViewControllerInteractiveAnimation? { get }

    func dismissModal(animated: Bool, completion: (() -> Swift.Void)?)

}

public extension IQModalViewController {

    var containerViewController: IQModalContainerViewController? {
        get { return self.parent as? IQModalContainerViewController }
    }

    func dismissModal(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismiss(viewController: self, animated: animated, completion: completion)
    }

}

// MARK: - IQModalContentViewController -

public protocol IQModalContentViewController : IQViewController {

    var modalViewController: IQModalViewController? { get }

}

public extension IQModalContentViewController {

    var modalViewController: IQModalViewController? {
        get { return self.parentOf() }
    }

}
