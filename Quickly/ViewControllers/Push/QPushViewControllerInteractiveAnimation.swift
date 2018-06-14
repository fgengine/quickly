//
//  Quickly
//

public class QPushViewControllerInteractiveDismissAnimation : IQPushViewControllerInteractiveAnimation {

    internal var viewController: IQPushViewController!
    internal var position: CGPoint
    internal var deltaPosition: CGFloat
    internal var velocity: CGPoint
    internal var dismissDistance: CGFloat
    internal var acceleration: CGFloat
    internal var deceleration: CGFloat
    public private(set) var canFinish: Bool

    public init(dismissDistance: CGFloat = 40, acceleration: CGFloat = 600, deceleration: CGFloat = 0.25) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.dismissDistance = dismissDistance
        self.acceleration = acceleration
        self.deceleration = deceleration
        self.canFinish = false
    }

    public func prepare(viewController: IQPushViewController, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.position = position
        self.velocity = velocity
        self.viewController.prepareInteractiveDismiss()
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        let deltaPosition = position.y - self.position.y
        if deltaPosition > 0 {
            let height = self.viewController.pushContentViewController.view.frame.height
            let progress = abs(deltaPosition) / height
            if progress > self.deceleration {
                var limit = self.deceleration
                var multiplier = self.deceleration
                while progress > limit {
                    limit = limit + (limit * self.deceleration)
                    multiplier *= multiplier
                }
                self.deltaPosition = deltaPosition * (self.deceleration + ((progress - self.deceleration) * multiplier))
            } else {
                self.deltaPosition = deltaPosition * progress
            }
            self.canFinish = false
        } else {
            self.deltaPosition = deltaPosition
            self.canFinish = abs(deltaPosition) > self.dismissDistance
        }
        self.viewController.pushOffset = self.deltaPosition
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.viewController.pushOffset = 0
            self.viewController.view.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.cancelInteractiveDismiss()
            self.viewController = nil
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        self.viewController.willDismiss(animated: true)
        let offset = self.viewController.pushOffset
        let height = self.viewController.pushContentViewController.view.frame.height
        let edgeInsets = self.viewController.inheritedEdgeInsets
        let hideOffset = height + edgeInsets.top
        let duration = TimeInterval((hideOffset - offset) / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.viewController.pushOffset = -hideOffset
            self.viewController.view.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.didDismiss(animated: true)
            self.viewController.finishInteractiveDismiss()
            self.viewController.pushState = .hide
            self.viewController.pushOffset = 0
            self.viewController = nil
            complete(completed)
        })
    }

}
