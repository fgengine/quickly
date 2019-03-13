//
//  Quickly
//

public class QStackViewControllerPresentAnimation : IQStackViewControllerPresentAnimation {

    public var containerViewController: IQStackContainerViewController!
    public var currentBeginFrame: CGRect
    public var currentEndFrame: CGRect
    public var currentViewController: IQStackViewController!
    public var currentGroupbarVisibility: CGFloat
    public var nextBeginFrame: CGRect
    public var nextEndFrame: CGRect
    public var nextViewController: IQStackViewController!
    public var nextGroupbarVisibility: CGFloat
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    public var duration: TimeInterval {
        get { return TimeInterval(abs(self.nextBeginFrame.midX - self.nextEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200) {
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.currentGroupbarVisibility = 1
        self.nextBeginFrame = CGRect.zero
        self.nextEndFrame = CGRect.zero
        self.nextGroupbarVisibility = 1
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        nextViewController: IQStackViewController,
        nextGroupbarVisibility: CGFloat
    ) {
        let frame = contentView.bounds
        
        self.containerViewController = containerViewController

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.layoutIfNeeded()
        self.currentGroupbarVisibility = currentGroupbarVisibility

        self.nextBeginFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.nextEndFrame = frame
        self.nextViewController = nextViewController
        self.nextViewController.view.frame = self.nextBeginFrame
        self.nextViewController.layoutIfNeeded()
        self.nextGroupbarVisibility = nextGroupbarVisibility

        containerViewController.groupbarVisibility = currentGroupbarVisibility
        contentView.bringSubviewToFront(self.nextViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.nextViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                self.containerViewController.groupbarVisibility = self.nextGroupbarVisibility
                self.containerViewController.layoutIfNeeded()
                self.currentViewController.view.frame = self.currentEndFrame
                self.nextViewController.view.frame = self.nextEndFrame
            }, completion: { (completed: Bool) in
                self.containerViewController.groupbarVisibility = self.nextGroupbarVisibility
                self.currentViewController.view.frame = self.currentEndFrame
                self.currentViewController.didDismiss(animated: animated)
                self.currentViewController = nil
                self.nextViewController.view.frame = self.nextEndFrame
                self.nextViewController.didPresent(animated: animated)
                self.nextViewController = nil
                self.containerViewController = nil
                complete(completed)
            })
        } else {
            self.containerViewController.groupbarVisibility = self.nextGroupbarVisibility
            self.containerViewController = nil
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

    public var containerViewController: IQStackContainerViewController!
    public var currentBeginFrame: CGRect
    public var currentEndFrame: CGRect
    public var currentViewController: IQStackViewController!
    public var currentGroupbarVisibility: CGFloat
    public var previousBeginFrame: CGRect
    public var previousEndFrame: CGRect
    public var previousViewController: IQStackViewController!
    public var previousGroupbarVisibility: CGFloat
    public var overlapping: CGFloat
    public var acceleration: CGFloat
    public var duration: TimeInterval {
        get { return TimeInterval(abs(self.currentBeginFrame.midX - self.currentEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200) {
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.currentGroupbarVisibility = 1
        self.previousBeginFrame = CGRect.zero
        self.previousEndFrame = CGRect.zero
        self.previousGroupbarVisibility = 1
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat
    ) {
        let frame = contentView.bounds
        
        self.containerViewController = containerViewController

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.layoutIfNeeded()
        self.currentGroupbarVisibility = currentGroupbarVisibility

        self.previousBeginFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        self.previousEndFrame = frame
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame
        self.previousViewController.layoutIfNeeded()
        self.previousGroupbarVisibility = previousGroupbarVisibility

        containerViewController.groupbarVisibility = currentGroupbarVisibility
        contentView.bringSubviewToFront(self.currentViewController.view)
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            self.currentViewController.willDismiss(animated: animated)
            self.previousViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                self.containerViewController.groupbarVisibility = self.previousGroupbarVisibility
                self.containerViewController.layoutIfNeeded()
                self.currentViewController.view.frame = self.currentEndFrame
                self.previousViewController.view.frame = self.previousEndFrame
            }, completion: { (completed: Bool) in
                self.containerViewController.groupbarVisibility = self.previousGroupbarVisibility
                self.currentViewController.view.frame = self.currentEndFrame
                self.currentViewController.didDismiss(animated: animated)
                self.currentViewController = nil
                self.previousViewController.view.frame = self.previousEndFrame
                self.previousViewController.didPresent(animated: animated)
                self.previousViewController = nil
                self.containerViewController = nil
                complete(completed)
            })
        } else {
            self.containerViewController.groupbarVisibility = self.previousGroupbarVisibility
            self.containerViewController = nil
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
