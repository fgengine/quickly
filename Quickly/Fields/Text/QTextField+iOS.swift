//
//  Quickly
//

#if os(iOS)

    @IBDesignable
    open class QTextField : QView, IQField {

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
        public var textStyle: QTextStyle? {
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
        public var typingStyle: QTextStyle? {
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

        public var onShouldBeginEditing: ShouldClosure?
        public var onBeginEdititing: Closure?
        public var onEdititing: Closure?
        public var onShouldEndEditing: ShouldClosure?
        public var onEndEdititing: Closure?
        public var onShouldClear: ShouldClosure?
        public var onPressedClear: Closure?
        public var onShouldReturn: ShouldClosure?
        public var onPressedReturn: Closure?

        public private(set) var field: Field!
        private var fieldDelegate: FieldDelegate!

        open override var intrinsicContentSize: CGSize {
            get {
                return self.field.intrinsicContentSize
            }
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
                guard let field = self.field, let closure = field.onBeginEdititing else { return }
                closure(field)
            }

            public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                guard let field = self.field, let closure = field.onShouldEndEditing else { return true }
                return closure(field)
            }

            public func textFieldDidEndEditing(_ textField: UITextField) {
                guard let field = self.field, let closure = field.onEndEdititing else { return }
                closure(field)
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
                if field.requireValidator == false || field.isValid == true {
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
                    if let closure = field.onEdititing {
                        closure(field)
                    }
                }
                return false
            }

            public func textFieldShouldClear(_ textField: UITextField) -> Bool {
                guard let field = self.field else { return true }
                if let shouldClosure = field.onShouldClear, let pressedClosure = field.onPressedClear {
                    if shouldClosure(field) == true {
                        pressedClosure(field)
                    }
                } else if let pressedClosure = field.onPressedClear {
                    pressedClosure(field)
                }
                return true
            }

            public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                guard let field = self.field else { return true }
                if let shouldClosure = field.onShouldReturn, let pressedClosure = field.onPressedReturn {
                    if shouldClosure(field) == true {
                        pressedClosure(field)
                    }
                } else if let pressedClosure = field.onPressedReturn {
                    pressedClosure(field)
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

#endif
