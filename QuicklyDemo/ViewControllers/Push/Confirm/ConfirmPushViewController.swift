//
//
//  Quickly
//

import Quickly

protocol IConfirmPushViewControllerRouter : IQRouter {

    func dismiss(viewController: ConfirmPushViewController)
    
}

class ConfirmPushViewController : QNibViewController, IQPushContentViewController, IQRouted {

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

    override func setup() {
        super.setup()

        self.edgesForExtendedLayout = []
    }

    override func didLoad() {
        super.didLoad()

        self.view.layer.cornerRadius = 8

        self.rootView.backgroundColor = UIColor.lightGray

        self.imageView.source = QImageSource("icon_confirm")
        self.titleLabel.text = QText("Push title", color: .black)
        self.subtitleLabel.text = QText("Push subtitle", color: .black)
    }

    func didTimeout() {
        self.router.dismiss(viewController: self)
    }

    func didPressed() {
        self.router.dismiss(viewController: self)
    }

}
