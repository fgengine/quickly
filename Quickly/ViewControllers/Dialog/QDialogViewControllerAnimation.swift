//
//  Quickly
//

open class QDialogViewControllerAnimation : IQDialogViewControllerFixedAnimation {

    public var viewController: IQDialogViewController!
    public var duration: TimeInterval
    public var verticalOffset: CGFloat

    public init(duration: TimeInterval, verticalOffset: CGFloat) {
        self.duration = duration
        self.verticalOffset = verticalOffset
    }

    open func prepare(viewController: IQDialogViewController) {
        self.viewController = viewController
    }

    open func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }

    internal func contentVerticalAlignment(_ contentVerticalAlignment: QDialogViewControllerVerticalAlignment) -> QDialogViewControllerVerticalAlignment {
        switch contentVerticalAlignment {
        case .top(let offset): return .top(offset: offset - self.verticalOffset)
        case .center(let offset): return .center(offset: offset - self.verticalOffset)
        case .bottom(let offset): return .bottom(offset: offset + self.verticalOffset)
        }
    }

}

open class QDialogViewControllerPresentAnimation : QDialogViewControllerAnimation {

    public init() {
        super.init(duration: 0.2, verticalOffset: 50)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment = self.viewController.verticalAlignment
            let originalAlpha = self.viewController.view.alpha
            self.viewController.willPresent(animated: animated)
            self.viewController.verticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
            self.viewController.view.layoutIfNeeded()
            self.viewController.view.alpha = 0
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.verticalAlignment = originalVerticalAlignment
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

open class QDialogViewControllerDismissAnimation : QDialogViewControllerAnimation {

    public init() {
        super.init(duration: 0.2, verticalOffset: 200)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment = self.viewController.verticalAlignment
            let originalAlpha = self.viewController.view.alpha
            self.viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.verticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
                self.viewController.view.alpha = 0
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.verticalAlignment = originalVerticalAlignment
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

open class QDialogViewControllerinteractiveDismissAnimation : IQDialogViewControllerInteractiveAnimation {

    open var viewController: IQDialogViewController!
    open var verticalAlignment: QDialogViewControllerVerticalAlignment = .center(offset: 0)
    open var position: CGPoint = CGPoint.zero
    open private(set) var deltaPosition: CGFloat = 0
    open var velocity: CGPoint = CGPoint.zero
    open var finishDistance: CGFloat = 80
    open var acceleration: CGFloat = 600
    open var canFinish: Bool = false

    open func prepare(viewController: IQDialogViewController, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.verticalAlignment = viewController.verticalAlignment
        self.position = position
        self.velocity = velocity
        self.viewController.prepareInteractiveDismiss()
    }

    open func update(position: CGPoint, velocity: CGPoint) {
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
        self.canFinish = abs(self.deltaPosition) > self.finishDistance
    }

    open func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        UIView.animate(withDuration: duration, animations: {
            self.viewController.verticalAlignment = self.verticalAlignment
            self.viewController.view.layoutIfNeeded()
        }, completion: { (completed: Bool) in
            self.viewController.cancelInteractiveDismiss()
            self.viewController = nil
            complete(completed)
        })
    }

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let originalVerticalAlignment = self.viewController.verticalAlignment
        let originalHorizontalAlignment = self.viewController.horizontalAlignment
        let originalAlpha = self.viewController.view.alpha
        self.viewController.willDismiss(animated: true)
        let duration = TimeInterval(self.deltaPosition / self.acceleration)
        let deceleration = self.deltaPosition * 2.5
        UIView.animate(withDuration: duration, animations: {
            switch self.verticalAlignment {
            case .top(let offset): self.viewController.verticalAlignment = .top(offset: offset + deceleration)
            case .center(let offset): self.viewController.verticalAlignment = .center(offset: offset + deceleration)
            case .bottom(let offset): self.viewController.verticalAlignment = .bottom(offset: offset + deceleration)
            }
            self.viewController.view.alpha = 0
            self.viewController.view.layoutIfNeeded()
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
