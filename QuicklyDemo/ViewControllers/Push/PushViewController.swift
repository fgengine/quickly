//
//
//  Quickly
//

import Quickly

protocol IPushViewControllerRouter : IQRouter {

    func presentConfirmPush()
    func dismiss(viewController: PushViewController)
    
}

class PushViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IPushViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var showPushButton: QButton!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        let normalStyle = QButton.StateStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QLabelStyleSheet(text: QText("Show push"))

        let highlightedStyle = QButton.StateStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QLabelStyleSheet(text: QText("Show push"))

        self.showPushButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showPushButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showPushButton.normalStyle = normalStyle
        self.showPushButton.highlightedStyle = highlightedStyle
        self.showPushButton.onPressed = { [weak self] (button) in
            guard let strong = self else { return }
            strong.router.presentConfirmPush()
        }
    }

    @objc
    private func pressedShowPush(_ sender: Any) {
        self.router.presentConfirmPush()
    }

}
