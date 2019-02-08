//
//
//  Quickly
//

import Quickly

protocol IButtonViewControllerRouter : IQRouter {

    func dismiss(viewController: ButtonViewController)
    
}

class ButtonViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IButtonViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var button: QButton!
    @IBOutlet private weak var spinnerButton: QButton!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.red
        normalStyle.cornerRadius = QViewCornerRadius.auto
        normalStyle.shadow = QViewShadow(color: .black, opacity: 0.5, radius: 10, offset: CGSize(width: 0, height: 6))
        normalStyle.text = QLabelStyleSheet(text: QText("Normal"))
        normalStyle.image = QImageViewStyleSheet(source: QImageSource("button_image"))

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.blue
        highlightedStyle.text = QLabelStyleSheet(text: QText("Highlighted"))
        highlightedStyle.image = QImageViewStyleSheet(source: QImageSource("button_image"))

        self.button.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.normalStyle = normalStyle
        self.button.highlightedStyle = highlightedStyle
        self.button.onPressed = { [weak self] (button) in
            guard let strong = self else { return }
            UIView.animate(withDuration: 0.2, delay: 0, options: [ .beginFromCurrentState ], animations: {
                switch strong.button.imagePosition {
                case .top: strong.button.imagePosition = .right
                case .right: strong.button.imagePosition = .bottom
                case .bottom: strong.button.imagePosition = .left
                case .left: strong.button.imagePosition = .top
                }
                strong.button.layoutIfNeeded()
            })
        }

        self.spinnerButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.normalStyle = normalStyle
        self.spinnerButton.highlightedStyle = highlightedStyle
        self.spinnerButton.spinnerView = QSpinnerView()
        self.spinnerButton.onPressed = { [weak self] (button) in
            guard let strong = self else { return }
            UIView.animate(withDuration: 0.2, delay: 0, options: [ .beginFromCurrentState ], animations: {
                strong.spinnerButton.startSpinner()
                strong.spinnerButton.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                UIView.animate(withDuration: 0.2, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    strong.spinnerButton.stopSpinner()
                    strong.spinnerButton.layoutIfNeeded()
                })
            }
        }
    }

}
