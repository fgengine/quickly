//
//  Quickly
//

// MARK: IQModalViewControllerFixedAnimation

public protocol IQModalViewControllerFixedAnimation : class {

    func animate(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

// MARK: IQModalViewControllerInteractiveAnimation

public protocol IQModalViewControllerInteractiveAnimation : class {

    var canFinish: Bool { get }
    
    func prepare(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        position: CGPoint,
        velocity: CGPoint
    )
    
    func update(position: CGPoint, velocity: CGPoint)
    func cancel(_ complete: @escaping (_ completed: Bool) -> Void)
    func finish(_ complete: @escaping (_ completed: Bool) -> Void)

}

// MARK: IQModalContainerViewController

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

// MARK: IQModalViewController

public protocol IQModalViewController : IQContentOwnerViewController {

    var containerViewController: IQModalContainerViewController? { get }
    var viewController: IQModalContentViewController { get }
    var presentAnimation: IQModalViewControllerFixedAnimation? { get }
    var dismissAnimation: IQModalViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQModalViewControllerInteractiveAnimation? { get }

    func dismissModal(animated: Bool, completion: (() -> Swift.Void)?)

}

public extension IQModalViewController {

    var containerViewController: IQModalContainerViewController? {
        get { return self.parentViewController as? IQModalContainerViewController }
    }

    func dismissModal(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismiss(viewController: self, animated: animated, completion: completion)
    }

}

// MARK: IQModalContentViewController

public protocol IQModalContentViewController : IQContentViewController {

    var modalViewController: IQModalViewController? { get }

}

public extension IQModalContentViewController {

    var modalViewController: IQModalViewController? {
        get { return self.parentViewControllerOf() }
    }

}
