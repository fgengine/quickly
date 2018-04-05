//
//
//  Quickly
//

import Quickly

protocol IButtonViewControllerRouter: IQRouter {

    func dismiss(viewController: ButtonViewController)
    
}

class ButtonViewController: QStaticViewController, IQRouted {

    public var router: IButtonViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var button: QButton!
    @IBOutlet private weak var spinnerButton: QButton!

    public init(router: IButtonViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let normalStyle = QButtonStyle()
        normalStyle.color = UIColor.red
        normalStyle.cornerRadius = QViewCornerRadius.auto
        normalStyle.text = QText("Normal", color: UIColor.black)
        normalStyle.imageSource = QImageSource(
            "button_image",
            renderingMode: .alwaysTemplate,
            tintColor: UIColor.black
        )

        let highlightedStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.blue
        highlightedStyle.text = QText("Highlighted", color: UIColor.white)
        highlightedStyle.imageSource = QImageSource(
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

    @objc func pressedButton(_ sender: Any) {
        switch self.button.imagePosition {
        case .top: self.button.imagePosition = .right
        case .right: self.button.imagePosition = .bottom
        case .bottom: self.button.imagePosition = .left
        case .left: self.button.imagePosition = .top
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func pressedSpinnerButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.spinnerButton.startSpinner()
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            UIView.animate(withDuration: 0.2) {
                self.spinnerButton.stopSpinner()
                self.view.layoutIfNeeded()
            }
        }
    }

}
