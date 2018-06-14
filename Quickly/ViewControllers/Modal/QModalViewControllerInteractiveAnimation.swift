//
//  Quickly
//

public class QModalViewControllerInteractiveDismissAnimation : IQModalViewControllerInteractiveAnimation {

    internal var contentView: UIView!
    internal var previousBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var previousEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var previousViewController: IQModalViewController?
    internal var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var currentEndFrame: CGRect {
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
    internal var currentViewController: IQModalViewController!
    internal var position: CGPoint
    internal var deltaPosition: CGFloat
    internal var velocity: CGPoint
    internal var distance: CGFloat {
        get { return contentView.bounds.height }
    }
    internal var dismissDistanceRate: CGFloat
    internal var acceleration: CGFloat
    public private(set) var canFinish: Bool

    public init(acceleration: CGFloat = 1200, dismissDistanceRate: CGFloat = 0.4) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.dismissDistanceRate = dismissDistanceRate
        self.acceleration = acceleration
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
        self.currentViewController.prepareInteractiveDismiss()
        self.previousViewController = previousViewController
        if let vc = self.previousViewController {
            vc.view.frame = self.previousBeginFrame
            vc.prepareInteractivePresent()
        }
        self.position = position
        self.velocity = velocity

        if let vc = self.previousViewController {
            contentView.insertSubview(currentViewController.view, aboveSubview: vc.view)
        } else {
            contentView.bringSubview(toFront: currentViewController.view)
        }
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = max(0, position.y - self.position.y)
        let progress = self.deltaPosition / self.distance
        self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentEndFrame, progress: progress)
        if let vc = self.previousViewController {
            vc.view.frame = self.previousBeginFrame.lerp(self.previousEndFrame, progress: progress)
        }
        self.canFinish = self.deltaPosition > (self.distance * self.dismissDistanceRate)
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.currentViewController.view.frame = self.currentBeginFrame
            if let vc = self.previousViewController {
                vc.view.frame = self.previousBeginFrame
            }
        }, completion: { [weak self] (completed: Bool) in
            if let strong = self {
                strong.currentViewController.cancelInteractiveDismiss()
                strong.currentViewController = nil
                if let vc = strong.previousViewController {
                    vc.cancelInteractivePresent()
                    strong.previousViewController = nil
                }
                strong.contentView = nil
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
        UIView.animate(withDuration: duration, animations: {
            self.currentViewController.view.frame = self.currentEndFrame
            if let vc = self.previousViewController {
                vc.view.frame = self.previousEndFrame
            }
        }, completion: { [weak self] (completed: Bool) in
            if let strong = self {
                strong.currentViewController.didDismiss(animated: true)
                strong.currentViewController.finishInteractiveDismiss()
                strong.currentViewController = nil
                if let vc = strong.previousViewController {
                    vc.didPresent(animated: true)
                    vc.finishInteractivePresent()
                    strong.previousViewController = nil
                }
                strong.contentView = nil
            }
            complete(completed)
        })
    }

}
