//
//
//  Quickly
//

import Quickly

protocol IPushViewControllerRouter: IQRouter {

    func presentConfirmPush()
    func dismiss(viewController: PushViewController)
    
}

class PushViewController: QStaticViewController, IQRouted {

    public var router: IPushViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var showPushButton: QButton!

    public init(router: IPushViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QText("Show push", color: UIColor.black)

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Show push", color: UIColor.black)

        self.showPushButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showPushButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.showPushButton.normalStyle = normalStyle
        self.showPushButton.highlightedStyle = highlightedStyle
        self.showPushButton.addTouchUpInside(self, action: #selector(self.pressedShowPush(_:)))
    }

    @objc private func pressedShowPush(_ sender: Any) {
        self.router.presentConfirmPush()
    }

}
