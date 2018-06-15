//
//
//  Quickly
//

import Quickly

protocol IConfirmDialogViewControllerRoutePath : IQRoutePath {

    func dismiss(viewController: ConfirmDialogViewController)
    
}

class ConfirmDialogViewController : QNibViewController, IQDialogContentViewController, IQRoutable {

    var routePath: IConfirmDialogViewControllerRoutePath
    var routeContext: AppRouteContext

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    init(_ routePath: IConfirmDialogViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.view.layer.cornerRadius = 4

        self.imageView.source = QImageSource("icon_confirm")

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.lightGray
        normalStyle.cornerRadius = QViewCornerRadius.manual(radius: 4)
        normalStyle.text = QText("Close", color: UIColor.black)

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.darkGray
        highlightedStyle.text = QText("Close", color: UIColor.black)

        self.closeButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.closeButton.normalStyle = normalStyle
        self.closeButton.highlightedStyle = highlightedStyle
        self.closeButton.addTouchUpInside(self, action: #selector(self.pressedClose(_:)))
    }

    override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }

    func didPressedOutsideContent() {
        self.routePath.dismiss(viewController: self)
    }

    @objc
    private func pressedClose(_ sender: Any) {
        self.routePath.dismiss(viewController: self)
    }

}
