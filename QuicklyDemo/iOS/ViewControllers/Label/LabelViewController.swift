//
//
//  Quickly
//

import Quickly

protocol ILabelViewControllerRouter: IQRouter {

    func presentLabelViewController()
    func dismiss(viewController: LabelViewController)
    
}

class LabelViewController: QStaticViewController, IQRouted {

    public var router: ILabelViewControllerRouter?
    public var container: AppContainer?

    @IBOutlet private weak var label: QLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.label.text = QText("This is text, This is text\nThis is text", color: UIColor.blue)
        self.label.numberOfLines = 2
    }

}
