//
//  Quickly
//

public class QDialogViewControllerAnimation : IQDialogViewControllerFixedAnimation {

    public var viewController: IQDialogViewController!
    public var duration: TimeInterval
    public var verticalOffset: CGFloat

    public init(duration: TimeInterval, verticalOffset: CGFloat) {
        self.duration = duration
        self.verticalOffset = verticalOffset
    }

    public func prepare(viewController: IQDialogViewController) {
        self.viewController = viewController
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }

    public func contentVerticalAlignment(_ contentVerticalAlignment: QDialogViewControllerVerticalAlignment) -> QDialogViewControllerVerticalAlignment {
        switch contentVerticalAlignment {
        case .top(let offset): return .top(offset: offset - self.verticalOffset)
        case .center(let offset): return .center(offset: offset - self.verticalOffset)
        case .bottom(let offset): return .bottom(offset: offset + self.verticalOffset)
        }
    }

}

public class QDialogViewControllerPresentAnimation : QDialogViewControllerAnimation {

    public override init(duration: TimeInterval = 0.2, verticalOffset: CGFloat = 50) {
        super.init(duration: duration, verticalOffset: verticalOffset)
    }

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment = self.viewController.dialogVerticalAlignment
            let originalAlpha = self.viewController.view.alpha
            self.viewController.willPresent(animated: animated)
            self.viewController.dialogVerticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
            self.viewController.view.layoutIfNeeded()
            self.viewController.view.alpha = 0
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.viewController.dialogVerticalAlignment = originalVerticalAlignment
                self.viewController.view.alpha = originalAlpha
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.didPresent(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.willPresent(animated: animated)
            self.viewController.didPresent(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}

public class QDialogViewControllerDismissAnimation : QDialogViewControllerAnimation {

    public override init(duration: TimeInterval = 0.2, verticalOffset: CGFloat = 200) {
        super.init(duration: duration, verticalOffset: verticalOffset)
    }

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment = self.viewController.dialogVerticalAlignment
            let originalAlpha = self.viewController.view.alpha
            self.viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.viewController.dialogVerticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
                self.viewController.view.alpha = 0
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.dialogVerticalAlignment = originalVerticalAlignment
                self.viewController.view.alpha = originalAlpha
                self.viewController.didDismiss(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.willDismiss(animated: animated)
            self.viewController.didDismiss(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}
