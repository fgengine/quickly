//
//  Quickly
//

import UIKit

// MARK: QDialogViewControllerSizeBehaviour

public enum QDialogViewControllerSizeBehaviour {
    case fit(min: CGFloat, max: CGFloat)
    case fill(before: CGFloat, after: CGFloat)
}

// MARK: QDialogViewControllerVerticalAlignment

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

// MARK: QDialogViewControllerHorizontalAlignment

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

// MARK: IQDialogViewControllerFixedAnimation

public protocol IQDialogViewControllerFixedAnimation : AnyObject {

    func animate(
        viewController: IQDialogViewController,
        animated: Bool,
        complete: @escaping () -> Void
    )

}

// MARK: IQDialogViewControllerInteractiveAnimation

public protocol IQDialogViewControllerInteractiveAnimation : AnyObject {

    var canFinish: Bool { get }
    
    func prepare(
        viewController: IQDialogViewController,
        position: CGPoint,
        velocity: CGPoint
    )
    
    func update(position: CGPoint, velocity: CGPoint)
    func cancel(_ complete: @escaping (_ completed: Bool) -> Void)
    func finish(_ complete: @escaping (_ completed: Bool) -> Void)

}

// MARK: IQDialogContainerViewController

public protocol IQDialogContainerViewController : IQViewController {

    typealias BackgroundView = UIView & IQDialogContainerBackgroundView

    var viewControllers: [IQDialogViewController] { get }
    var currentViewController: IQDialogViewController? { get }
    var backgroundView: BackgroundView? { set get }
    var presentAnimation: IQDialogViewControllerFixedAnimation { get }
    var dismissAnimation: IQDialogViewControllerFixedAnimation { get }
    var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation? { get }
    var isAnimating: Bool { get }

    func present(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(viewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)

}

// MARK: IQDialogContainerBackgroundView

public protocol IQDialogContainerBackgroundView : AnyObject {

    var containerViewController: IQDialogContainerViewController? { set get }

    func present(viewController: IQDialogViewController, isFirst: Bool, animated: Bool)
    func dismiss(viewController: IQDialogViewController, isLast: Bool, animated: Bool)

}

// MARK: IQDialogViewController

public protocol IQDialogViewController : IQContentOwnerViewController {

    var containerViewController: IQDialogContainerViewController? { get }
    var viewController: IQDialogContentViewController { get }
    var widthBehaviour: QDialogViewControllerSizeBehaviour { set get }
    var heightBehaviour: QDialogViewControllerSizeBehaviour { set get }
    var verticalAlignment: QDialogViewControllerVerticalAlignment { set get }
    var horizontalAlignment: QDialogViewControllerHorizontalAlignment { set get }
    var presentAnimation: IQDialogViewControllerFixedAnimation? { get }
    var dismissAnimation: IQDialogViewControllerFixedAnimation? { get }
    var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation? { get }

    func dismissDialog(animated: Bool, completion: (() -> Swift.Void)?)

}

public extension IQDialogViewController {

    var containerViewController: IQDialogContainerViewController? {
        get { return self.parentViewController as? IQDialogContainerViewController }
    }

    func dismissDialog(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let vc = self.containerViewController else { return }
        vc.dismiss(viewController: self, animated: animated, completion: completion)
    }

}

// MARK: IQDialogContentViewController

public protocol IQDialogContentViewController : IQContentViewController {

    var dialogViewController: IQDialogViewController? { get }

    func dialogDidPressedOutside()

}

public extension IQDialogContentViewController {

    var dialogViewController: IQDialogViewController? {
        get { return self.parentViewControllerOf() }
    }

}
