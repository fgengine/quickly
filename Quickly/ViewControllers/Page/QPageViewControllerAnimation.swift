//
//  Quickly
//

public class QPageViewControllerAnimation : IQPageViewControllerAnimation {

    internal var contentView: UIView!
    internal var currentViewController: IQPageViewController!
    internal var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var currentEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    internal var targetViewController: IQPageViewController!
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
        currentViewController: IQPageViewController,
        targetViewController: IQPageViewController
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
