//
//  Quickly
//

public final class QHamburgerViewControllerInteractiveAnimation : IQHamburgerViewControllerInteractiveAnimation {
    
    public var contentView: UIView!
    public var currentState: QHamburgerViewControllerState
    public var targetState: QHamburgerViewControllerState
    public var contentViewController: IQHamburgerViewController!
    public var contentShadow: QViewShadow
    public var contentBeginFrame: CGRect!
    public var contentEndFrame: CGRect!
    public var leftSize: CGFloat
    public var leftViewController: IQHamburgerViewController?
    public var leftBeginFrame: CGRect!
    public var leftEndFrame: CGRect!
    public var rightSize: CGFloat
    public var rightViewController: IQHamburgerViewController?
    public var rightBeginFrame: CGRect!
    public var rightEndFrame: CGRect!
    public var position: CGPoint
    public var deltaPosition: CGFloat
    public var velocity: CGPoint
    public var acceleration: CGFloat
    public var finishDistanceRate: CGFloat
    public var ease: IQAnimationEase
    public var canFinish: Bool
    
    init(
        contentShadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        leftSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        rightSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        acceleration: CGFloat = 1200,
        finishDistanceRate: CGFloat = 0.4
    ) {
        self.currentState = .idle
        self.targetState = .idle
        self.contentShadow = contentShadow
        self.leftSize = leftSize
        self.rightSize = rightSize
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.acceleration = acceleration
        self.finishDistanceRate = finishDistanceRate
        self.ease = QAnimationEaseQuadraticOut()
        self.canFinish = false
    }
    
    public func prepare(
        contentView: UIView,
        currentState: QHamburgerViewControllerState,
        targetState: QHamburgerViewControllerState,
        contentViewController: IQHamburgerViewController,
        leftViewController: IQHamburgerViewController?,
        rightViewController: IQHamburgerViewController?,
        position: CGPoint,
        velocity: CGPoint
    ) {
        self.contentView = contentView
        self.currentState = currentState
        self.targetState = targetState
        self.contentViewController = contentViewController
        self.contentBeginFrame = self._contentFrame(contentView: contentView, state: currentState)
        self.contentEndFrame = self._contentFrame(contentView: contentView, state: targetState)
        self.leftViewController = leftViewController
        self.leftBeginFrame = self._leftFrame(contentView: contentView, state: currentState)
        self.leftEndFrame = self._leftFrame(contentView: contentView, state: targetState)
        self.rightViewController = rightViewController
        self.rightBeginFrame = self._rightFrame(contentView: contentView, state: currentState)
        self.rightEndFrame = self._rightFrame(contentView: contentView, state: targetState)
        self.position = position
        self.velocity = velocity
        
        self.contentView.bringSubviewToFront(self.contentViewController.view)
        self.contentViewController.view.frame = self.contentBeginFrame
        self.contentViewController.view.shadow = self.contentShadow
        if let vc = self.leftViewController {
            vc.view.frame = self.leftBeginFrame
            if currentState == .left { vc.prepareInteractiveDismiss() }
            if targetState == .left { vc.prepareInteractivePresent() }
        }
        if let vc = self.rightViewController {
            vc.view.frame = self.rightBeginFrame
            if currentState == .right { vc.prepareInteractiveDismiss() }
            if targetState == .right { vc.prepareInteractivePresent() }
        }
    }
    
    public func update(position: CGPoint, velocity: CGPoint) {
        var delta: CGFloat = position.x - self.position.x
        switch self.currentState {
        case .idle:
            switch self.targetState {
            case .idle, .left: break
            case .right: delta = -delta
            }
        case .left:
            switch self.targetState {
            case .idle, .right: delta = -delta
            case .left: break
            }
        case .right: break
        }
        let distance = self._distance()
        self.deltaPosition = self.ease.lerp(max(0, min(delta, distance)), from: 0, to: distance)
        let progress = self.deltaPosition / distance
        self.contentViewController.view.frame = self.contentBeginFrame.lerp(self.contentEndFrame, progress: progress)
        self.leftViewController?.view.frame = self.leftBeginFrame.lerp(self.leftEndFrame, progress: progress)
        self.rightViewController?.view.frame = self.rightBeginFrame.lerp(self.rightEndFrame, progress: progress)
        self.canFinish = self.deltaPosition > (distance * self.finishDistanceRate)
    }
    
    public func finish(_ complete: @escaping (_ state: QHamburgerViewControllerState) -> Void) {
        let distance = self._distance()
        let duration = TimeInterval((distance - self.deltaPosition) / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.contentViewController.view.frame = self.contentEndFrame
            self.leftViewController?.view.frame = self.leftEndFrame
            self.rightViewController?.view.frame = self.rightEndFrame
        }, completion: { [weak self] (completed: Bool) in
            guard let self = self else { return }
            self.contentViewController.view.frame = self.contentEndFrame
            self.contentViewController.view.shadow = self.targetState != .idle ? self.contentShadow : nil
            self.contentViewController = nil
            if let vc = self.leftViewController {
                vc.view.frame = self.leftEndFrame
                if self.currentState == .left { vc.finishInteractiveDismiss() }
                if self.targetState == .left { vc.finishInteractivePresent() }
                self.leftViewController = nil
            }
            if let vc = self.rightViewController {
                vc.view.frame = self.rightEndFrame
                if self.currentState == .left { vc.finishInteractiveDismiss() }
                if self.targetState == .left { vc.finishInteractivePresent() }
                self.rightViewController = nil
            }
            complete(self.targetState)
        })
    }
    
    public func cancel(_ complete: @escaping (_ state: QHamburgerViewControllerState) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.contentViewController.view.frame = self.contentBeginFrame
            self.leftViewController?.view.frame = self.leftBeginFrame
            self.rightViewController?.view.frame = self.rightBeginFrame
        }, completion: { [weak self] (completed: Bool) in
            guard let self = self else { return }
            self.contentViewController.view.frame = self.contentBeginFrame
            self.contentViewController.view.shadow = self.currentState != .idle ? self.contentShadow : nil
            self.contentViewController = nil
            if let vc = self.leftViewController {
                vc.view.frame = self.leftBeginFrame
                if self.currentState == .left { vc.cancelInteractiveDismiss() }
                if self.targetState == .left { vc.cancelInteractivePresent() }
                self.leftViewController = nil
            }
            if let vc = self.rightViewController {
                vc.view.frame = self.rightBeginFrame
                if self.currentState == .left { vc.cancelInteractiveDismiss() }
                if self.targetState == .left { vc.cancelInteractivePresent() }
                self.rightViewController = nil
            }
            complete(self.currentState)
        })
    }
    
}

// MARK: Private

private extension QHamburgerViewControllerInteractiveAnimation {
    
    func _distance() -> CGFloat {
        switch self.currentState {
        case .idle:
            switch self.targetState {
            case .idle: return 0
            case .left: return self.leftSize
            case .right: return self.rightSize
            }
        case .left:
            switch self.targetState {
            case .idle: return self.leftSize
            case .left: return 0
            case .right: return self.leftSize + self.rightSize
            }
        case .right:
            switch self.targetState {
            case .idle: return self.rightSize
            case .left: return self.leftSize + self.rightSize
            case .right: return 0
            }
        }
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
