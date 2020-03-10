//
//  Quickly
//

public final class QModalViewControllerInteractiveDismissAnimation : IQModalViewControllerInteractiveAnimation {

    public var contentView: UIView!
    public var previousBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var previousEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var previousViewController: IQModalViewController?
    public var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var currentEndFrame: CGRect {
        get {
            let bounds = self.contentView.bounds
            return CGRect(
                x: bounds.minX,
                y: bounds.maxY,
                width: bounds.width,
                height: bounds.height
            )
        }
    }
    public var currentViewController: IQModalViewController!
    public var position: CGPoint
    public var deltaPosition: CGFloat
    public var velocity: CGPoint
    public var distance: CGFloat {
        get { return contentView.bounds.height }
    }
    public var acceleration: CGFloat
    public var dismissDistanceRate: CGFloat
    public var ease: IQAnimationEase
    public private(set) var canFinish: Bool

    public init(acceleration: CGFloat = 2200, dismissDistanceRate: CGFloat = 0.4, ease: IQAnimationEase = QAnimationEaseQuadraticOut()) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.acceleration = acceleration
        self.dismissDistanceRate = dismissDistanceRate
        self.ease = ease
        self.canFinish = false
    }

    public func prepare(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController,
        position: CGPoint,
        velocity: CGPoint
    ) {
        self.contentView = contentView
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.layoutIfNeeded()
        self.currentViewController.prepareInteractiveDismiss()
        self.previousViewController = previousViewController
        if let vc = self.previousViewController {
            vc.view.frame = self.previousBeginFrame
            vc.layoutIfNeeded()
            vc.prepareInteractivePresent()
        }
        self.position = position
        self.velocity = velocity

        if let vc = self.previousViewController {
            contentView.insertSubview(currentViewController.view, aboveSubview: vc.view)
        } else {
            contentView.bringSubviewToFront(currentViewController.view)
        }
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = self.ease.lerp(max(0, position.y - self.position.y), from: 0, to: self.distance)
        let progress = self.deltaPosition / self.distance
        self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentEndFrame, progress: progress)
        if let vc = self.previousViewController {
            vc.view.frame = self.previousBeginFrame.lerp(self.previousEndFrame, progress: progress)
        }
        self.canFinish = self.deltaPosition > (self.distance * self.dismissDistanceRate)
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.currentViewController.view.frame = self.currentBeginFrame
            if let vc = self.previousViewController {
                vc.view.frame = self.previousBeginFrame
            }
        }, completion: { [weak self] (completed: Bool) in
            if let self = self {
                self.currentViewController.cancelInteractiveDismiss()
                self.currentViewController = nil
                if let vc = self.previousViewController {
                    vc.cancelInteractivePresent()
                    self.previousViewController = nil
                }
                self.contentView = nil
            }
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval((self.distance - self.deltaPosition) / self.acceleration)
        self.currentViewController.willDismiss(animated: true)
        if let vc = self.previousViewController {
            vc.willPresent(animated: true)
        }
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.currentViewController.view.frame = self.currentEndFrame
            if let vc = self.previousViewController {
                vc.view.frame = self.previousEndFrame
            }
        }, completion: { [weak self] (completed: Bool) in
            if let self = self {
                self.currentViewController.didDismiss(animated: true)
                self.currentViewController.finishInteractiveDismiss()
                self.currentViewController = nil
                if let vc = self.previousViewController {
                    vc.didPresent(animated: true)
                    vc.finishInteractivePresent()
                    self.previousViewController = nil
                }
                self.contentView = nil
            }
            complete(completed)
        })
    }

}
