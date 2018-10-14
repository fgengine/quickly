//
//  Quickly
//

import Quickly

protocol IModalViewControllerRouter : IQRouter {

    func presentConfirmModal()
    func dismiss(viewController: ModalViewController)
    
}

class ModalViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IModalViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var showModalButton: QButton!

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
        normalStyle.text = QText("Show modal", color: UIColor.black)

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Show modal", color: UIColor.black)

        self.showModalButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showModalButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showModalButton.normalStyle = normalStyle
        self.showModalButton.highlightedStyle = highlightedStyle
        self.showModalButton.addTouchUpInside(self, action: #selector(self.pressedShowModal(_:)))
    }

    @objc
    private func pressedShowModal(_ sender: Any) {
        self.router.presentConfirmModal()
    }

}
