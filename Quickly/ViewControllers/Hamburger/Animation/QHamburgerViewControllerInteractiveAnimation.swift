//
//  Quickly
//

public class QHamburgerViewControllerInteractiveAnimation : IQHamburgerViewControllerInteractiveAnimation {
    
    public var canFinish: Bool
    
    public init() {
        self.canFinish = false
    }
    
    public func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        availableState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        position: CGPoint,
        velocity: CGPoint
    ) {
    }
    
    public func update(position: CGPoint, velocity: CGPoint) {
    }
    
    public func finish(_ complete: @escaping (_ state: QHamburgerViewControllerState) -> Void) {
    }
    
    public func cancel(_ complete: @escaping () -> Void) {
    }
    
}
