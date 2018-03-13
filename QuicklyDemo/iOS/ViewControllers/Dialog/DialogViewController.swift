//
//
//  Quickly
//

import Quickly

protocol IDialogViewControllerRouter: IQRouter {

    func presentConfirmDialog()
    func dismiss(viewController: DialogViewController)
    
}

class DialogViewController: QStaticViewController, IQRouted {

    public var router: IDialogViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var showDialogButton: QButton!

    public init(router: IDialogViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let normalStyle: QButtonStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = 4
        normalStyle.text = QText("Show dialog", color: UIColor.black)

        let highlightedStyle: QButtonStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Show dialog", color: UIColor.black)

        self.showDialogButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showDialogButton.normalStyle = normalStyle
        self.showDialogButton.highlightedStyle = highlightedStyle
        self.showDialogButton.addTouchUpInside(self, action: #selector(self.pressedShowDialog(_:)))
    }

    @objc func pressedShowDialog(_ sender: Any) {
        self.router.presentConfirmDialog()
    }

}
