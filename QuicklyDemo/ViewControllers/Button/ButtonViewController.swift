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

    @IBOutlet private weak var button: QButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let normalStyle: QButtonStyle = QButtonStyle()
        normalStyle.color = UIColor.red
        normalStyle.text = QText("Normal")
        normalStyle.imageSource = QImageSource("button_image")
        self.button.normalStyle = normalStyle

        let highlightedStyle: QButtonStyle = QButtonStyle(parent: normalStyle)
        highlightedStyle.color = UIColor.blue
        highlightedStyle.text = QText("Highlighted")
        self.button.highlightedStyle = highlightedStyle
    }

    @IBAction func pressedButton(_ sender: Any) {
        switch self.button.imagePosition {
        case .top: self.button.imagePosition = .left
        case .left: self.button.imagePosition = .right
        case .right: self.button.imagePosition = .bottom
        case .bottom: self.button.imagePosition = .top
        }
    }

}
