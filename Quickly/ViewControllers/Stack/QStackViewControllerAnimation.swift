//
//  Quickly
//

public class QStackViewControllerPresentAnimation : IQStackViewControllerPresentAnimation {

    internal var currentBeginFrame: CGRect
    internal var currentEndFrame: CGRect
    internal var currentViewController: IQStackViewController!
    internal var nextBeginFrame: CGRect
    internal var nextEndFrame: CGRect
    internal var nextViewController: IQStackViewController!
    internal var overlapping: CGFloat
    internal var acceleration: CGFloat
    internal var duration: TimeInterval {
        get { return TimeInterval(abs(self.nextBeginFrame.midX - self.nextEndFrame.midX) / self.acceleration) }
    }

    public init(overlapping: CGFloat = 1, acceleration: CGFloat = 1200) {
        self.currentBeginFrame = CGRect.zero
        self.currentEndFrame = CGRect.zero
        self.nextBeginFrame = CGRect.zero
        self.nextEndFrame = CGRect.zero
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        currentViewController: IQStackViewController,
        nextViewController: IQStackViewController
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
    internal var currentViewController: IQStackViewController!
    internal var previousBeginFrame: CGRect
    internal var previousEndFrame: CGRect
    internal var previousViewController: IQStackViewController!
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
        currentViewController: IQStackViewController,
        previousViewController: IQStackViewController
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
