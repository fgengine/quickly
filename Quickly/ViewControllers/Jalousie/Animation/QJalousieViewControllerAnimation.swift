//
//  Quickly
//

import UIKit

public final class QJalousieViewControllerAnimation : IQJalousieViewControllerFixedAnimation {
    
    public var detailFullscreenSize: CGFloat
    public var detailShowedSize: CGFloat
    public var acceleration: CGFloat
    
    public init(
        detailFullscreenSize: CGFloat = UIScreen.main.bounds.height,
        detailShowedSize: CGFloat = UIScreen.main.bounds.height * 0.5,
        acceleration: CGFloat = 1200
    ) {
        self.detailFullscreenSize = detailFullscreenSize
        self.detailShowedSize = detailShowedSize
        self.acceleration = acceleration
    }
    
    public func layout(
        contentView: UIView,
        state: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?
    ) {
        if let vc = contentViewController {
            vc.view.frame = self._contentFrame(contentView: contentView, state: state)
        }
        if let vc = detailViewController {
            vc.view.frame = self._detailFrame(contentView: contentView, state: state)
            contentView.bringSubviewToFront(vc.view)
        }
    }
    
    public func animate(
        contentView: UIView,
        currentState: QJalousieViewControllerState,
        targetState: QJalousieViewControllerState,
        contentViewController: IQJalousieViewController?,
        detailViewController: IQJalousieViewController?,
        animated: Bool,
        complete: @escaping () -> Void
    ) {
        if currentState == .closed { detailViewController?.willPresent(animated: animated) }
        if targetState == .closed { detailViewController?.willDismiss(animated: animated) }
        if animated == true {
            let contentCurrentFrame = self._contentFrame(contentView: contentView, state: currentState)
            let contentTargetFrame = self._contentFrame(contentView: contentView, state: targetState)
            let detailCurrentFrame = self._detailFrame(contentView: contentView, state: currentState)
            let detailTargetFrame = self._detailFrame(contentView: contentView, state: targetState)
            let duration = TimeInterval(abs(detailCurrentFrame.centerPoint.distance(to: detailTargetFrame.centerPoint)) / self.acceleration)
            contentViewController?.view.frame = contentCurrentFrame
            detailViewController?.view.frame = detailCurrentFrame
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                contentViewController?.view.frame = contentTargetFrame
                detailViewController?.view.frame = detailTargetFrame
            }, completion: { (completed) in
                if currentState == .closed { detailViewController?.didPresent(animated: animated) }
                if targetState == .closed { detailViewController?.didDismiss(animated: animated) }
                complete()
            })
        } else {
            contentViewController?.view.frame = self._contentFrame(contentView: contentView, state: targetState)
            detailViewController?.view.frame = self._detailFrame(contentView: contentView, state: targetState)
            if currentState == .closed { detailViewController?.didPresent(animated: animated) }
            if targetState == .closed { detailViewController?.didDismiss(animated: animated) }
            complete()
        }
    }
    
}

// MARK: Private

private extension QJalousieViewControllerAnimation {
    
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
