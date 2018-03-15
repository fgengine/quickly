//
//
//  Quickly
//

import Quickly

protocol IConfirmPushViewControllerRouter: IQRouter {

    func dismiss(viewController: ConfirmPushViewController)
    
}

class ConfirmPushViewController: QStaticViewController, IQPushContentViewController, IQRouted {

    public weak var pushViewController: IQPushContentViewController.PushViewControllerType?
    public var router: IConfirmPushViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var titleLabel: QLabel!
    @IBOutlet private weak var subtitleLabel: QLabel!

    public init(router: IConfirmPushViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray
        self.view.layer.cornerRadius = 8

        self.imageView.source = QImageSource("dialog_confirm")
        self.titleLabel.text = QText("Push title", color: .black)
        self.subtitleLabel.text = QText("Push subtitle", color: .black)
    }

    public func didTimeout() {
        self.router.dismiss(viewController: self)
    }

    public func didPressed() {
        self.router.dismiss(viewController: self)
    }

}
