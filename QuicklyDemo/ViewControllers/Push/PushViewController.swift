//
//
//  Quickly
//

import Quickly

protocol IPushViewControllerRoutePath : IQRoutePath {

    func presentConfirmPush()
    func dismiss(viewController: PushViewController)
    
}

class PushViewController : QNibViewController, IQRoutable {

    var routePath: IPushViewControllerRoutePath
    var routeContext: AppRouteContext

    @IBOutlet private weak var showPushButton: QButton!

    init(_ routePath: IPushViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func didLoad() {
        super.didLoad()

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

    @objc
    private func pressedShowPush(_ sender: Any) {
        self.routePath.presentConfirmPush()
    }

}
