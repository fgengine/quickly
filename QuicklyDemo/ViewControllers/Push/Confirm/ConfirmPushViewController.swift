//
//
//  Quickly
//

import Quickly

protocol IConfirmPushViewControllerRouter: IQRouter {

    func dismiss(viewController: ConfirmPushViewController)
    
}

class ConfirmPushViewController: QStaticViewController, IQPushContentViewController, IQRouted {

    weak var pushViewController: IQPushViewController?
    var router: IConfirmPushViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var titleLabel: QLabel!
    @IBOutlet private weak var subtitleLabel: QLabel!

    init(router: IConfirmPushViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init()
    }

    public override func setup() {
        super.setup()

        self.edgesForExtendedLayout = []
    }

    public override func didLoad() {
        super.didLoad()

        self.rootView.backgroundColor = UIColor.lightGray
        self.rootView.layer.cornerRadius = 8

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
