//
//  Quickly
//

open class QStackViewControllerPresentAnimation : IQStackViewControllerPresentAnimation {

    open var contentView: UIView!

    open var currentBeginFrame: CGRect = CGRect.zero
    open var currentEndFrame: CGRect = CGRect.zero
    open var currentViewController: IQStackPageViewController!

    open var nextBeginFrame: CGRect = CGRect.zero
    open var nextEndFrame: CGRect = CGRect.zero
    open var nextViewController: IQStackPageViewController!

    open var acceleration: CGFloat

    public init(acceleration: CGFloat = 1200) {
        self.acceleration = acceleration
    }

    open func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        nextViewController: IQStackPageViewController
    ) {
        let frame = contentView.bounds

        self.contentView = contentView

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.minX - (frame.width * 0.5), y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame

        self.nextBeginFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.nextEndFrame = frame
        self.nextViewController = nextViewController
        self.nextViewController.view.frame = self.nextBeginFrame

        self.contentView.bringSubview(toFront: self.nextViewController.view)
    }

    open func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            let duration = TimeInterval(abs(self.nextBeginFrame.midX - self.nextEndFrame.midX) / self.acceleration)
            self.currentViewController.willDismiss(animated: animated)
            self.nextViewController.willPresent(animated: animated)
            UIView.animate(withDuration: duration, animations: {
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
        }
    }

}

open class QStackViewControllerDismissAnimation : IQStackViewControllerDismissAnimation {

    open var contentView: UIView!

    open var currentBeginFrame: CGRect = CGRect.zero
    open var currentEndFrame: CGRect = CGRect.zero
    open var currentViewController: IQStackPageViewController!

    open var previousBeginFrame: CGRect = CGRect.zero
    open var previousEndFrame: CGRect = CGRect.zero
    open var previousViewController: IQStackPageViewController!

    open var acceleration: CGFloat

    public init(acceleration: CGFloat = 1200) {
        self.acceleration = acceleration
    }

    open func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController
    ) {
        let frame = contentView.bounds

        self.contentView = contentView

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame

        self.previousBeginFrame = CGRect(x: frame.minX - (frame.width * 0.5), y: frame.minY, width: frame.width, height: frame.height)
        self.previousEndFrame = frame
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame

        self.contentView.bringSubview(toFront: self.currentViewController.view)
    }

    open func update(animated: Bool, complete: @escaping (Bool) -> Void) {
        if animated == true {
            let duration = TimeInterval(abs(self.currentBeginFrame.midX - self.currentEndFrame.midX) / self.acceleration)
            self.currentViewController.willDismiss(animated: animated)
            self.previousViewController.willPresent(animated: animated)
            UIView.animate(withDuration: duration, animations: {
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
        }
    }

}

open class QStackViewControllerinteractiveDismissAnimation : IQStackViewControllerinteractiveDismissAnimation {

    open var contentView: UIView!
    open var currentBeginFrame: CGRect = CGRect.zero
    open var currentEndFrame: CGRect = CGRect.zero
    open var currentViewController: IQStackPageViewController!
    open var previousBeginFrame: CGRect = CGRect.zero
    open var previousEndFrame: CGRect = CGRect.zero
    open var previousViewController: IQStackPageViewController!
    open var position: CGPoint = CGPoint.zero
    open private(set) var deltaPosition: CGFloat = 0
    open var velocity: CGPoint = CGPoint.zero
    open private(set) var fullDistance: CGFloat = 0
    open private(set) var finishDistance: CGFloat = 80
    open var acceleration: CGFloat
    open var canFinish: Bool = false

    public init(acceleration: CGFloat = 1200) {
        self.acceleration = acceleration
    }

    open func prepare(
        contentView: UIView,
        currentViewController: IQStackPageViewController,
        previousViewController: IQStackPageViewController,
        position: CGPoint,
        velocity: CGPoint
    ) {
        let frame = contentView.bounds

        self.contentView = contentView

        self.currentBeginFrame = frame
        self.currentEndFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame
        self.currentViewController.prepareInteractiveDismiss()

        self.previousBeginFrame = CGRect(x: frame.minX - (frame.width * 0.5), y: frame.minY, width: frame.width, height: frame.height)
        self.previousEndFrame = frame
        self.previousViewController = previousViewController
        self.previousViewController.view.frame = self.previousBeginFrame
        self.previousViewController.prepareInteractivePresent()

        self.position = position
        self.velocity = velocity
        self.fullDistance = frame.width
        self.finishDistance = self.fullDistance / 2

        self.contentView.bringSubview(toFront: self.currentViewController.view)
    }

    open func update(position: CGPoint, velocity: CGPoint) {
        self.deltaPosition = max(0, position.x - self.position.x)
        let progress = self.deltaPosition / self.fullDistance
        self.currentViewController.view.frame = self.currentBeginFrame.lerp(self.currentEndFrame, progress: progress)
        self.previousViewController.view.frame = self.previousBeginFrame.lerp(self.previousEndFrame, progress: progress)
        self.canFinish = self.deltaPosition > self.finishDistance
    }

    open func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
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

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
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
