//
//
//  Quickly
//

import Quickly

protocol ITextFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: TextFieldViewController)
    
}

class TextFieldViewController: QStaticViewController, IQRouted {

    public var router: ITextFieldViewControllerRouter
    public var container: AppContainer

    private var keyboard: QKeyboard

    @IBOutlet private weak var textField: QTextField!

    public init(router: ITextFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        self.keyboard = QKeyboard()
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let textStyle = QTextStyle()
        textStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        textStyle.color = UIColor.darkGray

        let typingStyle = QTextStyle()
        typingStyle.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        typingStyle.color = UIColor.white
        typingStyle.backgroundColor = UIColor.darkGray

        self.textField.layer.borderColor = UIColor.red.cgColor
        self.textField.layer.borderWidth = 1
        self.textField.textInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        self.textField.textStyle = textStyle
        self.textField.typingStyle = typingStyle
        self.textField.placeholder = QText("TextField")
        self.textField.requireValidator = true
        self.textField.validator = QInputValidator(
            validator: try! QAmountStringValidator(maximumSimbol: 10, locale: Locale.current, maximumDecimalSimbol: 2)
        )
        self.textField.formatter = QAmountStringFormatter(locale: Locale.current)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.keyboard.addObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.textField.field.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.keyboard.removeObserver(self)
    }

}

extension TextFieldViewController : QKeyboardObserver {

    func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

    func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

    func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

    func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

}
