//
//  Quickly
//

import UIKit

public final class QHamburgerViewControllerAnimation : IQHamburgerViewControllerFixedAnimation {
    
    public var contentShadow: QViewShadow
    public var leftSize: CGFloat
    public var rightSize: CGFloat
    public var acceleration: CGFloat
    
    public init(
        contentShadow: QViewShadow = QViewShadow(color: UIColor.black, opacity: 0.45, radius: 6, offset: CGSize.zero),
        leftSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        rightSize: CGFloat = UIScreen.main.bounds.width * 0.6,
        acceleration: CGFloat = 1200
    ) {
        self.contentShadow = contentShadow
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
            vc.view.frame = QHamburgerViewControllerAnimation._contentFrame(contentView: contentView, state: state, leftSize: self.leftSize, rightSize: self.rightSize)
            vc.view.shadow = state != .idle ? self.contentShadow : nil
            contentView.bringSubviewToFront(vc.view)
        }
        leftViewController?.view.frame = QHamburgerViewControllerAnimation._leftFrame(contentView: contentView, state: state, leftSize: self.leftSize, rightSize: self.rightSize)
        rightViewController?.view.frame = QHamburgerViewControllerAnimation._rightFrame(contentView: contentView, state: state, leftSize: self.leftSize, rightSize: self.rightSize)
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
            let currentFrame = QHamburgerViewControllerAnimation._contentFrame(contentView: contentView, state: currentState, leftSize: self.leftSize, rightSize: self.rightSize)
            let targetFrame = QHamburgerViewControllerAnimation._contentFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
            if let vc = contentViewController {
                vc.view.frame = currentFrame
                vc.view.shadow = self.contentShadow
                contentView.bringSubviewToFront(vc.view)
            }
            leftViewController?.view.frame = QHamburgerViewControllerAnimation._leftFrame(contentView: contentView, state: currentState, leftSize: self.leftSize, rightSize: self.rightSize)
            rightViewController?.view.frame = QHamburgerViewControllerAnimation._rightFrame(contentView: contentView, state: currentState, leftSize: self.leftSize, rightSize: self.rightSize)
            let duration = TimeInterval(abs(currentFrame.centerPoint.distance(to: targetFrame.centerPoint)) / self.acceleration)
            UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
                contentViewController?.view.frame = QHamburgerViewControllerAnimation._contentFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
                leftViewController?.view.frame = QHamburgerViewControllerAnimation._leftFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
                rightViewController?.view.frame = QHamburgerViewControllerAnimation._rightFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
            }, completion: { (completed) in
                if let vc = contentViewController {
                    vc.view.shadow = targetState != .idle ? self.contentShadow : nil
                }
                if currentState == .left { leftViewController?.didDismiss(animated: animated) }
                if currentState == .right { rightViewController?.didDismiss(animated: animated) }
                if targetState == .left { leftViewController?.didPresent(animated: animated) }
                if targetState == .right { rightViewController?.didPresent(animated: animated) }
                complete()
            })
        } else {
            if let vc = contentViewController {
                vc.view.frame = QHamburgerViewControllerAnimation._contentFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
                vc.view.shadow = targetState != .idle ? self.contentShadow : nil
                contentView.bringSubviewToFront(vc.view)
            }
            leftViewController?.view.frame = QHamburgerViewControllerAnimation._leftFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
            rightViewController?.view.frame = QHamburgerViewControllerAnimation._rightFrame(contentView: contentView, state: targetState, leftSize: self.leftSize, rightSize: self.rightSize)
            if currentState == .left { leftViewController?.didDismiss(animated: animated) }
            if currentState == .right { rightViewController?.didDismiss(animated: animated) }
            if targetState == .left { leftViewController?.didPresent(animated: animated) }
            if targetState == .right { rightViewController?.didPresent(animated: animated) }
            complete()
        }
    }
    
}

// MARK: Private

private extension QHamburgerViewControllerAnimation {
    
    static func _contentFrame(contentView: UIView, state: QHamburgerViewControllerState, leftSize: CGFloat, rightSize: CGFloat) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle: return bounds
        case .left: return CGRect(x: bounds.origin.x + leftSize, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        case .right: return CGRect(x: bounds.origin.x - rightSize, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }
    }
    
    static func _leftFrame(contentView: UIView, state: QHamburgerViewControllerState, leftSize: CGFloat, rightSize: CGFloat) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle, .right: return CGRect(x: bounds.origin.x - leftSize, y: bounds.origin.y, width: leftSize, height: bounds.height)
        case .left: return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: leftSize, height: bounds.height)
        }
    }
    
    static func _rightFrame(contentView: UIView, state: QHamburgerViewControllerState, leftSize: CGFloat, rightSize: CGFloat) -> CGRect {
        let bounds = contentView.bounds
        switch state {
        case .idle, .left: return CGRect(x: bounds.origin.x + bounds.width, y: bounds.origin.y, width: rightSize, height: bounds.height)
        case .right: return CGRect(x: (bounds.origin.x + bounds.width) - rightSize, y: bounds.origin.y, width: rightSize, height: bounds.height)
        }
    }
    
}
