//
//  Quickly
//

public class QStackViewControllerPresentAnimation : IQStackViewControllerPresentAnimation {

    internal var currentBeginFrame: CGRect
    internal var currentEndFrame: CGRect
    internal var currentViewController: IQStackPageViewController!
    internal var nextBeginFrame: CGRect
    internal var nextEndFrame: CGRect
    internal var nextViewController: IQStackPageViewController!
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    internal var duration: TimeInterval {
        get { return TimeInterval(abs(self.nextBeginFrame.midX - self.nextEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 0.5, acceleration: CGFloat = 1200) {
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.nextBeginFrame = CGRect.zero
        self.nextEndFrame = CGRect.zero
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        nextViewController: IQStackPageViewController
    ) {
        let frame = contentView.bounds

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame

        self.nextBeginFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.nextEndFrame = frame
        self.nextViewController = nextViewController
        self.nextViewController.view.frame = self.nextBeginFrame

        contentView.bringSubview(toFront: self.nextViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.nextViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.currentViewController.view.frame = self.currentEndFrame
                self.nextViewController.view.frame = self.nextEndFrame
            }, completion: { (completed: Bool) in
                self.currentViewController.didDismiss(animated: animated)
                self.currentViewController = nil
                self.nextViewController.didPresent(animated: animated)
                self.nextViewController = nil
                complete(completed)
            })
        } else {
            self.currentViewController.willDismiss(animated: animated)
            self.currentViewController.didDismiss(animated: animated)
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController = nil
            self.nextViewController.willPresent(animated: animated)
            self.nextViewController.didPresent(animated: animated)
            self.nextViewController.view.frame = self.nextEndFrame
            self.nextViewController = nil
            complete(true)
        }
    }

}

public class QStackViewControllerDismissAnimation : IQStackViewControllerDismissAnimation {

    internal var currentBeginFrame: CGRect
    internal var currentEndFrame: CGRect
    internal var currentViewController: IQStackPageViewController!
    internal var previousBeginFrame: CGRect
    internal var previousEndFrame: CGRect
    internal var previousViewController: IQStackPageViewController!
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    internal var duration: TimeInterval {
        get { return TimeInterval(abs(self.currentBeginFrame.midX - self.currentEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 0.5, acceleration: CGFloat = 1200) {
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.previousBeginFrame = CGRect.zero
        self.previousEndFrame = CGRect.zero
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController
    ) {
        let frame = contentView.bounds

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame

        self.previousBeginFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        self.previousEndFrame = frame
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame

        contentView.bringSubview(toFront: self.currentViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.previousViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.currentViewController.view.frame = self.currentEndFrame
                self.previousViewController.view.frame = self.previousEndFrame
            }, completion: { (completed: Bool) in
                self.currentViewController.didDismiss(animated: animated)
                self.currentViewController = nil
                self.previousViewController.didPresent(animated: animated)
                self.previousViewController = nil
                complete(completed)
            })
        } else {
            self.currentViewController.willDismiss(animated: animated)
            self.currentViewController.didDismiss(animated: animated)
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController = nil
            self.previousViewController.willPresent(animated: animated)
            self.previousViewController.didPresent(animated: animated)
            self.previousViewController.view.frame = self.previousEndFrame
            self.previousViewController = nil
            complete(true)
        }
    }

}

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
    internal var currentViewController: IQStackPageViewController!
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
    internal var previousViewController: IQStackPageViewController!
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

    public init(overlapping: CGFloat = 0.75, acceleration: CGFloat = 1200, dismissDistanceRate: CGFloat = 0.4) {
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
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController,
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

        contentView.bringSubview(toFront: self.currentViewController.view)
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
        }, completion: { (completed: Bool) in
            self.currentViewController.cancelInteractiveDismiss()
            self.currentViewController = nil
            self.previousViewController.cancelInteractivePresent()
            self.previousViewController = nil
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
        }, completion: { (completed: Bool) in
            self.currentViewController.didDismiss(animated: true)
            self.currentViewController.finishInteractiveDismiss()
            self.currentViewController = nil
            self.previousViewController.didPresent(animated: true)
            self.previousViewController.finishInteractivePresent()
            self.previousViewController = nil
            complete(completed)
        })
    }

}
