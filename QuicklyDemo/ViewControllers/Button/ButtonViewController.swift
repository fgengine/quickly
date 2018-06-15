//
//
//  Quickly
//

import Quickly

protocol IButtonViewControllerRoutePath : IQRoutePath {

    func dismiss(viewController: ButtonViewController)
    
}

class ButtonViewController : QNibViewController, IQRoutable {

    var routePath: IButtonViewControllerRoutePath
    var routeContext: AppRouteContext

    @IBOutlet private weak var button: QButton!
    @IBOutlet private weak var spinnerButton: QButton!

    init(_ routePath: IButtonViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.red
        normalStyle.cornerRadius = QViewCornerRadius.auto
        normalStyle.shadow = QViewShadow(color: .black, opacity: 0.5, radius: 10, offset: CGSize(width: 0, height: 6))
        normalStyle.text = QText("Normal", color: UIColor.black)
        normalStyle.image = QImageSource(
            "button_image",
            renderingMode: .alwaysTemplate,
            tintColor: UIColor.black
        )

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.blue
        highlightedStyle.text = QText("Highlighted", color: UIColor.white)
        highlightedStyle.image = QImageSource(
            "button_image",
            renderingMode: .alwaysTemplate,
            tintColor: UIColor.white
        )

        self.button.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.normalStyle = normalStyle
        self.button.highlightedStyle = highlightedStyle
        self.button.addTouchUpInside(self, action: #selector(self.pressedButton(_:)))

        self.spinnerButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.normalStyle = normalStyle
        self.spinnerButton.highlightedStyle = highlightedStyle
        self.spinnerButton.spinnerView = QSpinnerView()
        self.spinnerButton.addTouchUpInside(self, action: #selector(self.pressedSpinnerButton(_:)))
    }

    @objc
    func pressedButton(_ sender: Any) {
        switch self.button.imagePosition {
        case .top: self.button.imagePosition = .right
        case .right: self.button.imagePosition = .bottom
        case .bottom: self.button.imagePosition = .left
        case .left: self.button.imagePosition = .top
        }
        UIView.animate(withDuration: 2.0) {
            self.button.layoutIfNeeded()
        }
    }

    @objc
    func pressedSpinnerButton(_ sender: Any) {
        UIView.animate(withDuration: 2.0) {
            self.spinnerButton.startSpinner()
            self.spinnerButton.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            UIView.animate(withDuration: 2.0) {
                self.spinnerButton.stopSpinner()
                self.spinnerButton.layoutIfNeeded()
            }
        }
    }

}
