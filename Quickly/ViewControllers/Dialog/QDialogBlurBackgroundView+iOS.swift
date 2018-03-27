//
//  Quickly
//

#if os(iOS)

    open class QDialogBlurBackgroundView : QBlurView, IQDialogContainerBackgroundView {

        public typealias ContainerViewControllerType = IQDialogContainerBackgroundView.ContainerViewControllerType
        public typealias ViewControllerType = IQDialogContainerBackgroundView.ViewControllerType

        open weak var containerViewController: ContainerViewControllerType?

        public init() {
            super.init(blurRadius: Const.hiddenBlurRadius)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        open override func setup() {
            super.setup()

            self.blurRadius = Const.hiddenBlurRadius
            self.isHidden = true
        }

        public func presentDialog(viewController: ViewControllerType, isFirst: Bool, animated: Bool) {
            if isFirst == true {
                self.isHidden = false
                if animated == true {
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.blurRadius = Const.visibleBlurRadius
                    })
                } else {
                    self.blurRadius = Const.visibleBlurRadius
                }
            }
        }

        public func dismissDialog(viewController: ViewControllerType, isLast: Bool, animated: Bool) {
            if isLast == true {
                if animated == true {
                    UIView.animate(withDuration: Const.duration, animations: {
                        self.blurRadius = Const.hiddenBlurRadius
                    }, completion: { (_) in
                        self.isHidden = true
                    })
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

#endif
