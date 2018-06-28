//
//  Quickly
//

public class QModalViewControllerAnimation : IQModalViewControllerFixedAnimation {

    public var contentView: UIView!
    public var previousBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var previousEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var previousViewController: IQModalViewController?
    public var currentBeginFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var currentEndFrame: CGRect {
        get { return self.contentView.bounds }
    }
    public var currentViewController: IQModalViewController!
    public var acceleration: CGFloat
    public var duration: TimeInterval {
        get {
            let distance = self.currentBeginFrame.centerPoint.distance(to: self.currentEndFrame.centerPoint)
            return TimeInterval(abs(distance) / self.acceleration)
        }
    }

    public init(acceleration: CGFloat = 1400) {
        self.acceleration = acceleration
    }

    public func prepare(
        contentView: UIView,
        previousViewController: IQModalViewController?,
        currentViewController: IQModalViewController
    ) {
        self.contentView = contentView
        self.previousViewController = previousViewController
        if let vc = self.previousViewController {
            vc.view.frame = self.previousBeginFrame
        }
        self.currentViewController = currentViewController
        self.currentViewController.view.frame = self.currentBeginFrame

        if let vc = self.previousViewController {
            contentView.insertSubview(currentViewController.view, aboveSubview: vc.view)
        } else {
            contentView.bringSubview(toFront: currentViewController.view)
        }
    }

    public func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
    }

}

public class QModalViewControllerPresentAnimation : QModalViewControllerAnimation {

    public override var currentBeginFrame: CGRect {
        get {
            let bounds = super.currentBeginFrame
            return CGRect(
                x: bounds.minX,
                y: bounds.maxY,
                width: bounds.width,
                height: bounds.height
            )
        }
    }

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            if let vc = self.previousViewController {
                vc.willDismiss(animated: animated)
            }
            self.currentViewController.willPresent(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .curveEaseOut ], animations: {
                if let vc = self.previousViewController {
                    vc.view.frame = self.previousEndFrame
                }
                self.currentViewController.view.frame = self.currentEndFrame
            }, completion: { (completed: Bool) in
                if let vc = self.previousViewController {
                    vc.didDismiss(animated: animated)
                    self.previousViewController = nil
                }
                self.currentViewController.didPresent(animated: animated)
                self.currentViewController = nil
                complete(completed)
            })
        } else {
            if let vc = self.previousViewController {
                vc.willDismiss(animated: animated)
                vc.didDismiss(animated: animated)
                vc.view.frame = self.previousEndFrame
                self.previousViewController = nil
            }
            self.currentViewController.willPresent(animated: animated)
            self.currentViewController.didPresent(animated: animated)
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController = nil
            complete(true)
        }
    }

}

public class QModalViewControllerDismissAnimation : QModalViewControllerAnimation {

    public override var currentEndFrame: CGRect {
        get {
            let bounds = super.currentEndFrame
            return CGRect(
                x: bounds.minX,
                y: bounds.maxY,
                width: bounds.width,
                height: bounds.height
            )
        }
    }

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            if let vc = self.previousViewController {
                vc.willPresent(animated: animated)
            }
            self.currentViewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .curveEaseOut ], animations: {
                if let vc = self.previousViewController {
                    vc.view.frame = self.previousEndFrame
                }
                self.currentViewController.view.frame = self.currentEndFrame
            }, completion: { (completed: Bool) in
                if let vc = self.previousViewController {
                    vc.didPresent(animated: animated)
                    self.previousViewController = nil
                }
                self.currentViewController.didDismiss(animated: animated)
                self.currentViewController = nil
                complete(completed)
            })
        } else {
            if let vc = self.previousViewController {
                vc.willPresent(animated: animated)
                vc.didPresent(animated: animated)
                vc.view.frame = self.previousEndFrame
                self.previousViewController = nil
            }
            self.currentViewController.willDismiss(animated: animated)
            self.currentViewController.didDismiss(animated: animated)
            self.currentViewController.view.frame = self.currentEndFrame
            self.currentViewController = nil
            complete(true)
        }
    }

}
