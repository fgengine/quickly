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
            let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.verticalAlignment
            #if os(macOS)
                let originalAlpha: CGFloat = self.viewController.view.alphaValue
            #elseif os(iOS)
                let originalAlpha: CGFloat = self.viewController.view.alpha
            #endif
            self.viewController.willPresent(animated: animated)
            self.viewController.verticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
            #if os(macOS)
                self.viewController.view.layoutSubtreeIfNeeded()
                self.viewController.view.alphaValue = 0
            #elseif os(iOS)
                self.viewController.view.layoutIfNeeded()
                self.viewController.view.alpha = 0
            #endif
            #if os(macOS)
                NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                    context.duration = self.duration

                    self.viewController.verticalAlignment = originalVerticalAlignment
                    self.viewController.view.alphaValue = originalAlpha
                    self.viewController.view.layoutSubtreeIfNeeded()
                }, completionHandler: { [weak self] in
                    if let strongify = self {
                        strongify.viewController.didPresent(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(true)
                })
            #elseif os(iOS)
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.verticalAlignment = originalVerticalAlignment
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
            let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.verticalAlignment
            #if os(macOS)
                let originalAlpha: CGFloat = self.viewController.view.alphaValue
            #elseif os(iOS)
                let originalAlpha: CGFloat = self.viewController.view.alpha
            #endif
            self.viewController.willDismiss(animated: animated)
            #if os(macOS)
                NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                    context.duration = self.duration

                    self.viewController.verticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
                    self.viewController.view.alphaValue = 0
                    self.viewController.view.layoutSubtreeIfNeeded()
                }, completionHandler: { [weak self] in
                    if let strongify = self {
                        strongify.viewController.verticalAlignment = originalVerticalAlignment
                        strongify.viewController.view.alphaValue = originalAlpha
                        strongify.viewController.didDismiss(animated: animated)
                        strongify.viewController = nil
                    }
                    complete(true)
                })
            #elseif os(iOS)
                UIView.animate(withDuration: self.duration, animations: {
                    self.viewController.verticalAlignment = self.contentVerticalAlignment(originalVerticalAlignment)
                    self.viewController.view.alpha = 0
                    self.viewController.view.layoutIfNeeded()
                }, completion: { [weak self] (completed: Bool) in
                    if let strongify = self {
                        strongify.viewController.verticalAlignment = originalVerticalAlignment
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
        self.verticalAlignment = viewController.verticalAlignment
        self.position = position
        self.velocity = velocity
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
        #if os(iOS)
            let duration: TimeInterval = TimeInterval(self.deltaPosition / self.acceleration)
            UIView.animate(withDuration: duration, animations: {
                self.viewController.verticalAlignment = self.verticalAlignment
                self.viewController.view.layoutIfNeeded()
            }, completion: complete)
        #endif
    }

    open func finish(_ complete: @escaping (_ completed: Bool) -> Void) {
        let originalVerticalAlignment: QDialogViewControllerVerticalAlignment = self.viewController.verticalAlignment
        let originalHorizontalAlignment: QDialogViewControllerHorizontalAlignment = self.viewController.horizontalAlignment
        #if os(macOS)
            let originalAlpha: CGFloat = self.viewController.view.alphaValue
        #elseif os(iOS)
            let originalAlpha: CGFloat = self.viewController.view.alpha
        #endif
        self.viewController.willDismiss(animated: true)
        let duration: TimeInterval = TimeInterval(self.deltaPosition / self.acceleration)
        let deceleration: CGFloat = self.deltaPosition * 2.5
        #if os(macOS)
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                context.duration = duration

                switch self.verticalAlignment {
                case .top(let offset): self.viewController.verticalAlignment = .top(offset: offset + deceleration)
                case .center(let offset): self.viewController.verticalAlignment = .center(offset: offset + deceleration)
                case .bottom(let offset): self.viewController.verticalAlignment = .bottom(offset: offset + deceleration)
                }
                self.viewController.view.alphaValue = 0
                self.viewController.view.layoutSubtreeIfNeeded()
            }, completionHandler: { [weak self] in
                if let strongify = self {
                    strongify.viewController.verticalAlignment = originalVerticalAlignment
                    strongify.viewController.horizontalAlignment = originalHorizontalAlignment
                    strongify.viewController.view.alphaValue = originalAlpha
                    strongify.viewController.didDismiss(animated: true)
                    strongify.viewController = nil
                }
                complete(true)
            })
        #elseif os(iOS)
            UIView.animate(withDuration: duration, animations: {
                switch self.verticalAlignment {
                case .top(let offset): self.viewController.verticalAlignment = .top(offset: offset + deceleration)
                case .center(let offset): self.viewController.verticalAlignment = .center(offset: offset + deceleration)
                case .bottom(let offset): self.viewController.verticalAlignment = .bottom(offset: offset + deceleration)
                }
                self.viewController.view.alpha = 0
                self.viewController.view.layoutIfNeeded()
            }, completion: { [weak self] (completed: Bool) in
                if let strongify = self {
                    strongify.viewController.verticalAlignment = originalVerticalAlignment
                    strongify.viewController.horizontalAlignment = originalHorizontalAlignment
                    strongify.viewController.view.alpha = originalAlpha
                    strongify.viewController.didDismiss(animated: true)
                    strongify.viewController = nil
                }
                complete(completed)
            })
        #endif
    }

}
