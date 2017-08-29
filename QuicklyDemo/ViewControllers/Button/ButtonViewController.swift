//
//
//  Quickly
//

import Quickly

protocol IButtonViewControllerRouter: IQRouter {

    func presentButtonViewController()
    func dismiss(viewController: ButtonViewController)
    
}

class ButtonViewController: QStaticViewController, IQRouted {

    public var router: IButtonViewControllerRouter?
    public var container: IQContainer {
        get { return self.router!.container }
    }

    @IBOutlet private weak var button: QButton!
    @IBOutlet private weak var spinnerButton: QButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let normalStyle: QButtonStyle = QButtonStyle()
        normalStyle.color = UIColor.red
        normalStyle.cornerRadius = 4
        normalStyle.text = QText("Normal")
        normalStyle.imageSource = QImageSource("button_image")

        let highlightedStyle: QButtonStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.blue
        highlightedStyle.text = QText("Highlighted")

        self.button.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.button.normalStyle = normalStyle
        self.button.highlightedStyle = highlightedStyle

        self.spinnerButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.spinnerButton.normalStyle = normalStyle
        self.spinnerButton.highlightedStyle = highlightedStyle
        self.spinnerButton.spinnerView = QSystemSpinnerView()
    }

    @IBAction func pressedButton(_ sender: Any) {
        switch self.button.imagePosition {
        case .top: self.button.imagePosition = .left
        case .left: self.button.imagePosition = .right
        case .right: self.button.imagePosition = .bottom
        case .bottom: self.button.imagePosition = .top
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func pressedSpinnerButton(_ sender: Any) {
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
