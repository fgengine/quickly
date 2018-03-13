//
//  Quickly
//

open class QDialogViewControllerAnimation : IQDialogViewControllerFixedAnimation {

    public typealias ViewControllerType = IQDialogViewControllerFixedAnimation.ViewControllerType

    public var viewController: ViewControllerType!
    public var duration: TimeInterval
    public var verticalOffset: CGFloat

    public init(duration: TimeInterval, verticalOffset: CGFloat) {
        self.duration = duration
        self.verticalOffset = verticalOffset
    }

    open func prepare(viewController: ViewControllerType) {
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

    public typealias ViewControllerType = QDialogViewControllerAnimation.ViewControllerType

    public init() {
        super.init(duration: 0.2, verticalOffset: 50)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.contentVerticalAlignment
            let originalAlpha: CGFloat = self.viewController.view.alpha
            self.viewController.willPresent(animated: animated)
            self.viewController.contentVerticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
            self.viewController.view.layoutIfNeeded()
            self.viewController.view.alpha = 0
            #if os(iOS)
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.contentVerticalAlignment = originalVerticalAlignment
                    self.viewController.view.alpha = originalAlpha
                    self.viewController.view.layoutIfNeeded()
                }, completion: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.viewController.didPresent(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(completed)
                })
            #endif
        } else {
            self.viewController.willPresent(animated: animated)
            self.viewController.didPresent(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}

open class QDialogViewControllerDismissAnimation : QDialogViewControllerAnimation {

    public typealias ViewControllerType = QDialogViewControllerAnimation.ViewControllerType

    public init() {
        super.init(duration: 0.2, verticalOffset: 200)
    }

    open override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.contentVerticalAlignment
            let originalAlpha: CGFloat = self.viewController.view.alpha
            self.viewController.willDismiss(animated: animated)
            #if os(iOS)
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.contentVerticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
                    self.viewController.view.alpha = 0
                    self.viewController.view.layoutIfNeeded()
                }, completion: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.viewController.contentVerticalAlignment = originalVerticalAlignment
                        strongify.viewController.view.alpha = originalAlpha
                        strongify.viewController.didDismiss(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(completed)
                })
            #endif
        } else {
            self.viewController.willDismiss(animated: animated)
            self.viewController.didDismiss(animated: animated)
            complete(true)
        }
    }

}

open class QDialogViewControllerInteractiveDismissAnimation : IQDialogViewControllerInteractiveAnimation {

    public typealias ViewControllerType = IQDialogViewControllerFixedAnimation.ViewControllerType

    open var viewController: ViewControllerType!
    open var verticalAlignment: QDialogViewControllerVerticalAlignment = .center(offset: 0)
    open var position: CGPoint = CGPoint.zero
    open var deltaPosition: CGFloat = 0
    open var velocity: CGPoint = CGPoint.zero
    open var finishDistance: CGFloat = 80
    open var acceleration: CGFloat = 600
    open var canFinish: Bool = false

    open func prepare(viewController: ViewControllerType, position: CGPoint, velocity: CGPoint) {
        self.viewController = viewController
        self.verticalAlignment = viewController.contentVerticalAlignment
        self.position = position
        self.velocity = velocity
    }

    open func update(position: CGPoint, velocity: CGPoint) {
        switch self.verticalAlignment {
        case .top(let offset):
            self.deltaPosition = min(0, position.y - self.position.y)
            self.viewController.contentVerticalAlignment = .top(offset: offset + self.deltaPosition)
        case .center(let offset):
            self.deltaPosition = position.y - self.position.y
            self.viewController.contentVerticalAlignment = .center(offset: offset + self.deltaPosition)
        case .bottom(let offset):
            self.deltaPosition = max(0, position.y - self.position.y)
            self.viewController.contentVerticalAlignment = .bottom(offset: offset + self.deltaPosition)
        }
        self.canFinish = abs(self.deltaPosition) > self.finishDistance
    }

    open func cancel(_ complete: @escaping (_ completed: Bool) -> Void) {
        #if os(iOS)
            let duration: TimeInterval = TimeInterval(self.deltaPosition / self.acceleration)
            UIView.animate(withDuration: duration, animations: {
                self.viewController.contentVerticalAlignment = self.verticalAlignment
                self.viewController.view.layoutIfNeeded()
            }, completion: complete)
        #endif
    }

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.contentVerticalAlignment
        let originalHorizontalAlignment: QDialogViewControllerHorizontalAlignment = self.viewController.contentHorizontalAlignment
        let originalAlpha: CGFloat = self.viewController.view.alpha
        self.viewController.willDismiss(animated: true)
        #if os(iOS)
            let duration: TimeInterval = TimeInterval(self.deltaPosition / self.acceleration)
            let deseleration: CGFloat = self.deltaPosition * 2.5
            UIView.animate(withDuration: duration, animations: {
                switch self.verticalAlignment {
                case .top(let offset): self.viewController.contentVerticalAlignment = .top(offset: offset + deseleration)
                case .center(let offset): self.viewController.contentVerticalAlignment = .center(offset: offset + deseleration)
                case .bottom(let offset): self.viewController.contentVerticalAlignment = .bottom(offset: offset + deseleration)
                }
                self.viewController.view.alpha = 0
                self.viewController.view.layoutIfNeeded()
            }, completion: { [weak self] (completed: Bool) in
                if let strongify = self {
                    strongify.viewController.contentVerticalAlignment = originalVerticalAlignment
                    strongify.viewController.contentHorizontalAlignment = originalHorizontalAlignment
                    strongify.viewController.view.alpha = originalAlpha
                    strongify.viewController.didDismiss(animated: true)
                    strongify.viewController = nil
                }
                complete(completed)
            })
        #endif
    }

}
