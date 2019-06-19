//
//  Quickly
//

public class QStackViewControllerinteractiveDismissAnimation : IQStackViewControllerInteractiveDismissAnimation {

    public var containerViewController: IQStackContainerViewController!
    public var shadow: QViewShadow
    public var currentBeginFrame: CGRect
    public var currentEndFrame: CGRect
    public var currentViewController: IQStackViewController!
    public var currentGroupbarVisibility: CGFloat
    public var previousBeginFrame: CGRect
    public var previousEndFrame: CGRect
    public var previousViewController: IQStackViewController!
    public var previousGroupbarVisibility: CGFloat
    public var position: CGPoint
    public var deltaPosition: CGFloat
    public var velocity: CGPoint
    public var distance: CGFloat
    public var dismissDistanceRate: CGFloat
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    public var ease: IQAnimationEase
    public private(set) var canFinish: Bool

    public init(
        shadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        overlapping: CGFloat = 1,
        acceleration: CGFloat = 1200,
        dismissDistanceRate: CGFloat = 0.4
    ) {
        self.shadow = shadow
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.currentGroupbarVisibility = 1
        self.previousBeginFrame = CGRect.zero
        self.previousEndFrame = CGRect.zero
        self.previousGroupbarVisibility = 1
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.distance = 0
        self.dismissDistanceRate = dismissDistanceRate
        self.overlapping = overlapping
        self.acceleration = acceleration
        self.ease = QAnimationEaseQuadraticOut()
        self.canFinish = false
    }

    public func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat,
        position: CGPoint,
        velocity: CGPoint
    ) {
        let bounds = contentView.bounds

        self.containerViewController = containerViewController
        
        self.currentBeginFrame = bounds
        self.currentEndFrame =  CGRect(
            x: bounds.maxX,
            y: bounds.minY,
            width: bounds.width,
            height: bounds.height
        )
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.view.shadow = self.shadow
        self.currentViewController.layoutIfNeeded()
        self.currentViewController.prepareInteractiveDismiss()
        self.currentGroupbarVisibility = currentGroupbarVisibility
        
        self.previousBeginFrame = CGRect(
            x: bounds.minX - (bounds.width * self.overlapping),
            y: bounds.minY,
            width: bounds.width,
            height: bounds.height
        )
        self.previousEndFrame = bounds
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame
        self.previousViewController.layoutIfNeeded()
        self.previousViewController.prepareInteractivePresent()
        self.previousGroupbarVisibility = previousGroupbarVisibility
        
        self.position = position
        self.velocity = velocity
        self.distance = bounds.width

        containerViewController.groupbarVisibility = currentGroupbarVisibility
        contentView.insertSubview(currentViewController.view, aboveSubview: previousViewController.view)
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = self.ease.lerp(max(0, position.x - self.position.x), from: 0, to: self.distance)
        let progress = self.deltaPosition / self.distance
        self.containerViewController.groupbarVisibility = self.currentGroupbarVisibility.lerp(self.previousGroupbarVisibility, progress: progress)
        self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentEndFrame, progress: progress)
        self.previousViewController.view.frame = self.previousBeginFrame.lerp(self.previousEndFrame, progress: progress)
        self.canFinish = self.deltaPosition > (self.distance * self.dismissDistanceRate)
    }
    
    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval((self.distance - self.deltaPosition) / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.containerViewController.groupbarVisibility = self.previousGroupbarVisibility
            self.currentViewController.view.frame = self.currentEndFrame
            self.previousViewController.view.frame = self.previousEndFrame
        }, completion: { [weak self] (completed: Bool) in
            if let self = self {
                self.containerViewController.groupbarVisibility = self.previousGroupbarVisibility
                self.containerViewController = nil
                self.currentViewController.view.frame = self.currentEndFrame
                self.currentViewController.view.shadow = nil
                self.currentViewController.finishInteractiveDismiss()
                self.currentViewController = nil
                self.previousViewController.view.frame = self.previousEndFrame
                self.previousViewController.finishInteractivePresent()
                self.previousViewController = nil
            }
            complete(completed)
        })
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.containerViewController.groupbarVisibility = self.currentGroupbarVisibility
            self.currentViewController.view.frame = self.currentBeginFrame
            self.previousViewController.view.frame = self.previousBeginFrame
        }, completion: { [weak self] (completed: Bool) in
            if let self = self {
                self.containerViewController.groupbarVisibility = self.currentGroupbarVisibility
                self.containerViewController = nil
                self.currentViewController.view.frame = self.currentBeginFrame
                self.currentViewController.view.shadow = nil
                self.currentViewController.cancelInteractiveDismiss()
                self.currentViewController = nil
                self.previousViewController.view.frame = self.previousBeginFrame
                self.previousViewController.cancelInteractivePresent()
                self.previousViewController = nil
            }
            complete(completed)
        })
    }

}
