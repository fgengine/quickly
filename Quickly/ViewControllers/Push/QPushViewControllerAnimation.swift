//
//  Quickly
//

open class QPushViewControllerAnimation : IQPushViewControllerFixedAnimation {

    public typealias ViewControllerType = IQPushViewControllerFixedAnimation.ViewControllerType

    public var viewController: ViewControllerType!
    public var duration: TimeInterval

    public init(duration: TimeInterval) {
        self.duration = duration
    }

    open func prepare(viewController: ViewControllerType) {
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
            #if os(macOS)
                self.viewController.view.layoutSubtreeIfNeeded()
            #elseif os(iOS)
                self.viewController.view.layoutIfNeeded()
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.state = .show
                    self.viewController.view.layoutIfNeeded()
                }, completion: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.viewController.didPresent(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(completed)
                })
            #endif
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
            #if os(iOS)
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.state = .hide
                    self.viewController.view.layoutIfNeeded()
                }, completion: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.viewController.didDismiss(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(completed)
                })
            #endif
        } else {
            self.viewController.state = .hide
            self.viewController.willDismiss(animated: animated)
            self.viewController.didDismiss(animated: animated)
            complete(true)
        }
    }

}

open class QPushViewControllerInteractiveDismissAnimation : IQPushViewControllerInteractiveAnimation {

    public typealias ViewControllerType = IQPushViewControllerFixedAnimation.ViewControllerType

    open var viewController: ViewControllerType!
    open var position: CGPoint = CGPoint.zero
    open var deltaPosition: CGFloat = 0
    open var velocity: CGPoint = CGPoint.zero
    open var finishDistance: CGFloat = 40
    open var acceleration: CGFloat = 600
    open var deceleration: CGFloat = 0.25
    open var canFinish: Bool = false

    open func prepare(viewController: ViewControllerType, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.position = position
        self.velocity = velocity
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
        #if os(iOS)
            let duration = TimeInterval(self.deltaPosition / self.acceleration)
            UIView.animate(withDuration: duration, animations: {
                self.viewController.offset = 0
                self.viewController.view.layoutIfNeeded()
            }, completion: complete)
        #endif
    }

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        self.viewController.willDismiss(animated: true)
        #if os(iOS)
            let offset = self.viewController.offset
            let height = self.viewController.contentViewController.view.frame.height
            let edgeInsets = self.viewController.edgeInsets
            let hideOffset = height + edgeInsets.top
            let duration = TimeInterval((hideOffset - offset) / self.acceleration)
            UIView.animate(withDuration: duration, animations: {
                self.viewController.offset = -hideOffset
                self.viewController.view.layoutIfNeeded()
            }, completion: { [weak self] (completed: Bool) in
                if let strongify = self {
                    strongify.viewController.didDismiss(animated: true)
                    strongify.viewController.state = .hide
                    strongify.viewController.offset = 0
                    strongify.viewController = nil
                }
                complete(completed)
            })
        #endif
    }

}
