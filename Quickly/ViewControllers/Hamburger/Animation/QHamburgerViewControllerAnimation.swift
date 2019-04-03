//
//  Quickly
//

public class QHamburgerViewControllerAnimation : IQHamburgerViewControllerFixedAnimation {
    
    public func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        availableState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?
    ) {
    }
    
    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }
    
}
