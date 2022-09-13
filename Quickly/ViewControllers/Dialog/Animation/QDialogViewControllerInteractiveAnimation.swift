//
//  Quickly
//

import UIKit

public final class QDialogViewControllerinteractiveDismissAnimation : IQDialogViewControllerInteractiveAnimation {

    internal var viewController: IQDialogViewController!
    internal var verticalAlignment: QDialogViewControllerVerticalAlignment
    internal var position: CGPoint
    internal var deltaPosition: CGFloat
    internal var velocity: CGPoint
    internal var dismissDistance: CGFloat
    internal var acceleration: CGFloat
    public private(set) var canFinish: Bool

    public init(dismissDistance: CGFloat = 80, acceleration: CGFloat = 600) {
        self.verticalAlignment = .center(offset: 0)
        self.position = CGPoint.zero
        self.deltaPosition = 0
        self.velocity = CGPoint.zero
        self.dismissDistance = dismissDistance
        self.acceleration = acceleration
        self.canFinish = false
    }

    public func prepare(viewController: IQDialogViewController, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.verticalAlignment = viewController.verticalAlignment
        self.position = position
        self.velocity = velocity
        self.viewController.prepareInteractiveDismiss()
    }

    public func update(position: CGPoint, velocity: CGPoint) {
        switch self.verticalAlignment {
        case .top(let offset):
            self.deltaPosition = min(0, position.y - self.position.y)
            self.viewController.verticalAlignment = .top(offset: offset + self.deltaPosition)
        case .center(let offset):
            self.deltaPosition = position.y - self.position.y
            self.viewController.verticalAlignment = .center(offset: offset + self.deltaPosition)
        case .bottom(let offset):
            self.deltaPosition = max(0, position.y - self.position.y)
            self.viewController.verticalAlignment = .bottom(offset: offset + self.deltaPosition)
        }
        self.canFinish = abs(self.deltaPosition) > self.dismissDistance
    }

    public func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            self.viewController.verticalAlignment = self.verticalAlignment
            self.viewController.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.cancelInteractiveDismiss()
            self.viewController = nil
            complete(completed)
        })
    }

    public func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let originalVerticalAlignment = self.viewController.verticalAlignment
        let originalHorizontalAlignment = self.viewController.horizontalAlignment
        let originalAlpha = self.viewController.view.alpha
        self.viewController.willDismiss(animated: true)
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        let deceleration = self.deltaPosition * 2.5
        UIView.animate(withDuration: duration, delay: 0, options: [ .beginFromCurrentState, .layoutSubviews ], animations: {
            switch self.verticalAlignment {
            case .top(let offset): self.viewController.verticalAlignment = .top(offset: offset + deceleration)
            case .center(let offset): self.viewController.verticalAlignment = .center(offset: offset + deceleration)
            case .bottom(let offset): self.viewController.verticalAlignment = .bottom(offset: offset + deceleration)
            }
            self.viewController.view.alpha = 0
            self.viewController.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.verticalAlignment = originalVerticalAlignment
            self.viewController.horizontalAlignment = originalHorizontalAlignment
            self.viewController.view.alpha = originalAlpha
            self.viewController.finishInteractiveDismiss()
            self.viewController.didDismiss(animated: true)
            self.viewController = nil
            complete(completed)
        })
    }

}
