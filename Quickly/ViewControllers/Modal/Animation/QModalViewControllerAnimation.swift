//
//  Quickly
//

public final class QModalViewControllerPresentAnimation : IQModalViewControllerFixedAnimation {
    
    public var acceleration: CGFloat
    
    public init(acceleration: CGFloat = 2200) {
        self.acceleration = acceleration
    }

    public func animate(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let previousBeginFrame = frame
        let previousEndFrame = frame
        let currentBeginFrame = CGRect(
            x: frame.minX,
            y: frame.maxY,
            width: frame.width,
            height: frame.height
        )
        let currentEndFrame = frame
        
        if let vc = previousViewController {
            vc.view.frame = previousBeginFrame
            vc.layoutIfNeeded()
        }
        currentViewController.view.frame = currentBeginFrame
        currentViewController.layoutIfNeeded()
        
        if let vc = previousViewController {
            contentView.insertSubview(currentViewController.view, aboveSubview: vc.view)
        } else {
            contentView.bringSubviewToFront(currentViewController.view)
        }
        
        if animated == true {
            let distance = currentBeginFrame.centerPoint.distance(to: currentEndFrame.centerPoint)
            let duration = TimeInterval(abs(distance) / self.acceleration)
            
            if let vc = previousViewController {
                vc.willDismiss(animated: animated)
            }
            currentViewController.willPresent(animated: animated)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews, .curveEaseOut ], animations: {
                if let vc = previousViewController {
                    vc.view.frame = previousEndFrame
                }
                currentViewController.view.frame = currentEndFrame
            }, completion: { (completed: Bool) in
                if let vc = previousViewController {
                    vc.didDismiss(animated: animated)
                }
                currentViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            if let vc = previousViewController {
                vc.willDismiss(animated: animated)
                vc.didDismiss(animated: animated)
                vc.view.frame = previousEndFrame
            }
            currentViewController.willPresent(animated: animated)
            currentViewController.didPresent(animated: animated)
            currentViewController.view.frame = currentEndFrame
            complete()
        }
    }

}

public final class QModalViewControllerDismissAnimation : IQModalViewControllerFixedAnimation {
    
    public var acceleration: CGFloat
    
    public init(acceleration: CGFloat = 2200) {
        self.acceleration = acceleration
    }
    
    public func animate(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let previousBeginFrame = frame
        let previousEndFrame = frame
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(
            x: frame.minX,
            y: frame.maxY,
            width: frame.width,
            height: frame.height
        )
        
        if let vc = previousViewController {
            vc.view.frame = previousBeginFrame
            vc.layoutIfNeeded()
        }
        currentViewController.view.frame = currentBeginFrame
        currentViewController.layoutIfNeeded()
        
        if let vc = previousViewController {
            contentView.insertSubview(currentViewController.view, aboveSubview: vc.view)
        } else {
            contentView.bringSubviewToFront(currentViewController.view)
        }
        
        if animated == true {
            let distance = currentBeginFrame.centerPoint.distance(to: currentEndFrame.centerPoint)
            let duration = TimeInterval(abs(distance) / self.acceleration)
            
            if let vc = previousViewController {
                vc.willDismiss(animated: animated)
            }
            currentViewController.willPresent(animated: animated)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews, .curveEaseOut ], animations: {
                if let vc = previousViewController {
                    vc.view.frame = previousEndFrame
                }
                currentViewController.view.frame = currentEndFrame
            }, completion: { (completed: Bool) in
                if let vc = previousViewController {
                    vc.didDismiss(animated: animated)
                }
                currentViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            if let vc = previousViewController {
                vc.willDismiss(animated: animated)
                vc.didDismiss(animated: animated)
                vc.view.frame = previousEndFrame
            }
            currentViewController.willPresent(animated: animated)
            currentViewController.didPresent(animated: animated)
            currentViewController.view.frame = currentEndFrame
            complete()
        }
    }

}
