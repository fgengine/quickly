//
//  Quickly
//

open class QDialogBackgroundView : QView, IQDialogContainerBackgroundView {

    open weak var containerViewController: IQDialogContainerViewController?

    public init(backgroundColor: UIColor) {
        super.init(frame: CGRect())

        self.backgroundColor = backgroundColor
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        self.alpha = Const.hiddenAlpha
        self.isHidden = true
    }

    public func presentDialog(viewController: IQDialogViewController, isFirst: Bool, animated: Bool) {
        if isFirst == true {
            self.isHidden = false
            if animated == true {
                UIView.animate(withDuration: Const.duration, animations: {
                    self.alpha = Const.visibleAlpha
                })
            } else {
                self.alpha = Const.visibleAlpha
            }
        }
    }

    public func dismissDialog(viewController: IQDialogViewController, isLast: Bool, animated: Bool) {
        if isLast == true {
            if animated == true {
                UIView.animate(withDuration: Const.duration, animations: {
                    self.alpha = Const.hiddenAlpha
                }, completion: { (_) in
                    self.isHidden = true
                })
            } else {
                self.alpha = Const.hiddenAlpha
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
