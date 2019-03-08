//
//
//  Quickly
//

import Quickly

protocol IConfirmModalViewControllerRouter : IQRouter {

    func dismiss(viewController: ConfirmModalViewController)
    
}

class ConfirmModalViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IConfirmModalViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.view.layer.cornerRadius = 4
        self.rootView.backgroundColor = UIColor.random(alpha: 1)

        self.imageView.source = QImageSource("icon_confirm")

        let normalStyle = QButton.StateStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QLabelStyleSheet(text: QText("Close"))

        let highlightedStyle = QButton.StateStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QLabelStyleSheet(text: QText("Close"))

        self.closeButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.normalStyle = normalStyle
        self.closeButton.highlightedStyle = highlightedStyle
        self.closeButton.onPressed = { [weak self] (button) in
            guard let strong = self else { return }
            strong.router.dismiss(viewController: strong)
        }
    }

    override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }

    func didPressedOutsideContent() {
        self.router.dismiss(viewController: self)
    }

}
