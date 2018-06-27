//
//  Quickly
//

public class QStackViewControllerinteractiveDismissAnimation : IQStackViewControllerInteractiveDismissAnimation {

    internal var contentView: UIView!
    internal var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var currentEndFrame: CGRect {
        get {
            let bounds = self.contentView.bounds
            return CGRect(
                x: bounds.maxX,
                y: bounds.minY,
                width: bounds.width,
                height: bounds.height
            )
        }
    }
    internal var currentViewController: IQStackViewController!
    internal var previousBeginFrame: CGRect {
        get {
            let bounds = self.contentView.bounds
            return CGRect(
                x: bounds.minX - (bounds.width * self.overlapping),
                y: bounds.minY,
                width: bounds.width,
                height: bounds.height
            )
        }
    }
    internal var previousEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var previousViewController: IQStackViewController!
    internal var position: CGPoint
    internal var deltaPosition: CGFloat
    internal var velocity: CGPoint
    internal var distance: CGFloat {
        get { return contentView.bounds.width }
    }
    internal var dismissDistanceRate: CGFloat
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    public private(set) var canFinish: Bool

    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200, dismissDistanceRate: CGFloat = 0.4) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.dismissDistanceRate = dismissDistanceRate
        self.overlapping = overlapping
        self.acceleration = acceleration
        self.canFinish = false
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQStackViewController,
        previousViewController: IQStackViewController,
        position: CGPoint,
        velocity: CGPoint
    ) {
        self.contentView = contentView
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.prepareInteractiveDismiss()
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame
        self.previousViewController.prepareInteractivePresent()
        self.position = position
        self.velocity = velocity

        contentView.insertSubview(currentViewController.view, aboveSubview: previousViewController.view)
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = max(0, position.x - self.position.x)
        let progress = self.deltaPosition / self.distance
        self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentEndFrame, progress: progress)
        self.previousViewController.view.frame = self.previousBeginFrame.lerp(self.previousEndFrame, progress: progress)
        self.canFinish = self.deltaPosition > (self.distance * self.dismissDistanceRate)
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.currentViewController.view.frame = self.currentBeginFrame
            self.previousViewController.view.frame = self.previousBeginFrame
        }, completion: { [weak self] (completed: Bool) in
            if let strong = self {
                strong.currentViewController.cancelInteractiveDismiss()
                strong.currentViewController = nil
                strong.previousViewController.cancelInteractivePresent()
                strong.previousViewController = nil
                strong.contentView = nil
            }
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval((self.distance - self.deltaPosition) / self.acceleration)
        self.currentViewController.willDismiss(animated: true)
        self.previousViewController.willPresent(animated: true)
        UIView.animate(withDuration: duration, animations: {
            self.currentViewController.view.frame = self.currentEndFrame
            self.previousViewController.view.frame = self.previousEndFrame
        }, completion: { [weak self] (completed: Bool) in
            if let strong = self {
                strong.currentViewController.didDismiss(animated: true)
                strong.currentViewController.finishInteractiveDismiss()
                strong.currentViewController = nil
                strong.previousViewController.didPresent(animated: true)
                strong.previousViewController.finishInteractivePresent()
                strong.previousViewController = nil
                strong.contentView = nil
            }
            complete(completed)
        })
    }

}
