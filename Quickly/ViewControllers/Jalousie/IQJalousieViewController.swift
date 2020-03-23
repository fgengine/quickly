//
//  Quickly
//

public enum QJalousieViewControllerState {
    case fullscreen
    case showed
    case closed
}

// MARK: IQJalousieViewControllerFixedAnimation

public protocol IQJalousieViewControllerFixedAnimation : class {

    func layout(
        contentView: UIView,
        state: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?
    )
    
    func animate(
        contentView: UIView,
        currentState: QJalousieViewControllerState,
        targetState: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

// MARK: IQJalousieViewControllerInteractiveAnimation

public protocol IQJalousieViewControllerInteractiveAnimation : class {

    var canFinish: Bool { get }
    
    func prepare(
        contentView: UIView,
        state: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?,
        position: CGPoint,
        velocity: CGPoint
    )
    
    func update(position: CGPoint, velocity: CGPoint)
    func finish(_ complete: @escaping (_ state: QJalousieViewControllerState) -> Void)
    func cancel(_ complete: @escaping (_ state: QJalousieViewControllerState) -> Void)

}

// MARK: IQJalousieContainerViewController

public protocol IQJalousieContainerViewController : IQStackContentViewController, IQModalContentViewController, IQHamburgerContentViewController {

    var state: QJalousieViewControllerState { set get }
    var contentViewController: IQJalousieViewController? { set get }
    var detailViewController: IQJalousieViewController? { set get }
    var animation: IQJalousieViewControllerFixedAnimation { set get }
    var interactiveAnimation: IQJalousieViewControllerInteractiveAnimation? { set get }
    var isAnimating: Bool { get }

    func change(contentViewController: IQJalousieViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(detailViewController: IQJalousieViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(state: QJalousieViewControllerState, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: IQJalousieViewController

public protocol IQJalousieViewController : IQContentOwnerViewController {

    var containerViewController: IQJalousieContainerViewController? { get }
    var viewController: IQJalousieContentViewController { get }
    
    func shouldInteractive() -> Bool

}

public extension IQJalousieViewController {

    var containerViewController: IQJalousieContainerViewController? {
        get { return self.parentViewController as? IQJalousieContainerViewController }
    }

}

// MARK: IQJalousieContentViewController

public protocol IQJalousieContentViewController : IQContentViewController {

    var jalousieViewController: IQJalousieViewController? { get }

    func jalousieShouldInteractive() -> Bool
    
}

public extension IQJalousieContentViewController {

    var jalousieViewController: IQJalousieViewController? {
        get { return self.parentViewControllerOf() }
    }

}
