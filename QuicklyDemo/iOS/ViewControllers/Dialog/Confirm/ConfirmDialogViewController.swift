//
//
//  Quickly
//

import Quickly

protocol IConfirmDialogViewControllerRouter: IQRouter {

    func dismiss(viewController: ConfirmDialogViewController)
    
}

class ConfirmDialogViewController: QStaticViewController, IQDialogContentViewController, IQRouted {

    public weak var dialogViewController: IQDialogContentViewController.DialogViewControllerType?
    public var router: IConfirmDialogViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    public init(router: IConfirmDialogViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

        self.statusBarStyle = .lightContent
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 4

        self.imageView.source = QImageSource("dialog_confirm")

        let normalStyle: QButtonStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = 4
        normalStyle.text = QText("Close", color: UIColor.black)

        let highlightedStyle: QButtonStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Close", color: UIColor.black)

        self.closeButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.normalStyle = normalStyle
        self.closeButton.highlightedStyle = highlightedStyle
        self.closeButton.addTouchUpInside(self, action: #selector(self.pressedClose(_:)))
    }

    public func didPressedOutsideContent() {
        self.router.dismiss(viewController: self)
    }

    @objc private func pressedClose(_ sender: Any) {
        self.router.dismiss(viewController: self)
    }

}
