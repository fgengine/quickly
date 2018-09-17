//
//  Quickly
//

open class QTextFieldStyleSheet : QDisplayViewStyleSheet< QTextField > {

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
        requireValidator: Bool = true,
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

    public override func apply(_ target: QTextField) {
        super.apply(target)

        target.requireValidator = self.requireValidator
        target.validator = self.validator
        target.formatter = self.formatter
        target.textInsets = self.textInsets
        target.textStyle = self.textStyle
        target.editingInsets = self.editingInsets
        target.placeholderInsets = self.placeholderInsets
        target.placeholder = self.placeholder
        target.typingStyle = self.typingStyle
        target.autocapitalizationType = self.autocapitalizationType
        target.autocorrectionType = self.autocorrectionType
        target.spellCheckingType = self.spellCheckingType
        target.keyboardType = self.keyboardType
        target.keyboardAppearance = self.keyboardAppearance
        target.returnKeyType = self.returnKeyType
        target.enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically
        target.isSecureTextEntry = self.isSecureTextEntry
        if #available(iOS 10.0, *) {
            target.textContentType = self.textContentType
        }
        target.isEnabled = self.isEnabled
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

    public var requireValidator: Bool = true
    public var validator: IQInputValidator? {
        willSet { self.field.delegate = nil }
        didSet {self.field.delegate = self.fieldDelegate }
    }
    public var formatter: IQStringFormatter? {
        willSet {
            if let formatter = self.formatter {
                if let text = self.field.text {
                    var caret: Int
                    if let selected = self.field.selectedTextRange {
                        caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.field.text = formatter.unformat(text, caret: &caret)
                    if let position = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                        self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                    }
                }
            }
        }
        didSet {
            if let formatter = self.formatter {
                if let text = self.field.text {
                    var caret: Int
                    if let selected = self.field.selectedTextRange {
                        caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.field.text = formatter.format(text, caret: &caret)
                    if let position = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                        self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                    }
                }
            }
        }
    }
    public var textInsets: UIEdgeInsets {
        set(value) { self.field.textInsets = value }
        get { return self.field.textInsets }
    }
    public var textStyle: IQTextStyle? {
        didSet {
            var attributes: [NSAttributedStringKey: Any] = [:]
            if let textStyle = self.textStyle {
                attributes = textStyle.attributes
                self.field.font = attributes[.font] as? UIFont
                self.field.textColor = attributes[.foregroundColor] as? UIColor
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    self.field.textAlignment = paragraphStyle.alignment
                } else {
                    self.field.textAlignment = .left
                }
            } else {
                if let font = self.field.font {
                    attributes[.font] = font
                }
                if let textColor = self.field.textColor {
                    attributes[.foregroundColor] = textColor
                }
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = self.field.textAlignment
                attributes[.paragraphStyle] = paragraphStyle
            }
            self.field.defaultTextAttributes = Dictionary(uniqueKeysWithValues:
                attributes.lazy.map { ($0.key.rawValue, $0.value) }
            )
        }
    }
    public var text: String {
        set(value) { self.field.text = value }
        get {
            if let text = self.field.text {
                return text
            }
            return ""
        }
    }
    public var unformatText: String {
        set(value) {
            if let formatter = self.formatter {
                var caret: Int
                if let selected = self.field.selectedTextRange {
                    caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                } else {
                    caret = text.count
                }
                self.field.text = formatter.format(value, caret: &caret)
                if let position = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                    self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                }
            } else {
                self.field.text = value
            }
        }
        get {
            var result: String
            if let text = self.field.text {
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
        set(value) { self.field.editingInsets = value }
        get { return self.field.editingInsets }
    }
    public var placeholderInsets: UIEdgeInsets {
        set(value) { self.field.placeholderInsets = value }
        get { return self.field.placeholderInsets }
    }
    public var typingStyle: IQTextStyle? {
        didSet {
            if let typingStyle = self.typingStyle {
                self.field.allowsEditingTextAttributes = true
                self.field.typingAttributes = Dictionary(uniqueKeysWithValues:
                    typingStyle.attributes.lazy.map { ($0.key.rawValue, $0.value) }
                )
            } else {
                self.field.allowsEditingTextAttributes = false
                self.field.typingAttributes = nil
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
                self.field.attributedPlaceholder = text.attributed
            } else {
                self.field.attributedPlaceholder = nil
            }
        }
        get {
            if let attributed = self.field.attributedPlaceholder {
                return QText(attributed)
            }
            return nil
        }
    }
    public var isEnabled: Bool {
        set(value) { self.field.isEnabled = value }
        get { return self.field.isEnabled }
    }
    public var isEditing: Bool {
        get { return self.field.isEditing }
    }
    open override var intrinsicContentSize: CGSize {
        get { return self.field.intrinsicContentSize }
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

    internal private(set) var field: Field!
    
    private var fieldDelegate: FieldDelegate!
    private var observer: QObserver< IQTextFieldObserver >
    
    public required init() {
        self.observer = QObserver< IQTextFieldObserver >()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        self.observer = QObserver< IQTextFieldObserver >()
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self.observer = QObserver< IQTextFieldObserver >()
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.fieldDelegate = FieldDelegate(field: self)

        self.field = Field(frame: self.bounds)
        self.field.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.field.delegate = self.fieldDelegate
        self.addSubview(self.field)
    }
    
    public func addObserver(_ observer: IQTextFieldObserver, priority: UInt) {
        self.observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQTextFieldObserver) {
        self.observer.remove(observer)
    }

    open func beginEditing() {
        self.field.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.field.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.field.sizeToFit()
    }

    public class Field : UITextField, IQView {

        public var textInsets: UIEdgeInsets = UIEdgeInsets.zero
        public var storeEditingInsets: UIEdgeInsets?
        public var editingInsets: UIEdgeInsets {
            set(value) { self.storeEditingInsets = value }
            get {
                guard let insets = self.storeEditingInsets else { return self.textInsets }
                return insets
            }
        }
        public var storePlaceholderInsets: UIEdgeInsets?
        public var placeholderInsets: UIEdgeInsets {
            set(value) { self.storeEditingInsets = value }
            get {
                guard let insets = self.storePlaceholderInsets else { return self.textInsets }
                return insets
            }
        }

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
            return UIEdgeInsetsInsetRect(bounds, self.textInsets)
        }

        open override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, self.editingInsets)
        }

        open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, self.placeholderInsets)
        }

    }

    public class FieldDelegate : NSObject, UITextFieldDelegate {

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
            field.observer.reverseNotify({ (observer) in
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
            field.observer.reverseNotify({ (observer) in
                observer.endEditing(textField: field)
            })
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let field = self.field else { return true }
            var caret = range.location + string.count
            var text = textField.text ?? ""
            if let textRange = text.range(from: range) {
                text = text.replacingCharacters(in: textRange, with: string)
            }
            var unformat: String
            if let formatter = field.formatter {
                unformat = formatter.unformat(text, caret: &caret)
            } else {
                unformat = text
            }
            var isValid: Bool
            if let validator = field.validator {
                isValid = validator.validate(unformat)
            } else {
                isValid = true
            }
            if field.requireValidator == false || string.isEmpty == true || isValid == true {
                var location: UITextPosition?
                if let formatter = field.formatter {
                    let format = formatter.format(unformat, caret: &caret)
                    location = textField.position(from: textField.beginningOfDocument, offset: caret)
                    textField.text = format
                } else {
                    location = textField.position(from: textField.beginningOfDocument, offset: caret)
                    textField.text = unformat
                }
                if let location = location {
                    textField.selectedTextRange = textField.textRange(from: location, to: location)
                }
                textField.sendActions(for: .editingChanged)
                NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                if let closure = field.onEditing {
                    closure(field)
                }
                field.observer.reverseNotify({ (observer) in
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
                    field.observer.reverseNotify({ (observer) in
                        observer.pressedClear(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedClear {
                    pressedClosure(field)
                }
                field.observer.reverseNotify({ (observer) in
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
                    field.observer.reverseNotify({ (observer) in
                        observer.pressedReturn(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedReturn {
                    pressedClosure(field)
                }
                field.observer.reverseNotify({ (observer) in
                    observer.pressedReturn(textField: field)
                })
            }
            return true
        }

    }

}

extension QTextField : UITextInputTraits {

    public var autocapitalizationType: UITextAutocapitalizationType {
        set(value) { self.field.autocapitalizationType = value }
        get { return self.field.autocapitalizationType }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        set(value) { self.field.autocorrectionType = value }
        get { return self.field.autocorrectionType }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        set(value) { self.field.spellCheckingType = value }
        get { return self.field.spellCheckingType }
    }

    public var keyboardType: UIKeyboardType {
        set(value) { self.field.keyboardType = value }
        get { return self.field.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        set(value) { self.field.keyboardAppearance = value }
        get { return self.field.keyboardAppearance }
    }

    public var returnKeyType: UIReturnKeyType {
        set(value) { self.field.returnKeyType = value }
        get { return self.field.returnKeyType }
    }

    public var enablesReturnKeyAutomatically: Bool {
        set(value) { self.field.enablesReturnKeyAutomatically = value }
        get { return self.field.enablesReturnKeyAutomatically }
    }

    public var isSecureTextEntry: Bool {
        set(value) { self.field.isSecureTextEntry = value }
        get { return self.field.isSecureTextEntry }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        set(value) { self.field.textContentType = value }
        get { return self.field.textContentType }
    }

}
