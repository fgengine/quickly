//
//  Quickly
//

open class QDialogBackgroundView : QBlurView, IQDialogContainerBackgroundView {

    public typealias ContainerViewControllerType = IQDialogContainerBackgroundView.ContainerViewControllerType
    public typealias ViewControllerType = IQDialogContainerBackgroundView.ViewControllerType

    open weak var containerViewController: ContainerViewControllerType?

    public required init(_ containerViewController: IQDialogContainerBackgroundView.ContainerViewControllerType) {
        self.containerViewController = containerViewController
        super.init(blurRadius: Const.hiddenBlurRadius)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.isHidden = true
    }

    public func presentDialog(viewController: ViewControllerType, isFirst: Bool, animated: Bool) {
        if isFirst == true {
            self.isHidden = false
            if animated == true {
                #if os(iOS)
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.blurRadius = Const.visibleBlurRadius
                    })
                #endif
            } else {
                self.blurRadius = Const.visibleBlurRadius
            }
        }
    }

    public func dismissDialog(viewController: ViewControllerType, isLast: Bool, animated: Bool) {
        if isLast == true {
            if animated == true {
                #if os(iOS)
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.blurRadius = Const.hiddenBlurRadius
                    }, completion: { (_) in
                        self.isHidden = true
                    })
                #endif
            } else {
                self.blurRadius = Const.hiddenBlurRadius
                self.isHidden = true
            }
        }
    }

    private struct Const {

        static let duration: TimeInterval = 0.25
        static let hiddenBlurRadius: CGFloat = 0
        static let visibleBlurRadius: CGFloat = 20

    }

}
