//
//  Quickly
//

import Quickly

protocol IDialogViewControllerRouter : IQRouter {

    func presentConfirmDialog()
    func dismiss(viewController: DialogViewController)
    
}

class DialogViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IDialogViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var showDialogButton: QButton!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QLabelStyleSheet(text: QText("Show dialog"))

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QLabelStyleSheet(text: QText("Show dialog"))

        self.showDialogButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.normalStyle = normalStyle
        self.showDialogButton.highlightedStyle = highlightedStyle
        self.showDialogButton.onPressed = { [weak self] (button) in
            guard let strong = self else { return }
            strong.router.presentConfirmDialog()
        }
    }

}
