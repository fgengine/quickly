//
//  Quickly
//

public final class QStackViewControllerPresentAnimation : IQStackViewControllerPresentAnimation {

    public var shadow: QViewShadow
    public var overlapping: CGFloat
    public var acceleration: CGFloat

    public init(
        shadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        overlapping: CGFloat = 1,
        acceleration: CGFloat = 1200
    ) {
        self.shadow = shadow
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func animate(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        nextViewController: IQStackViewController,
        nextGroupbarVisibility: CGFloat,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        let nextBeginFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        let nextEndFrame = frame

        currentViewController.view.frame = currentBeginFrame
        currentViewController.layoutIfNeeded()
        nextViewController.view.frame = nextBeginFrame
        nextViewController.view.shadow = self.shadow
        nextViewController.layoutIfNeeded()
        containerViewController.groupbarVisibility = currentGroupbarVisibility
        contentView.bringSubviewToFront(nextViewController.view)
        
        if animated == true {
            currentViewController.willDismiss(animated: animated)
            nextViewController.willPresent(animated: animated)
            let duration = TimeInterval(abs(nextBeginFrame.midX - nextEndFrame.midX) / self.acceleration)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                containerViewController.groupbarVisibility = nextGroupbarVisibility
                containerViewController.layoutIfNeeded()
                currentViewController.view.frame = currentEndFrame
                nextViewController.view.frame = nextEndFrame
            }, completion: { (completed) in
                containerViewController.groupbarVisibility = nextGroupbarVisibility
                currentViewController.view.frame = currentEndFrame
                currentViewController.didDismiss(animated: animated)
                nextViewController.view.frame = nextEndFrame
                nextViewController.view.shadow = nil
                nextViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            containerViewController.groupbarVisibility = nextGroupbarVisibility
            currentViewController.willDismiss(animated: animated)
            currentViewController.didDismiss(animated: animated)
            currentViewController.view.frame = currentEndFrame
            nextViewController.willPresent(animated: animated)
            nextViewController.didPresent(animated: animated)
            nextViewController.view.frame = nextEndFrame
            nextViewController.view.shadow = nil
            complete()
        }
    }

}

public final class QStackViewControllerDismissAnimation : IQStackViewControllerDismissAnimation {

    public var shadow: QViewShadow
    public var overlapping: CGFloat
    public var acceleration: CGFloat

    public init(
        shadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        overlapping: CGFloat = 1,
        acceleration: CGFloat = 1200
    ) {
        self.shadow = shadow
        self.overlapping = overlapping
        self.acceleration = acceleration
    }

    public func animate(
        containerViewController: IQStackContainerViewController,
        contentView: UIView,
        currentViewController: IQStackViewController,
        currentGroupbarVisibility: CGFloat,
        previousViewController: IQStackViewController,
        previousGroupbarVisibility: CGFloat,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        let frame = contentView.bounds
        let currentBeginFrame = frame
        let currentEndFrame = CGRect(x: frame.maxX, y: frame.minY, width: frame.width, height: frame.height)
        let previousBeginFrame = CGRect(x: frame.minX - (frame.width * self.overlapping), y: frame.minY, width: frame.width, height: frame.height)
        let previousEndFrame = frame

        currentViewController.view.frame = currentBeginFrame
        currentViewController.view.shadow = self.shadow
        currentViewController.layoutIfNeeded()
        previousViewController.view.frame = previousBeginFrame
        previousViewController.layoutIfNeeded()
        containerViewController.groupbarVisibility = currentGroupbarVisibility
        contentView.bringSubviewToFront(currentViewController.view)
        
        if animated == true {
            currentViewController.willDismiss(animated: animated)
            previousViewController.willPresent(animated: animated)
            let duration = TimeInterval(abs(currentBeginFrame.midX - currentEndFrame.midX) / self.acceleration)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                containerViewController.groupbarVisibility = previousGroupbarVisibility
                containerViewController.layoutIfNeeded()
                currentViewController.view.frame = currentEndFrame
                previousViewController.view.frame = previousEndFrame
            }, completion: { (completed) in
                containerViewController.groupbarVisibility = previousGroupbarVisibility
                currentViewController.view.frame = currentEndFrame
                currentViewController.view.shadow = nil
                currentViewController.didDismiss(animated: animated)
                previousViewController.view.frame = previousEndFrame
                previousViewController.didPresent(animated: animated)
                complete()
            })
        } else {
            containerViewController.groupbarVisibility = previousGroupbarVisibility
            currentViewController.willDismiss(animated: animated)
            currentViewController.didDismiss(animated: animated)
            currentViewController.view.frame = currentEndFrame
            currentViewController.view.shadow = nil
            previousViewController.willPresent(animated: animated)
            previousViewController.didPresent(animated: animated)
            previousViewController.view.frame = previousEndFrame
            complete()
        }
    }

}
