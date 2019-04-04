//
//  Quickly
//

public class QHamburgerViewControllerAnimation : IQHamburgerViewControllerFixedAnimation {
    
    public func layout(
        contentView: UIView,
        state: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?
    ) {
    }
    
    public func animate(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        availableState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
    }
    
}
