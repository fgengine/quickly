//
//  Quickly
//

import UIKit

public final class QJalousieViewControllerInteractiveAnimation : IQJalousieViewControllerInteractiveAnimation {
    
    public var contentView: UIView!
    public var currentState: QJalousieViewControllerState
    public var targetState: QJalousieViewControllerState
    
    public var contentViewController: IQJalousieViewController?
    public var contentFullscreenFrame: CGRect!
    public var contentShowedFrame: CGRect!
    public var contentClosedFrame: CGRect!
    
    public var detailViewController: IQJalousieViewController?
    public var detailFullscreenSize: CGFloat
    public var detailFullscreenFrame: CGRect!
    public var detailShowedSize: CGFloat
    public var detailShowedFrame: CGRect!
    public var detailClosedFrame: CGRect!

    public var position: CGPoint
    public var deltaPosition: CGFloat
    public var velocity: CGPoint
    public var acceleration: CGFloat
    public var ease: IQAnimationEase
    public var canFinish: Bool
    
    public init(
        contentShadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        detailFullscreenSize: CGFloat = UIScreen.main.bounds.height,
        detailShowedSize: CGFloat = UIScreen.main.bounds.height * 0.5,
        acceleration: CGFloat = 1200,
        ease: IQAnimationEase = QAnimationEaseLinear()
    ) {
        self.currentState = .closed
        self.targetState = .closed
        self.detailFullscreenSize = detailFullscreenSize
        self.detailShowedSize = detailShowedSize
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.acceleration = acceleration
        self.ease = ease
        self.canFinish = false
    }
    
    public func prepare(
        contentView: UIView,
        state: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?,
        position: CGPoint,
        velocity: CGPoint
    ) {
        self.contentView = contentView
        self.currentState = state
        self.targetState = state
        self.contentViewController = contentViewController
        self.contentFullscreenFrame = self._contentFrame(contentView: contentView, state: .fullscreen)
        self.contentShowedFrame = self._contentFrame(contentView: contentView, state: .showed)
        self.contentClosedFrame = self._contentFrame(contentView: contentView, state: .closed)
        self.detailViewController = detailViewController
        self.detailFullscreenFrame = self._detailFrame(contentView: contentView, state: .fullscreen)
        self.detailShowedFrame = self._detailFrame(contentView: contentView, state: .showed)
        self.detailClosedFrame = self._detailFrame(contentView: contentView, state: .closed)
        self.position = position
        self.velocity = velocity
        
        if let vc = self.detailViewController {
            switch state {
            case .closed: vc.view.frame = self.detailClosedFrame
            case .showed: vc.view.frame = self.detailShowedFrame
            case .fullscreen: vc.view.frame = self.detailFullscreenFrame
            }
            self.contentView.bringSubviewToFront(vc.view)
        }
    }
    
    public func update(position: CGPoint, velocity: CGPoint) {
        var positionDelta: CGFloat = position.y - self.position.y
        let contentBeginFrame, contentEndFrame: CGRect
        let detailBeginFrame, detailEndFrame: CGRect
        let deviation: CGFloat
        switch self.currentState {
        case .fullscreen:
            if positionDelta < 0 {
                positionDelta = -positionDelta
                contentBeginFrame = self.contentFullscreenFrame
                contentEndFrame = self.contentFullscreenFrame
                detailBeginFrame = self.detailFullscreenFrame
                detailEndFrame = self.detailFullscreenFrame
                deviation = 0
                self.targetState = .fullscreen
            } else if positionDelta > self.detailShowedSize {
                contentBeginFrame = self.contentShowedFrame
                contentEndFrame = self.contentClosedFrame
                detailBeginFrame = self.detailShowedFrame
                detailEndFrame = self.detailClosedFrame
                deviation = self.detailShowedSize
                self.targetState = .closed
            } else if positionDelta > 0 {
                contentBeginFrame = self.contentFullscreenFrame
                contentEndFrame = self.contentShowedFrame
                detailBeginFrame = self.detailFullscreenFrame
                detailEndFrame = self.detailShowedFrame
                deviation = 0
                self.targetState = .showed
            } else {
                contentBeginFrame = self.contentFullscreenFrame
                contentEndFrame = self.contentFullscreenFrame
                detailBeginFrame = self.detailFullscreenFrame
                detailEndFrame = self.detailFullscreenFrame
                deviation = 0
                self.targetState = .fullscreen
            }
        case .showed:
            if positionDelta < 0 {
                positionDelta = -positionDelta
                contentBeginFrame = self.contentShowedFrame
                contentEndFrame = self.contentFullscreenFrame
                detailBeginFrame = self.detailShowedFrame
                detailEndFrame = self.detailFullscreenFrame
                deviation = 0
                self.targetState = .fullscreen
            } else if positionDelta > 0 {
                contentBeginFrame = self.contentShowedFrame
                contentEndFrame = self.contentClosedFrame
                detailBeginFrame = self.detailShowedFrame
                detailEndFrame = self.detailClosedFrame
                deviation = 0
                self.targetState = .closed
            } else {
                contentBeginFrame = self.contentShowedFrame
                contentEndFrame = self.contentShowedFrame
                detailBeginFrame = self.detailShowedFrame
                detailEndFrame = self.detailShowedFrame
                deviation = 0
                self.targetState = .showed
            }
        case .closed:
            contentBeginFrame = self.contentClosedFrame
            contentEndFrame = self.contentClosedFrame
            detailBeginFrame = self.detailClosedFrame
            detailEndFrame = self.detailClosedFrame
            deviation = 0
            self.targetState = .closed
        }
        if contentBeginFrame != contentEndFrame || detailBeginFrame != detailEndFrame {
            let detailDelta = detailBeginFrame.topPoint.distance(to: detailEndFrame.topPoint)
            self.deltaPosition = self.ease.lerp(positionDelta, from: 0, to: detailDelta + deviation)
            let progress = max(0, min((self.deltaPosition - deviation) / detailDelta, 1))
            self.contentViewController?.view.frame = contentBeginFrame.lerp(contentEndFrame, progress: progress)
            self.detailViewController?.view.frame = detailBeginFrame.lerp(detailEndFrame, progress: progress)
            self.canFinish = self.currentState != self.targetState
        }
    }
    
    public func finish(_ complete: @escaping (_ state: QJalousieViewControllerState) -> Void) {
        let contentEndFrame, detailBeginFrame, detailEndFrame: CGRect
        switch self.currentState {
        case .fullscreen: detailBeginFrame = self.detailFullscreenFrame
        case .showed: detailBeginFrame = self.detailShowedFrame
        case .closed: detailBeginFrame = self.detailClosedFrame
        }
        switch self.targetState {
        case .fullscreen: contentEndFrame = self.contentFullscreenFrame; detailEndFrame = self.detailFullscreenFrame
        case .showed: contentEndFrame = self.contentShowedFrame; detailEndFrame = self.detailShowedFrame
        case .closed: contentEndFrame = self.contentClosedFrame; detailEndFrame = self.detailClosedFrame
        }
        let detailDelta = detailBeginFrame.topPoint.distance(to: detailEndFrame.topPoint)
        let duration = TimeInterval((detailDelta - self.deltaPosition) / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.contentViewController?.view.frame = contentEndFrame
            self.detailViewController?.view.frame = detailEndFrame
        }, completion: { [weak self] (completed: Bool) in
            guard let self = self else { return }
            self.contentViewController?.view.frame = contentEndFrame
            self.contentViewController = nil
            self.detailViewController?.view.frame = detailEndFrame
            self.detailViewController = nil
            complete(self.targetState)
        })
    }
    
    public func cancel(_ complete: @escaping (_ state: QJalousieViewControllerState) -> Void) {
        let contentBeginFrame, detailBeginFrame: CGRect
        switch self.currentState {
        case .fullscreen: contentBeginFrame = self.contentFullscreenFrame; detailBeginFrame = self.detailFullscreenFrame
        case .showed: contentBeginFrame = self.contentShowedFrame; detailBeginFrame = self.detailShowedFrame
        case .closed: contentBeginFrame = self.contentClosedFrame; detailBeginFrame = self.detailClosedFrame
        }
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.contentViewController?.view.frame = contentBeginFrame
            self.detailViewController?.view.frame = detailBeginFrame
        }, completion: { [weak self] (completed: Bool) in
            guard let self = self else { return }
            self.contentViewController?.view.frame = contentBeginFrame
            self.contentViewController = nil
            self.detailViewController?.view.frame = detailBeginFrame
            self.detailViewController = nil
            complete(self.currentState)
        })
    }
    
}

// MARK: Private

private extension QJalousieViewControllerInteractiveAnimation {
    
    func _contentFrame(contentView: UIView, state: QJalousieViewControllerState) -> CGRect {
        return contentView.bounds
    }
    
    func _detailFrame(contentView: UIView, state: QJalousieViewControllerState) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .fullscreen: return CGRect(x: bounds.origin.x, y: bounds.maxY - self.detailFullscreenSize, width: bounds.width, height: self.detailFullscreenSize)
        case .showed: return CGRect(x: bounds.origin.x, y: bounds.maxY - self.detailShowedSize, width: bounds.width, height: self.detailShowedSize)
        case .closed: return CGRect(x: bounds.origin.x, y: bounds.maxY, width: bounds.width, height: self.detailShowedSize)
        }
    }
    
}
