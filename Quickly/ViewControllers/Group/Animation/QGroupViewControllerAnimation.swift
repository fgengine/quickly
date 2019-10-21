//
//  Quickly
//

public final class QGroupViewControllerAnimation : IQGroupViewControllerAnimation {
    
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    
    public init(overlapping: CGFloat = 0.1, acceleration: CGFloat = UIScreen.main.bounds.height * 0.85) {
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func animate(
        contentView: UIView,
        currentViewController: IQGroupViewController,
        targetViewController: IQGroupViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y + (frame.height * self.overlapping),
            width: frame.width,
            height: frame.height
        )
        let targetBeginFrame = frame
        let targetEndFrame = frame
        
        currentViewController.view.frame = currentBeginFrame
        currentViewController.view.alpha = 1
        currentViewController.layoutIfNeeded()
        targetViewController.view.frame = targetBeginFrame
        targetViewController.view.alpha = 1
        targetViewController.layoutIfNeeded()

        contentView.insertSubview(targetViewController.view, belowSubview: currentViewController.view)
        
        if animated == true {
            let currentDelta = abs(currentBeginFrame.centerPoint.distance(to: currentEndFrame.centerPoint))
            let targetDelta = abs(targetBeginFrame.centerPoint.distance(to: targetEndFrame.centerPoint))
            let duration = TimeInterval(max(currentDelta, targetDelta) / self.acceleration)
            
            currentViewController.willDismiss(animated: animated)
            targetViewController.willPresent(animated: animated)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                currentViewController.view.frame = currentEndFrame
                currentViewController.view.alpha = 0
                targetViewController.view.frame = targetEndFrame
                targetViewController.view.alpha = 1
            }, completion: { (completed) in
                currentViewController.didDismiss(animated: animated)
                targetViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            currentViewController.willDismiss(animated: animated)
            currentViewController.view.frame = currentEndFrame
            currentViewController.view.alpha = 0
            currentViewController.didDismiss(animated: animated)
            targetViewController.willPresent(animated: animated)
            targetViewController.view.frame = targetEndFrame
            targetViewController.view.alpha = 1
            targetViewController.didPresent(animated: animated)
            complete()
        }
    }

}
