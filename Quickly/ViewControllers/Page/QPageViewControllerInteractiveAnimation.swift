//
//  Quickly
//

public class QPageViewControllerInteractiveAnimation : IQPageViewControllerInteractiveAnimation {

    public var contentView: UIView!
    public var backwardBeginFrame: CGRect {
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
    public var backwardEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var backwardViewController: IQPageViewController?
    public var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var currentBackwardEndFrame: CGRect {
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
    public var currentForwardEndFrame: CGRect {
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
    public var currentViewController: IQPageViewController!
    public var forwardBeginFrame: CGRect {
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
    public var forwardEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var forwardViewController: IQPageViewController?
    public var position: CGPoint
    public var deltaPosition: CGFloat
    public var velocity: CGPoint
    public var distance: CGFloat {
        get { return self.contentView.bounds.width }
    }
    public var finishDistanceRate: CGFloat
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    public var deceleration: CGFloat
    public var canFinish: Bool {
        get { return self.finishMode != .none }
    }
    public var ease: IQAnimationEase
    public private(set) var finishMode: QPageViewControllerAnimationMode

    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200, finishDistanceRate: CGFloat = 0.4, deceleration: CGFloat = 0.35) {
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.finishDistanceRate = finishDistanceRate
        self.overlapping = overlapping
        self.acceleration = acceleration
        self.deceleration = deceleration
        self.ease = QAnimationEaseQuadraticOut()
        self.finishMode = .none
    }

    public func prepare(
        contentView: UIView,
        backwardViewController: IQPageViewController?,
        currentViewController: IQPageViewController,
        forwardViewController: IQPageViewController?,
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
            contentView.sendSubviewToBack(vc.view)
        }
        if let vc = forwardViewController {
            contentView.sendSubviewToBack(vc.view)
        }
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = position.x - self.position.x
        if self.deltaPosition > CGFloat.leastNonzeroMagnitude {
            self.deltaPosition = self.ease.lerp(self.deltaPosition, from: 0, to: self.distance)
            let progress = CGFloat(self.ease.perform(TimeInterval(self.deltaPosition / self.distance)))
            if let vc = self.backwardViewController {
                vc.view.frame = self.backwardBeginFrame.lerp(self.backwardEndFrame, progress: progress)
                vc.view.isHidden = false
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentBackwardEndFrame, progress: progress)
                self.finishMode = (self.deltaPosition > self.distance * self.finishDistanceRate) ? .backward : .none
            } else {
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentBackwardEndFrame, progress: progress * self.deceleration)
                self.finishMode = .none
            }
            if let vc = self.forwardViewController {
                vc.view.frame = self.currentForwardEndFrame
                vc.view.isHidden = true
            }
        } else if self.deltaPosition < CGFloat.leastNonzeroMagnitude {
            self.deltaPosition = self.ease.lerp(self.deltaPosition, from: 0, to: -self.distance)
            let progress = -self.deltaPosition / self.distance
            if let vc = self.forwardViewController {
                vc.view.frame = self.forwardBeginFrame.lerp(self.forwardEndFrame, progress: progress)
                vc.view.isHidden = false
                self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentForwardEndFrame, progress: progress)
                self.finishMode = (-self.deltaPosition > self.distance * self.finishDistanceRate) ? .forward : .none
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
