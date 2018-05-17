//
//
//  Quickly
//

import Quickly

protocol ITextFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: TextFieldViewController)
    
}

class TextFieldViewController: QStaticViewController, IQRouted {

    var router: ITextFieldViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var textField: QTextField!

    private var keyboard: QKeyboard

    init(router: ITextFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        self.keyboard = QKeyboard()
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didLoad() {
        super.didLoad()

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

    override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.keyboard.addObserver(self, priority: 0)
    }

    override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.textField.field.becomeFirstResponder()
    }

    override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.view.endEditing(false)
    }

    override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.view.endEditing(false)
    }

    override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.textField.field.becomeFirstResponder()
    }

    override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
    }

    override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
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
