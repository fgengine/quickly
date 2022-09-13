//
//  Quickly
//

import UIKit

public enum QHamburgerViewControllerState {
    case idle
    case left
    case right
}

// MARK: IQHamburgerViewControllerFixedAnimation

public protocol IQHamburgerViewControllerFixedAnimation : AnyObject {

    func layout(
        contentView: UIView,
        state: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?
    )
    
    func animate(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        targetState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

// MARK: IQHamburgerViewControllerInteractiveAnimation

public protocol IQHamburgerViewControllerInteractiveAnimation : AnyObject {

    var canFinish: Bool { get }
    
    func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        targetState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        position: CGPoint,
        velocity: CGPoint
    )
    
    func update(position: CGPoint, velocity: CGPoint)
    func finish(_ complete: @escaping (_ state: QHamburgerViewControllerState) -> Void)
    func cancel(_ complete: @escaping (_ state: QHamburgerViewControllerState) -> Void)

}

// MARK: IQHamburgerContainerViewController

public protocol IQHamburgerContainerViewController : IQViewController {

    var state: QHamburgerViewControllerState { set get }
    var contentViewController: IQHamburgerViewController? { set get }
    var leftViewController: IQHamburgerViewController? { set get }
    var rightViewController: IQHamburgerViewController? { set get }
    var animation: IQHamburgerViewControllerFixedAnimation { set get }
    var interactiveAnimation: IQHamburgerViewControllerInteractiveAnimation? { set get }
    var isAnimating: Bool { get }

    func change(contentViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(leftViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(rightViewController: IQHamburgerViewController?, animated: Bool, completion: (() -> Swift.Void)?)
    func change(state: QHamburgerViewControllerState, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: IQHamburgerViewController

public protocol IQHamburgerViewController : IQContentOwnerViewController {

    var containerViewController: IQHamburgerContainerViewController? { get }
    var viewController: IQHamburgerContentViewController { get }
    
    func shouldInteractive() -> Bool

}

public extension IQHamburgerViewController {

    var containerViewController: IQHamburgerContainerViewController? {
        get { return self.parentViewController as? IQHamburgerContainerViewController }
    }

}

// MARK: IQHamburgerContentViewController

public protocol IQHamburgerContentViewController : IQContentViewController {

    var hamburgerViewController: IQHamburgerViewController? { get }

    func hamburgerShouldInteractive() -> Bool
    
}

public extension IQHamburgerContentViewController {

    var hamburgerViewController: IQHamburgerViewController? {
        get { return self.parentViewControllerOf() }
    }

}
