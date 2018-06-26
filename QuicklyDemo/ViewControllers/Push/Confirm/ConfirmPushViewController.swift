//
//
//  Quickly
//

import Quickly

protocol IConfirmPushViewControllerRoutePath : IQRoutePath {

    func dismiss(viewController: ConfirmPushViewController)
    
}

class ConfirmPushViewController : QNibViewController, IQPushContentViewController, IQRoutable {

    weak var routePath: IConfirmPushViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var titleLabel: QLabel!
    @IBOutlet private weak var subtitleLabel: QLabel!

    init(_ routePath: IConfirmPushViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
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
        self.routePath.dismiss(viewController: self)
    }

    func didPressed() {
        self.routePath.dismiss(viewController: self)
    }

}
