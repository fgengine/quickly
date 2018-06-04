//
//  Quickly
//

public class QPageViewControllerAnimation : IQPageViewControllerAnimation {

    internal var contentView: UIView!
    internal var currentViewController: IQPageSlideViewController!
    internal var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var currentEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var targetViewController: IQPageSlideViewController!
    internal var targetBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var targetEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    internal var duration: TimeInterval {
        get { return TimeInterval(abs(self.targetBeginFrame.midX - self.targetEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 0.8, acceleration: CGFloat = 1200) {
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQPageSlideViewController,
        targetViewController: IQPageSlideViewController
    ) {
        self.contentView = contentView
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.targetViewController = targetViewController
        self.targetViewController.view.frame = self.targetBeginFrame

        contentView.insertSubview(targetViewController.view, belowSubview: currentViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.targetViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.currentViewController.view.frame = self.currentEndFrame
                self.targetViewController.view.frame = self.targetEndFrame
            }, completion: { [weak self] (completed: Bool) in
                if let strong = self {
                    strong.currentViewController.didDismiss(animated: animated)
                    strong.currentViewController = nil
                    strong.targetViewController.didPresent(animated: animated)
                    strong.targetViewController = nil
                    strong.contentView = nil
                }
                complete(completed)
            })
        } else {
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController.willDismiss(animated: animated)
            self.currentViewController.didDismiss(animated: animated)
            self.currentViewController = nil
            self.targetViewController.view.frame = self.targetEndFrame
            self.targetViewController.willPresent(animated: animated)
            self.targetViewController.didPresent(animated: animated)
            self.targetViewController = nil
            self.contentView = nil
        }
    }

}

public class QPageViewControllerForwardAnimation : QPageViewControllerAnimation {

    internal override var currentEndFrame: CGRect {
        get {
            let frame = super.currentEndFrame
            return CGRect(
                x: frame.origin.x - frame.width,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal override var targetBeginFrame: CGRect {
        get {
            let frame = super.targetBeginFrame
            return CGRect(
                x: frame.origin.x + (frame.width * self.overlapping),
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }

}

public class QPageViewControllerBackwardAnimation : QPageViewControllerAnimation {

    internal override var currentEndFrame: CGRect {
        get {
            let frame = super.currentEndFrame
            return CGRect(
                x: frame.origin.x + frame.width,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal override var targetBeginFrame: CGRect {
        get {
            let frame = super.targetBeginFrame
            return CGRect(
                x: frame.origin.x - (frame.width * self.overlapping),
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }

}

public class QPageViewControllerInteractiveAnimation : IQPageViewControllerInteractiveAnimation {

    internal var contentView: UIView!
    internal var backwardBeginFrame: CGRect {
        get {
            let frame = self.contentView.bounds
            return CGRect(
                x: frame.origin.x - (frame.width * self.overlapping),
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal var backwardEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var backwardViewController: IQPageSlideViewController?
    internal var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var currentBackwardEndFrame: CGRect {
        get {
            let frame = self.contentView.bounds
            return CGRect(
                x: frame.origin.x + frame.width,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal var currentForwardEndFrame: CGRect {
        get {
            let frame = self.contentView.bounds
            return CGRect(
                x: frame.origin.x - frame.width,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal var currentViewController: IQPageSlideViewController!
    internal var forwardBeginFrame: CGRect {
        get {
            let frame = self.contentView.bounds
            return CGRect(
                x: frame.origin.x + (frame.width * self.overlapping),
                y: frame.origin.y,
                width: frame.width,
                height: frame.height
            )
        }
    }
    internal var forwardEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var forwardViewController: IQPageSlideViewController?
    internal var position: CGPoint
    internal var deltaPosition: CGFloat
    internal var velocity: CGPoint
    internal var distance: CGFloat {
        get { return self.contentView.bounds.width }
    }
    internal var finishDistanceRate: CGFloat
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    internal var deceleration: CGFloat
    public var canFinish: Bool {
        get { return self.finishMode != .none }
    }
    public private(set) var finishMode: QPageViewControllerAnimationMode

    public init(overlapping: CGFloat = 0.8, acceleration: CGFloat = 1200, finishDistanceRate: CGFloat = 0.4, deceleration: CGFloat = 0.35) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.finishDistanceRate = finishDistanceRate
        self.overlapping = overlapping
        self.acceleration = acceleration
        self.deceleration = deceleration
        self.finishMode = .none
    }

    public func prepare(
        contentView: UIView,
        backwardViewController: IQPageSlideViewController?,
        currentViewController: IQPageSlideViewController,
        forwardViewController: IQPageSlideViewController?,
        position: CGPoint,
        velocity: CGPoint
    ) {
        self.contentView = contentView
        self.backwardViewController = backwardViewController
        if let vc = self.backwardViewController {
            vc.view.frame = self.backwardBeginFrame
            vc.prepareInteractivePresent()
        }
        self.currentViewController = currentViewController
        self.currentViewController.prepareInteractivePresent()
        self.forwardViewController = forwardViewController
        if let vc = forwardViewController {
            vc.view.frame = self.forwardBeginFrame
            vc.prepareInteractivePresent()
        }
        self.position = position
        self.velocity = velocity

        if let vc = self.backwardViewController {
            contentView.sendSubview(toBack: vc.view)
        }
        if let vc = forwardViewController {
            contentView.sendSubview(toBack: vc.view)
        }
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = position.x - self.position.x
        if self.deltaPosition > CGFloat.leastNonzeroMagnitude {
            let delta = self.deltaPosition
            let progress = delta / self.distance
            if let vc = self.backwardViewController {
                vc.view.frame = self.backwardBeginFrame.lerp(self.backwardEndFrame, progress: progress)
                vc.view.isHidden = false
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentBackwardEndFrame, progress: progress)
                self.finishMode = (delta > self.distance * self.finishDistanceRate) ? .backward : .none
            } else {
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentBackwardEndFrame, progress: progress * self.deceleration)
                self.finishMode = .none
            }
            if let vc = self.forwardViewController {
                vc.view.frame = self.currentForwardEndFrame
                vc.view.isHidden = true
            }
        } else if self.deltaPosition < CGFloat.leastNonzeroMagnitude {
            let delta = -self.deltaPosition
            let progress = delta / self.distance
            if let vc = self.forwardViewController {
                vc.view.frame = self.forwardBeginFrame.lerp(self.forwardEndFrame, progress: progress)
                vc.view.isHidden = false
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentForwardEndFrame, progress: progress)
                self.finishMode = (delta > self.distance * self.finishDistanceRate) ? .forward : .none
            } else {
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentForwardEndFrame, progress: progress * self.deceleration)
                self.finishMode = .none
            }
            if let vc = self.backwardViewController {
                vc.view.frame = self.currentBackwardEndFrame
                vc.view.isHidden = true
            }
        } else {
            if let vc = self.backwardViewController {
                vc.view.frame = self.currentBackwardEndFrame
                vc.view.isHidden = true
            }
            if let vc = self.forwardViewController {
                vc.view.frame = self.currentForwardEndFrame
                vc.view.isHidden = true
            }
            self.currentViewController.view.frame = self.currentBeginFrame
            self.finishMode = .none
        }
    }

    public func cancel(_ complete: @escaping (Bool) -> Void) {
        let duration = TimeInterval(abs(self.deltaPosition) / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            if let vc = self.backwardViewController {
                vc.view.frame = self.backwardBeginFrame
            }
            if let vc = self.forwardViewController {
                vc.view.frame = self.forwardBeginFrame
            }
            self.currentViewController.view.frame = self.currentBeginFrame
        }, completion: { (completed: Bool) in
            if let vc = self.backwardViewController {
                vc.view.isHidden = false
                vc.cancelInteractiveDismiss()
                self.backwardViewController = nil
            }
            self.currentViewController.cancelInteractiveDismiss()
            self.currentViewController = nil
            if let vc = self.forwardViewController {
                vc.view.isHidden = false
                vc.cancelInteractiveDismiss()
                self.forwardViewController = nil
            }
            self.contentView = nil
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (Bool) -> Void) {
        let duration = TimeInterval((self.distance - abs(self.deltaPosition)) / self.acceleration)
        if self.deltaPosition > CGFloat.leastNonzeroMagnitude {
            if let vc = self.backwardViewController {
                vc.willDismiss(animated: true)
            }
            self.currentViewController.willDismiss(animated: true)
            UIView.animate(withDuration: duration, animations: {
                if let vc = self.backwardViewController {
                    vc.view.frame = self.backwardEndFrame
                }
                self.currentViewController.view.frame = self.currentBackwardEndFrame
            }, completion: { (completed: Bool) in
                if let vc = self.backwardViewController {
                    vc.finishInteractiveDismiss()
                    self.backwardViewController = nil
                }
                self.currentViewController.finishInteractiveDismiss()
                self.currentViewController = nil
                if let vc = self.forwardViewController {
                    vc.view.isHidden = false
                    self.forwardViewController = nil
                }
                self.contentView = nil
                complete(completed)
            })
        } else if self.deltaPosition < CGFloat.leastNonzeroMagnitude {
            if let vc = self.forwardViewController {
                vc.willDismiss(animated: true)
            }
            self.currentViewController.willDismiss(animated: true)
            UIView.animate(withDuration: duration, animations: {
                if let vc = self.forwardViewController {
                    vc.view.frame = self.forwardEndFrame
                }
                self.currentViewController.view.frame = self.currentForwardEndFrame
            }, completion: { (completed: Bool) in
                if let vc = self.backwardViewController {
                    vc.view.isHidden = false
                    self.backwardViewController = nil
                }
                self.currentViewController.finishInteractiveDismiss()
                self.currentViewController = nil
                if let vc = self.forwardViewController {
                    vc.finishInteractiveDismiss()
                    self.forwardViewController = nil
                }
                self.contentView = nil
                complete(completed)
            })
        }
    }

}
