//
//  Quickly
//

import Quickly

protocol IDialogViewControllerRoutePath : IQRoutePath {

    func presentConfirmDialog()
    func dismiss(viewController: DialogViewController)
    
}

class DialogViewController : QNibViewController, IQRoutable {

    weak var routePath: IDialogViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    @IBOutlet private weak var showDialogButton: QButton!

    init(_ routePath: IDialogViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QText("Show dialog", color: UIColor.black)

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Show dialog", color: UIColor.black)

        self.showDialogButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.normalStyle = normalStyle
        self.showDialogButton.highlightedStyle = highlightedStyle
        self.showDialogButton.addTouchUpInside(self, action: #selector(self.pressedShowDialog(_:)))
    }

    @objc
    private func pressedShowDialog(_ sender: Any) {
        self.routePath.presentConfirmDialog()
    }

}
