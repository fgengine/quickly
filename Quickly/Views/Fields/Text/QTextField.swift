//
//  Quickly
//

open class QTextFieldStyleSheet : QDisplayViewStyleSheet {

    public var requireValidator: Bool
    public var validator: IQInputValidator?
    public var formatter: IQStringFormatter?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var editingInsets: UIEdgeInsets
    public var placeholderInsets: UIEdgeInsets
    public var placeholder: IQText?
    public var typingStyle: IQTextStyle?
    public var autocapitalizationType: UITextAutocapitalizationType
    public var autocorrectionType: UITextAutocorrectionType
    public var spellCheckingType: UITextSpellCheckingType
    public var keyboardType: UIKeyboardType
    public var keyboardAppearance: UIKeyboardAppearance
    public var returnKeyType: UIReturnKeyType
    public var enablesReturnKeyAutomatically: Bool
    public var isSecureTextEntry: Bool
    public var textContentType: UITextContentType!
    public var isEnabled: Bool

    public init(
        requireValidator: Bool = false,
        validator: IQInputValidator? = nil,
        formatter: IQStringFormatter? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        editingInsets: UIEdgeInsets = UIEdgeInsets.zero,
        placeholderInsets: UIEdgeInsets = UIEdgeInsets.zero,
        placeholder: IQText? = nil,
        typingStyle: IQTextStyle? = nil,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default,
        keyboardType: UIKeyboardType = .default,
        keyboardAppearance: UIKeyboardAppearance = .default,
        returnKeyType: UIReturnKeyType = .default,
        enablesReturnKeyAutomatically: Bool = true,
        isSecureTextEntry: Bool = false,
        textContentType: UITextContentType! = nil,
        isEnabled: Bool = true,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.requireValidator = requireValidator
        self.validator = validator
        self.formatter = formatter
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.editingInsets = editingInsets
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType
        self.keyboardType = keyboardType
        self.keyboardAppearance = keyboardAppearance
        self.returnKeyType = returnKeyType
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.isSecureTextEntry = isSecureTextEntry
        self.textContentType = textContentType
        self.isEnabled = isEnabled

        super.init(
            backgroundColor: backgroundColor,
            tintColor: tintColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }

    public init(_ styleSheet: QTextFieldStyleSheet) {
        self.requireValidator = styleSheet.requireValidator
        self.validator = styleSheet.validator
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.editingInsets = styleSheet.editingInsets
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.autocapitalizationType = styleSheet.autocapitalizationType
        self.autocorrectionType = styleSheet.autocorrectionType
        self.spellCheckingType = styleSheet.spellCheckingType
        self.keyboardType = styleSheet.keyboardType
        self.keyboardAppearance = styleSheet.keyboardAppearance
        self.returnKeyType = styleSheet.returnKeyType
        self.enablesReturnKeyAutomatically = styleSheet.enablesReturnKeyAutomatically
        self.isSecureTextEntry = styleSheet.isSecureTextEntry
        self.textContentType = styleSheet.textContentType
        self.isEnabled = styleSheet.isEnabled

        super.init(styleSheet)
    }

}

public protocol IQTextFieldObserver : class {
    
    func beginEditing(textField: QTextField)
    func editing(textField: QTextField)
    func endEditing(textField: QTextField)
    func pressedClear(textField: QTextField)
    func pressedReturn(textField: QTextField)
    
}

public class QTextField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ textField: QTextField) -> Bool
    public typealias Closure = (_ textField: QTextField) -> Void

    public var requireValidator: Bool = false
    public var validator: IQInputValidator? {
        willSet { self.fieldView.delegate = nil }
        didSet {self.fieldView.delegate = self._fieldDelegate }
    }
    public var formatter: IQStringFormatter? {
        willSet {
            if let formatter = self.formatter {
                if let text = self.fieldView.text {
                    var caret: Int
                    if let selected = self.fieldView.selectedTextRange {
                        caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.fieldView.text = formatter.unformat(text, caret: &caret)
                    if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                        self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                    }
                }
            }
        }
        didSet {
            if let formatter = self.formatter {
                if let text = self.fieldView.text {
                    var caret: Int
                    if let selected = self.fieldView.selectedTextRange {
                        caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.fieldView.text = formatter.format(text, caret: &caret)
                    if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                        self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                    }
                }
            }
        }
    }
    public var textInsets: UIEdgeInsets {
        set(value) { self.fieldView.textInsets = value }
        get { return self.fieldView.textInsets }
    }
    public var textStyle: IQTextStyle? {
        didSet {
            var attributes: [NSAttributedString.Key: Any] = [:]
            if let textStyle = self.textStyle {
                attributes = textStyle.attributes
                self.fieldView.font = attributes[.font] as? UIFont
                self.fieldView.textColor = attributes[.foregroundColor] as? UIColor
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    self.fieldView.textAlignment = paragraphStyle.alignment
                } else {
                    self.fieldView.textAlignment = .left
                }
            } else {
                if let font = self.fieldView.font {
                    attributes[.font] = font
                }
                if let textColor = self.fieldView.textColor {
                    attributes[.foregroundColor] = textColor
                }
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = self.fieldView.textAlignment
                attributes[.paragraphStyle] = paragraphStyle
            }
            self.fieldView.defaultTextAttributes = Dictionary(uniqueKeysWithValues:
                attributes.lazy.map { (NSAttributedString.Key(rawValue: $0.key.rawValue), $0.value) }
            )
        }
    }
    public var text: String {
        set(value) { self.fieldView.text = value }
        get {
            if let text = self.fieldView.text {
                return text
            }
            return ""
        }
    }
    public var unformatText: String {
        set(value) {
            if let formatter = self.formatter {
                var caret: Int
                if let selected = self.fieldView.selectedTextRange {
                    caret = self.fieldView.offset(from: self.fieldView.beginningOfDocument, to: selected.end)
                } else {
                    caret = text.count
                }
                self.fieldView.text = formatter.format(value, caret: &caret)
                if let position = self.fieldView.position(from: self.fieldView.beginningOfDocument, offset: caret) {
                    self.fieldView.selectedTextRange = self.fieldView.textRange(from: position, to: position)
                }
            } else {
                self.fieldView.text = value
            }
        }
        get {
            var result: String
            if let text = self.fieldView.text {
                if let formatter = self.formatter {
                    result = formatter.unformat(text)
                } else {
                    result = text
                }
            } else {
                result = ""
            }
            return result
        }
    }
    public var editingInsets: UIEdgeInsets {
        set(value) { self.fieldView.editingInsets = value }
        get { return self.fieldView.editingInsets }
    }
    public var placeholderInsets: UIEdgeInsets {
        set(value) { self.fieldView.placeholderInsets = value }
        get { return self.fieldView.placeholderInsets }
    }
    public var typingStyle: IQTextStyle? {
        didSet {
            if let typingStyle = self.typingStyle {
                self.fieldView.allowsEditingTextAttributes = true
                self.fieldView.typingAttributes = Dictionary(uniqueKeysWithValues:
                    typingStyle.attributes.lazy.map { (NSAttributedString.Key(rawValue: $0.key.rawValue), $0.value) }
                )
            } else {
                self.fieldView.allowsEditingTextAttributes = false
                self.fieldView.typingAttributes = nil
            }
        }
    }
    public var isValid: Bool {
        get {
            guard let validator = self.validator else { return true }
            return validator.validate(self.unformatText)
        }
    }
    public var placeholder: IQText? {
        set(value) {
            if let text = value {
                if let attributed = text.attributed {
                    self.fieldView.attributedPlaceholder = attributed
                } else if let font = text.font, let color = text.color {
                    self.fieldView.attributedPlaceholder = NSAttributedString(string: text.string, attributes: [
                        .font: font,
                        .foregroundColor: color
                    ])
                } else {
                    self.fieldView.attributedPlaceholder = nil
                }
            } else {
                self.fieldView.attributedPlaceholder = nil
            }
        }
        get {
            if let attributed = self.fieldView.attributedPlaceholder {
                return QAttributedText(attributed)
            }
            return nil
        }
    }
    public var isEnabled: Bool {
        set(value) { self.fieldView.isEnabled = value }
        get { return self.fieldView.isEnabled }
    }
    public var isEditing: Bool {
        get { return self.fieldView.isEditing }
    }

    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onEditing: Closure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    public var onShouldClear: ShouldClosure?
    public var onPressedClear: Closure?
    public var onShouldReturn: ShouldClosure?
    public var onPressedReturn: Closure?
    
    open override var intrinsicContentSize: CGSize {
        get { return self.fieldView.intrinsicContentSize }
    }

    internal private(set) var fieldView: Field!
    
    private var _fieldDelegate: FieldDelegate!
    private var _observer: QObserver< IQTextFieldObserver > = QObserver< IQTextFieldObserver >()
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self._fieldDelegate = FieldDelegate(field: self)

        self.fieldView = Field(frame: self.bounds)
        self.fieldView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.fieldView.delegate = self._fieldDelegate
        self.addSubview(self.fieldView)
    }
    
    public func addObserver(_ observer: IQTextFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQTextFieldObserver) {
        self._observer.remove(observer)
    }

    open func beginEditing() {
        self.fieldView.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.fieldView.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.fieldView.sizeToFit()
    }
    
    public func apply(_ styleSheet: QTextFieldStyleSheet) {
        self.apply(styleSheet as QDisplayViewStyleSheet)
        
        self.requireValidator = styleSheet.requireValidator
        self.validator = styleSheet.validator
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.editingInsets = styleSheet.editingInsets
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.typingStyle = styleSheet.typingStyle
        self.autocapitalizationType = styleSheet.autocapitalizationType
        self.autocorrectionType = styleSheet.autocorrectionType
        self.spellCheckingType = styleSheet.spellCheckingType
        self.keyboardType = styleSheet.keyboardType
        self.keyboardAppearance = styleSheet.keyboardAppearance
        self.returnKeyType = styleSheet.returnKeyType
        self.enablesReturnKeyAutomatically = styleSheet.enablesReturnKeyAutomatically
        self.isSecureTextEntry = styleSheet.isSecureTextEntry
        if #available(iOS 10.0, *) {
            self.textContentType = styleSheet.textContentType
        }
        self.isEnabled = styleSheet.isEnabled
    }

    internal class Field : UITextField, IQView {

        public var textInsets: UIEdgeInsets = UIEdgeInsets.zero
        public var editingInsets: UIEdgeInsets {
            set(value) { self._editingInsets = value }
            get {
                guard let insets = self._editingInsets else { return self.textInsets }
                return insets
            }
        }
        private var _editingInsets: UIEdgeInsets?
        public var placeholderInsets: UIEdgeInsets {
            set(value) { self._placeholderInsets = value }
            get {
                guard let insets = self._placeholderInsets else { return self.textInsets }
                return insets
            }
        }
        private var _placeholderInsets: UIEdgeInsets?

        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        open func setup() {
            self.backgroundColor = UIColor.clear
        }

        open override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: self.textInsets)
        }

        open override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: self.editingInsets)
        }

        open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: self.placeholderInsets)
        }

    }

    private class FieldDelegate : NSObject, UITextFieldDelegate {

        public weak var field: QTextField?

        public init(field: QTextField?) {
            self.field = field
            super.init()
        }

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            guard let field = self.field, let closure = field.onShouldBeginEditing else { return true }
            return closure(field)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            guard let field = self.field else { return }
            if let closure = field.onBeginEditing {
                closure(field)
            }
            field._observer.reverseNotify({ (observer) in
                observer.beginEditing(textField: field)
            })
        }

        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            guard let field = self.field, let closure = field.onShouldEndEditing else { return true }
            return closure(field)
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            guard let field = self.field else { return }
            if let closure = field.onEndEditing {
                closure(field)
            }
            field._observer.reverseNotify({ (observer) in
                observer.endEditing(textField: field)
            })
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let field = self.field else { return true }
            var caret = range.location + string.count
            var sourceText = textField.text ?? ""
            if let sourceTextRange = sourceText.range(from: range) {
                sourceText = sourceText.replacingCharacters(in: sourceTextRange, with: string)
            }
            var sourceUnformat: String
            if let formatter = field.formatter {
                sourceUnformat = formatter.unformat(sourceText, caret: &caret)
            } else {
                sourceUnformat = sourceText
            }
            var isValid: Bool
            if let validator = field.validator {
                isValid = validator.validate(sourceUnformat)
            } else {
                isValid = true
            }
            if field.requireValidator == false || string.isEmpty == true || isValid == true {
                var location: UITextPosition?
                if let formatter = field.formatter {
                    let format = formatter.format(sourceUnformat, caret: &caret)
                    location = textField.position(from: textField.beginningOfDocument, offset: caret)
                    textField.text = format
                } else {
                    location = textField.position(from: textField.beginningOfDocument, offset: caret)
                    textField.text = sourceUnformat
                }
                if let location = location {
                    textField.selectedTextRange = textField.textRange(from: location, to: location)
                }
                textField.sendActions(for: .editingChanged)
                NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
                if let closure = field.onEditing {
                    closure(field)
                }
                field._observer.reverseNotify({ (observer) in
                    observer.editing(textField: field)
                })
            }
            return false
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            guard let field = self.field else { return true }
            if let shouldClosure = field.onShouldClear {
                if shouldClosure(field) == true {
                    if let pressedClosure = field.onPressedClear {
                        pressedClosure(field)
                    }
                    field._observer.reverseNotify({ (observer) in
                        observer.pressedClear(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedClear {
                    pressedClosure(field)
                }
                field._observer.reverseNotify({ (observer) in
                    observer.pressedClear(textField: field)
                })
            }
            return true
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let field = self.field else { return true }
            if let shouldClosure = field.onShouldReturn {
                if shouldClosure(field) == true {
                    if let pressedClosure = field.onPressedReturn {
                        pressedClosure(field)
                    }
                    field._observer.reverseNotify({ (observer) in
                        observer.pressedReturn(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedReturn {
                    pressedClosure(field)
                }
                field._observer.reverseNotify({ (observer) in
                    observer.pressedReturn(textField: field)
                })
            }
            return true
        }

    }

}

extension QTextField : UITextInputTraits {

    public var autocapitalizationType: UITextAutocapitalizationType {
        set(value) { self.fieldView.autocapitalizationType = value }
        get { return self.fieldView.autocapitalizationType }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        set(value) { self.fieldView.autocorrectionType = value }
        get { return self.fieldView.autocorrectionType }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        set(value) { self.fieldView.spellCheckingType = value }
        get { return self.fieldView.spellCheckingType }
    }

    public var keyboardType: UIKeyboardType {
        set(value) { self.fieldView.keyboardType = value }
        get { return self.fieldView.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        set(value) { self.fieldView.keyboardAppearance = value }
        get { return self.fieldView.keyboardAppearance }
    }

    public var returnKeyType: UIReturnKeyType {
        set(value) { self.fieldView.returnKeyType = value }
        get { return self.fieldView.returnKeyType }
    }

    public var enablesReturnKeyAutomatically: Bool {
        set(value) { self.fieldView.enablesReturnKeyAutomatically = value }
        get { return self.fieldView.enablesReturnKeyAutomatically }
    }

    public var isSecureTextEntry: Bool {
        set(value) { self.fieldView.isSecureTextEntry = value }
        get { return self.fieldView.isSecureTextEntry }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        set(value) { self.fieldView.textContentType = value }
        get { return self.fieldView.textContentType }
    }

}
