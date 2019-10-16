//
//  Quickly
//

public final class QDialogBlurBackgroundView : QBlurView, IQDialogContainerBackgroundView {

    public weak var containerViewController: IQDialogContainerViewController?

    public required init() {
        super.init(blurRadius: Const.hiddenBlurRadius)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

        self.blurRadius = Const.hiddenBlurRadius
        self.isHidden = true
    }

    public func present(viewController: IQDialogViewController, isFirst: Bool, animated: Bool) {
        if isFirst == true {
            self.isHidden = false
            if animated == true {
                UIView.animate(withDuration: Const.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.blurRadius = Const.visibleBlurRadius
                })
            } else {
                self.blurRadius = Const.visibleBlurRadius
            }
        }
    }

    public func dismiss(viewController: IQDialogViewController, isLast: Bool, animated: Bool) {
        if isLast == true {
            if animated == true {
                UIView.animate(withDuration: Const.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
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
        
}

// MARK: Private

private extension QDialogBlurBackgroundView {

    struct Const {

        static let duration: TimeInterval = 0.25
        static let hiddenBlurRadius: CGFloat = 0
        static let visibleBlurRadius: CGFloat = 20

    }

}
