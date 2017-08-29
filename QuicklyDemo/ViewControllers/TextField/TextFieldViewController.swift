//
//
//  Quickly
//

import Quickly

protocol ITextFieldViewControllerRouter: IQRouter {

    func presentTextFieldViewController()
    func dismiss(viewController: TextFieldViewController)
    
}

class TextFieldViewController: QStaticViewController, IQRouted {

    public var router: ITextFieldViewControllerRouter?
    public var container: IQContainer {
        get { return self.router!.container }
    }

    @IBOutlet private weak var textField: QTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let textStyle: QTextStyle = QTextStyle()
        textStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        textStyle.color = UIColor.darkGray

        let typingStyle: QTextStyle = QTextStyle()
        typingStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        typingStyle.color = UIColor.white
        typingStyle.backgroundColor = UIColor.darkGray

        self.textField.textStyle = textStyle
        self.textField.typingStyle = typingStyle
    }

}
