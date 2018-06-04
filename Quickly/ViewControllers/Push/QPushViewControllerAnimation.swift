//
//  Quickly
//

public class QPushViewControllerAnimation : IQPushViewControllerFixedAnimation {

    internal var duration: TimeInterval
    internal var viewController: IQPushViewController!

    public init(duration: TimeInterval = 0.2) {
        self.duration = duration
    }

    public func prepare(viewController: IQPushViewController) {
        self.viewController = viewController
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }

}

public class QPushViewControllerPresentAnimation : QPushViewControllerAnimation {


    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            self.viewController.willPresent(animated: animated)
            self.viewController.view.layoutIfNeeded()
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.state = .show
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.didPresent(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.state = .show
            self.viewController.willPresent(animated: animated)
            self.viewController.didPresent(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}

public class QPushViewControllerDismissAnimation : QPushViewControllerAnimation {

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            self.viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.state = .hide
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.didDismiss(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.state = .hide
            self.viewController.willDismiss(animated: animated)
            self.viewController.didDismiss(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}

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
            let height = self.viewController.contentViewController.view.frame.height
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
        self.viewController.offset = self.deltaPosition
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.viewController.offset = 0
            self.viewController.view.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.cancelInteractiveDismiss()
            self.viewController = nil
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        self.viewController.willDismiss(animated: true)
        let offset = self.viewController.offset
        let height = self.viewController.contentViewController.view.frame.height
        let edgeInsets = self.viewController.inheritedEdgeInsets
        let hideOffset = height + edgeInsets.top
        let duration = TimeInterval((hideOffset - offset) / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.viewController.offset = -hideOffset
            self.viewController.view.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.didDismiss(animated: true)
            self.viewController.finishInteractiveDismiss()
            self.viewController.state = .hide
            self.viewController.offset = 0
            self.viewController = nil
            complete(completed)
        })
    }

}
