//
//  Quickly
//

public class QHamburgerViewControllerAnimation : IQHamburgerViewControllerFixedAnimation {
    
    public var leftSize: CGFloat
    public var rightSize: CGFloat
    public var acceleration: CGFloat
    
    init(
        leftSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        rightSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        acceleration: CGFloat = UIScreen.main.bounds.height * 0.85
    ) {
        self.leftSize = leftSize
        self.rightSize = rightSize
        self.acceleration = acceleration
    }
    
    public func layout(
        contentView: UIView,
        state: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?
    ) {
        if let vc = contentViewController {
            vc.view.frame = self._contentFrame(contentView: contentView, state: state)
            contentView.bringSubviewToFront(vc.view)
        }
        leftViewController?.view.frame = self._leftFrame(contentView: contentView, state: state)
        rightViewController?.view.frame = self._rightFrame(contentView: contentView, state: state)
    }
    
    public func animate(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        targetState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController?,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        if currentState == .left { leftViewController?.willDismiss(animated: animated) }
        if currentState == .right { rightViewController?.willDismiss(animated: animated) }
        if targetState == .left { leftViewController?.willPresent(animated: animated) }
        if targetState == .right { rightViewController?.willPresent(animated: animated) }
        if animated == true {
            if let vc = contentViewController {
                vc.view.frame = self._contentFrame(contentView: contentView, state: currentState)
                contentView.bringSubviewToFront(vc.view)
            }
            leftViewController?.view.frame = self._leftFrame(contentView: contentView, state: currentState)
            rightViewController?.view.frame = self._rightFrame(contentView: contentView, state: currentState)
            let duration = self._duration(contentView: contentView, currentState: currentState, targetState: targetState)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                contentViewController?.view.frame = self._contentFrame(contentView: contentView, state: targetState)
                leftViewController?.view.frame = self._leftFrame(contentView: contentView, state: targetState)
                rightViewController?.view.frame = self._rightFrame(contentView: contentView, state: targetState)
            }, completion: { (completed) in
                if currentState == .left { leftViewController?.didDismiss(animated: animated) }
                if currentState == .right { rightViewController?.didDismiss(animated: animated) }
                if targetState == .left { leftViewController?.didPresent(animated: animated) }
                if targetState == .right { rightViewController?.didPresent(animated: animated) }
                complete()
            })
        } else {
            if let vc = contentViewController {
                vc.view.frame = self._contentFrame(contentView: contentView, state: targetState)
                contentView.bringSubviewToFront(vc.view)
            }
            leftViewController?.view.frame = self._leftFrame(contentView: contentView, state: targetState)
            rightViewController?.view.frame = self._rightFrame(contentView: contentView, state: targetState)
            if currentState == .left { leftViewController?.didDismiss(animated: animated) }
            if currentState == .right { rightViewController?.didDismiss(animated: animated) }
            if targetState == .left { leftViewController?.didPresent(animated: animated) }
            if targetState == .right { rightViewController?.didPresent(animated: animated) }
            complete()
        }
    }
    
}

private extension QHamburgerViewControllerAnimation {
    
    private func _duration(contentView: UIView, currentState: QHamburgerViewControllerState, targetState: QHamburgerViewControllerState) -> TimeInterval {
        let currentFrame = self._contentFrame(contentView: contentView, state: currentState)
        let targetFrame = self._contentFrame(contentView: contentView, state: targetState)
        return TimeInterval(abs(currentFrame.centerPoint.distance(to: targetFrame.centerPoint)) / self.acceleration)
    }
    
    func _contentFrame(contentView: UIView, state: QHamburgerViewControllerState) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle: return bounds
        case .left: return CGRect(x: bounds.origin.x + self.leftSize, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        case .right: return CGRect(x: bounds.origin.x - self.rightSize, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }
    }
    
    func _leftFrame(contentView: UIView, state: QHamburgerViewControllerState) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle, .right: return CGRect(x: bounds.origin.x - self.leftSize, y: bounds.origin.y, width: self.leftSize, height: bounds.height)
        case .left: return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: self.leftSize, height: bounds.height)
        }
    }
    
    func _rightFrame(contentView: UIView, state: QHamburgerViewControllerState) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle, .left: return CGRect(x: bounds.origin.x + bounds.width, y: bounds.origin.y, width: self.rightSize, height: bounds.height)
        case .right: return CGRect(x: (bounds.origin.x + bounds.width) - self.rightSize, y: bounds.origin.y, width: self.rightSize, height: bounds.height)
        }
    }
    
}
