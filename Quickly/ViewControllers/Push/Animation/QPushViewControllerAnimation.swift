//
//  Quickly
//

public class QPushViewControllerPresentAnimation : IQPushViewControllerFixedAnimation {
    
    public var duration: TimeInterval
    
    public init(duration: TimeInterval = 0.2) {
        self.duration = duration
    }

    public func animate(
        viewController: IQPushViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        viewController.layoutIfNeeded()

        if animated == true {
            viewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                viewController.state = .show
                viewController.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                viewController.didPresent(animated: animated)
                complete()
            })
        } else {
            viewController.state = .show
            viewController.willPresent(animated: animated)
            viewController.didPresent(animated: animated)
            complete()
        }
    }

}

public class QPushViewControllerDismissAnimation : IQPushViewControllerFixedAnimation {
    
    public var duration: TimeInterval
    
    public init(duration: TimeInterval = 0.2) {
        self.duration = duration
    }

    public func animate(
        viewController: IQPushViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        viewController.layoutIfNeeded()
        
        if animated == true {
            viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                viewController.state = .hide
                viewController.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                viewController.didDismiss(animated: animated)
                complete()
            })
        } else {
            viewController.state = .hide
            viewController.willDismiss(animated: animated)
            viewController.didDismiss(animated: animated)
            complete()
        }
    }

}
