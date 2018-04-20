//
//  Quickly
//

open class QPushViewControllerAnimation : IQPushViewControllerFixedAnimation {

    public var viewController: IQPushViewController!
    public var duration: TimeInterval

    public init(duration: TimeInterval) {
        self.duration = duration
    }

    open func prepare(viewController: IQPushViewController) {
        self.viewController = viewController
    }

    open func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }

}

open class QPushViewControllerPresentAnimation : QPushViewControllerAnimation {

    public init() {
        super.init(duration: 0.2)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
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

open class QPushViewControllerDismissAnimation : QPushViewControllerAnimation {

    public init() {
        super.init(duration: 0.2)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
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

open class QPushViewControllerInteractiveDismissAnimation : IQPushViewControllerInteractiveAnimation {

    open var viewController: IQPushViewController!
    open var position: CGPoint = CGPoint.zero
    open private(set) var deltaPosition: CGFloat = 0
    open var velocity: CGPoint = CGPoint.zero
    open var finishDistance: CGFloat = 40
    open var acceleration: CGFloat = 600
    open var deceleration: CGFloat = 0.25
    open var canFinish: Bool = false

    open func prepare(viewController: IQPushViewController, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.position = position
        self.velocity = velocity
        self.viewController.prepareInteractiveDismiss()
    }

    open func update(position: CGPoint, velocity: CGPoint) {
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
            self.canFinish = abs(deltaPosition) > self.finishDistance
        }
        self.viewController.offset = self.deltaPosition
    }

    open func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
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

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
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
