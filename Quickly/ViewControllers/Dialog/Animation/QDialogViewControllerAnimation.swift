//
//  Quickly
//

public final class QDialogViewControllerPresentAnimation : IQDialogViewControllerFixedAnimation {
    
    public var duration: TimeInterval
    public var verticalOffset: CGFloat

    public init(duration: TimeInterval = 0.2, verticalOffset: CGFloat = 50) {
        self.duration = duration
        self.verticalOffset = verticalOffset
    }

    public func animate(
        viewController: IQDialogViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        if animated == true {
            let originalVerticalAlignment = viewController.verticalAlignment
            let originalAlpha = viewController.view.alpha
            viewController.willPresent(animated: animated)
            switch originalVerticalAlignment {
            case .top(let offset): viewController.verticalAlignment = .top(offset: offset - self.verticalOffset)
            case .center(let offset): viewController.verticalAlignment = .center(offset: offset - self.verticalOffset)
            case .bottom(let offset): viewController.verticalAlignment = .bottom(offset: offset - self.verticalOffset)
            }
            viewController.layoutIfNeeded()
            viewController.view.alpha = 0
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                viewController.verticalAlignment = originalVerticalAlignment
                viewController.view.alpha = originalAlpha
                viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                viewController.didPresent(animated: animated)
                complete()
            })
        } else {
            viewController.willPresent(animated: animated)
            viewController.didPresent(animated: animated)
            complete()
        }
    }

}

public final class QDialogViewControllerDismissAnimation : IQDialogViewControllerFixedAnimation {
    
    public var duration: TimeInterval
    public var verticalOffset: CGFloat

    public init(duration: TimeInterval = 0.2, verticalOffset: CGFloat = 200) {
        self.duration = duration
        self.verticalOffset = verticalOffset
    }
    
    public func animate(
        viewController: IQDialogViewController,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        if animated == true {
            let originalVerticalAlignment = viewController.verticalAlignment
            let originalAlpha = viewController.view.alpha
            viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                switch originalVerticalAlignment {
                case .top(let offset): viewController.verticalAlignment = .top(offset: offset - self.verticalOffset)
                case .center(let offset): viewController.verticalAlignment = .center(offset: offset - self.verticalOffset)
                case .bottom(let offset): viewController.verticalAlignment = .bottom(offset: offset - self.verticalOffset)
                }
                viewController.view.alpha = 0
                viewController.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                viewController.verticalAlignment = originalVerticalAlignment
                viewController.view.alpha = originalAlpha
                viewController.didDismiss(animated: animated)
                complete()
            })
        } else {
            viewController.willDismiss(animated: animated)
            viewController.didDismiss(animated: animated)
            complete()
        }
    }

}
