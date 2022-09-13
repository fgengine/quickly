//
//  Quickly
//

import UIKit

public final class QDialogBlurBackgroundView : QBlurView, IQDialogContainerBackgroundView {

    public weak var containerViewController: IQDialogContainerViewController?

    public required init() {
        super.init(blur: Const.hiddenBlur)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

        self.blur = Const.hiddenBlur
        self.isHidden = true
    }

    public func present(viewController: IQDialogViewController, isFirst: Bool, animated: Bool) {
        if isFirst == true {
            self.isHidden = false
            if animated == true {
                UIView.animate(withDuration: Const.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.blur = Const.visibleBlur
                })
            } else {
                self.blur = Const.visibleBlur
            }
        }
    }

    public func dismiss(viewController: IQDialogViewController, isLast: Bool, animated: Bool) {
        if isLast == true {
            if animated == true {
                UIView.animate(withDuration: Const.duration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.blur = Const.hiddenBlur
                }, completion: { (_) in
                    self.isHidden = true
                })
            } else {
                self.blur = Const.hiddenBlur
                self.isHidden = true
            }
        }
    }
        
}

// MARK: Private

private extension QDialogBlurBackgroundView {

    struct Const {

        static let duration: TimeInterval = 0.25
        static let hiddenBlur: UIBlurEffect? = nil
        static let visibleBlur: UIBlurEffect? = UIBlurEffect(style: .dark)

    }

}
