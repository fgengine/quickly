//
//  Quickly
//

open class QDialogBackgroundView : QView, IQDialogContainerBackgroundView {

    public typealias ContainerViewControllerType = IQDialogContainerBackgroundView.ContainerViewControllerType
    public typealias ViewControllerType = IQDialogContainerBackgroundView.ViewControllerType

    open weak var containerViewController: ContainerViewControllerType?

    public init(backgroundColor: QPlatformColor) {
        super.init(frame: CGRect())
        #if os(macOS)
            self.wantsLayer = true
            self.layer!.backgroundColor = backgroundColor.cgColor
        #elseif os(iOS)
            self.backgroundColor = backgroundColor
        #endif
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        #if os(macOS)
            self.alphaValue = Const.hiddenAlpha
        #elseif os(iOS)
            self.alpha = Const.hiddenAlpha
        #endif
        self.isHidden = true
    }

    public func presentDialog(viewController: ViewControllerType, isFirst: Bool, animated: Bool) {
        if isFirst == true {
            self.isHidden = false
            if animated == true {
                #if os(macOS)
                    NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                        context.duration = Const.duration

                        self.animator().alphaValue = Const.visibleAlpha
                    })
                #elseif os(iOS)
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.alpha = Const.visibleAlpha
                    })
                #endif
            } else {
                #if os(macOS)
                    self.alphaValue = Const.visibleAlpha
                #elseif os(iOS)
                    self.alpha = Const.visibleAlpha
                #endif
            }
        }
    }

    public func dismissDialog(viewController: ViewControllerType, isLast: Bool, animated: Bool) {
        if isLast == true {
            if animated == true {
                #if os(macOS)
                    NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                        context.duration = Const.duration

                        self.animator().alphaValue = Const.hiddenAlpha
                    }, completionHandler: {
                        self.alphaValue = Const.hiddenAlpha
                        self.isHidden = true
                    })
                #elseif os(iOS)
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.alpha = Const.hiddenAlpha
                    }, completion: { (_) in
                        self.isHidden = true
                    })
                #endif
            } else {
                #if os(macOS)
                    self.alphaValue = Const.hiddenAlpha
                #elseif os(iOS)
                    self.alpha = Const.hiddenAlpha
                #endif
                self.isHidden = true
            }
        }
    }

    private struct Const {

        static let duration: TimeInterval = 0.25
        static let hiddenAlpha: CGFloat = 0
        static let visibleAlpha: CGFloat = 1

    }

}
