//
//  Quickly
//

public final class QPageViewControllerForwardAnimation : IQPageViewControllerAnimation {
    
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    
    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200) {
        self.overlapping = overlapping
        self.acceleration = acceleration
    }
    
    public func animate(
        contentView: UIView,
        currentViewController: IQPageViewController,
        targetViewController: IQPageViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(
            x: frame.origin.x - frame.width,
            y: frame.origin.y,
            width: frame.width,
            height: frame.height
        )
        let targetBeginFrame = CGRect(
            x: frame.origin.x + (frame.width * self.overlapping),
            y: frame.origin.y,
            width: frame.width,
            height: frame.height
        )
        let targetEndFrame = frame
        
        currentViewController.view.frame = currentBeginFrame
        currentViewController.layoutIfNeeded()
        targetViewController.view.frame = targetBeginFrame
        targetViewController.layoutIfNeeded()
        
        contentView.insertSubview(targetViewController.view, belowSubview: currentViewController.view)
        
        if animated == true {
            currentViewController.willDismiss(animated: animated)
            targetViewController.willPresent(animated: animated)
            let duration = TimeInterval(abs(targetBeginFrame.midX - targetEndFrame.midX) / acceleration)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                currentViewController.view.frame = currentEndFrame
                targetViewController.view.frame = targetEndFrame
            }, completion: { (completed) in
                currentViewController.didDismiss(animated: animated)
                targetViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            currentViewController.view.frame = currentEndFrame
            currentViewController.willDismiss(animated: animated)
            currentViewController.didDismiss(animated: animated)
            targetViewController.view.frame = targetEndFrame
            targetViewController.willPresent(animated: animated)
            targetViewController.didPresent(animated: animated)
            complete()
        }
    }

}

public final class QPageViewControllerBackwardAnimation : IQPageViewControllerAnimation {
    
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    
    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200) {
        self.overlapping = overlapping
        self.acceleration = acceleration
    }
    
    public func animate(
        contentView: UIView,
        currentViewController: IQPageViewController,
        targetViewController: IQPageViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(
            x: frame.origin.x + frame.width,
            y: frame.origin.y,
            width: frame.width,
            height: frame.height
        )
        let targetBeginFrame = CGRect(
            x: frame.origin.x - (frame.width * self.overlapping),
            y: frame.origin.y,
            width: frame.width,
            height: frame.height
        )
        let targetEndFrame = frame
        
        currentViewController.view.frame = currentBeginFrame
        currentViewController.layoutIfNeeded()
        targetViewController.view.frame = targetBeginFrame
        targetViewController.layoutIfNeeded()
        
        contentView.insertSubview(targetViewController.view, belowSubview: currentViewController.view)
        
        if animated == true {
            currentViewController.willDismiss(animated: animated)
            targetViewController.willPresent(animated: animated)
            let duration = TimeInterval(abs(targetBeginFrame.midX - targetEndFrame.midX) / acceleration)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                currentViewController.view.frame = currentEndFrame
                targetViewController.view.frame = targetEndFrame
            }, completion: { (completed) in
                currentViewController.didDismiss(animated: animated)
                targetViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            currentViewController.view.frame = currentEndFrame
            currentViewController.willDismiss(animated: animated)
            currentViewController.didDismiss(animated: animated)
            targetViewController.view.frame = targetEndFrame
            targetViewController.willPresent(animated: animated)
            targetViewController.didPresent(animated: animated)
            complete()
        }
    }

}
