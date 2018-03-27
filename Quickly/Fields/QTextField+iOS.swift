//
//  Quickly
//

#if os(iOS)

    @IBDesignable
    open class QTextField : QView {

        public typealias ShouldClosure = (_ textField: QTextField) -> Bool
        public typealias Closure = (_ textField: QTextField) -> Void

        @IBInspectable public weak var delegate: UITextFieldDelegate? {
            set(value) { self.field.delegate = value }
            get { return self.field.delegate }
        }
        public var requireValidator: Bool = true
        public var validator: IQInputValidator? {
            willSet { self.field.delegate = nil }
            didSet {
                self.field.delegate = self.proxy
                if let validator: IQInputValidator = self.validator {
                    self.isValid = validator.validate(self.unformatText)
                } else {
                    self.isValid = true
                }
            }
        }
        public private(set) var isValid: Bool = true
        public var formatter: IQStringFormatter? {
            willSet {
                if let formatter: IQStringFormatter = self.formatter {
                    if let text: String = self.field.text {
                        var caret: Int
                        if let selected: UITextRange = self.field.selectedTextRange {
                            caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                        } else {
                            caret = text.count
                        }
                        self.field.text = formatter.unformat(text, caret: &caret)
                        if let position: UITextPosition = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                            self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                        }
                    }
                }
            }
            didSet {
                if let formatter: IQStringFormatter = self.formatter {
                    if let text: String = self.field.text {
                        var caret: Int
                        if let selected: UITextRange = self.field.selectedTextRange {
                            caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                        } else {
                            caret = text.count
                        }
                        self.field.text = formatter.format(text, caret: &caret)
                        if let position: UITextPosition = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                            self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                        }
                    }
                }
            }
        }

        public var textInsets: UIEdgeInsets {
            set(value) { self.field.insets = value }
            get { return self.field.insets }
        }
        public var textAlignment: NSTextAlignment {
            set(value) { self.field.textAlignment = value }
            get { return self.field.textAlignment }
        }
        public var textStyle: QTextStyle? {
            didSet {
                var attributes: [NSAttributedStringKey: Any] = [:]
                if let textStyle: QTextStyle = self.textStyle {
                    attributes = textStyle.attributes
                    self.field.font = attributes[.font] as? UIFont
                    self.field.textColor = attributes[.foregroundColor] as? UIColor
                } else {
                    if let font: UIFont = self.field.font {
                        attributes[.font] = font
                    }
                    if let textColor: UIColor = self.field.textColor {
                        attributes[.foregroundColor] = textColor
                    }
                }
                self.field.defaultTextAttributes = Dictionary(uniqueKeysWithValues:
                    attributes.lazy.map { ($0.key.rawValue, $0.value) }
                )
            }
        }
        public var text: String {
            set(value) { self.field.text = value }
            get {
                if let text: String = self.field.text {
                    return text
                }
                return ""
            }
        }
        public var unformatText: String {
            set(value) {
                if let formatter: IQStringFormatter = self.formatter {
                    var caret: Int
                    if let selected: UITextRange = self.field.selectedTextRange {
                        caret = self.field.offset(from: self.field.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self.field.text = formatter.format(value, caret: &caret)
                    if let position: UITextPosition = self.field.position(from: self.field.beginningOfDocument, offset: caret) {
                        self.field.selectedTextRange = self.field.textRange(from: position, to: position)
                    }
                } else {
                    self.field.text = value
                }
            }
            get {
                var result: String
                if let text: String = self.field.text {
                    if let formatter: IQStringFormatter = self.formatter {
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
        public var placeholder: IQText? {
            set(value) {
                if let text: IQText = value {
                    self.field.attributedPlaceholder = text.attributed
                } else {
                    self.field.attributedPlaceholder = nil
                }
            }
            get {
                if let attributed: NSAttributedString = self.field.attributedPlaceholder {
                    return QText(attributed)
                }
                return nil
            }
        }
        public var typingStyle: QTextStyle? {
            didSet {
                if let typingStyle: QTextStyle = self.typingStyle {
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

        public private(set) var proxy: ProxyDelegate!
        public private(set) var field: Field!

        open override var intrinsicContentSize: CGSize {
            get {
                return self.field.intrinsicContentSize
            }
        }

        open override func setup() {
            super.setup()

            self.backgroundColor = UIColor.clear

            self.proxy = ProxyDelegate(field: self)

            self.field = Field(frame: self.bounds)
            self.field.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            self.field.delegate = self.proxy
            self.addSubview(self.field)
        }

        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            return self.field.sizeThatFits(size)
        }

        open override func sizeToFit() {
            return self.field.sizeToFit()
        }

        public class ProxyDelegate: NSObject, UITextFieldDelegate {

            public weak var field: QTextField?
            public var delegate: UITextFieldDelegate? = nil {
                willSet {
                    self.canShouldBeginEditing = false
                    self.canDidBeginEditing = false
                    self.canShouldEndEditing = false
                    self.canDidEndEditing = false
                    self.canShouldChangeCharacters = false
                    self.canShouldClear = false
                    self.canShouldReturn = false
                }
                didSet {
                    if let delegate: UITextFieldDelegate = self.delegate {
                        self.canShouldBeginEditing = delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:)))
                        self.canDidBeginEditing = delegate.responds(to: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)))
                        self.canShouldEndEditing = delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)))
                        self.canDidEndEditing = delegate.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)))
                        self.canShouldChangeCharacters = delegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)))
                        self.canShouldClear = delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:)))
                        self.canShouldReturn = delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:)))
                    }
                }
            }
            private var canShouldBeginEditing: Bool = false
            private var canDidBeginEditing: Bool = false
            private var canShouldEndEditing: Bool = false
            private var canDidEndEditing: Bool = false
            private var canShouldChangeCharacters: Bool = false
            private var canShouldClear: Bool = false
            private var canShouldReturn: Bool = false

            public init(field: QTextField?) {
                self.field = field
                super.init()
            }

            public override func responds(to selector: Selector!) -> Bool {
                if super.responds(to: selector) {
                    return true
                }
                if let delegate: UITextFieldDelegate = self.delegate {
                    return delegate.responds(to: selector)
                }
                return false
            }

            public override func forwardingTarget(for selector: Selector!) -> Any? {
                if super.responds(to: selector) {
                    return self
                }
                if let delegate: UITextFieldDelegate = self.delegate {
                    if delegate.responds(to: selector) {
                        return delegate
                    }
                }
                return nil
            }

            public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                if self.canShouldBeginEditing == true {
                    if self.delegate!.textFieldShouldBeginEditing!(textField) == false {
                        return false
                    }
                }
                if let field: QTextField = self.field {
                    if let closure: ShouldClosure = field.onShouldBeginEditing {
                        return closure(field)
                    }
                }
                return true
            }

            public func textFieldDidBeginEditing(_ textField: UITextField) {
                if self.canDidBeginEditing == true {
                    self.delegate!.textFieldDidBeginEditing!(textField)
                }
                if let field: QTextField = self.field {
                    if let closure: Closure = field.onBeginEdititing {
                        return closure(field)
                    }
                }
            }

            public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                if self.canShouldEndEditing == true {
                    if self.delegate!.textFieldShouldEndEditing!(textField) == false {
                        return false
                    }
                }
                if let field: QTextField = self.field {
                    if let closure: ShouldClosure = field.onShouldEndEditing {
                        return closure(field)
                    }
                }
                return true
            }

            public func textFieldDidEndEditing(_ textField: UITextField) {
                if self.canDidEndEditing == true {
                    self.delegate!.textFieldDidEndEditing!(textField)
                }
                if let field: QTextField = self.field {
                    if let closure: Closure = field.onEndEdititing {
                        return closure(field)
                    }
                }
            }

            public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                if self.canShouldChangeCharacters == true {
                    if self.delegate!.textField!(textField, shouldChangeCharactersIn:range, replacementString: string) == false {
                        return false
                    }
                }
                guard let field: QTextField = self.field else {
                    return true
                }
                var caret: Int = range.location + string.count
                var text: String = textField.text ?? ""
                if let textRange: Range< String.Index > = text.range(from: range) {
                    text = text.replacingCharacters(in: textRange, with: string)
                }
                var unformat: String
                if let formatter: IQStringFormatter = field.formatter {
                    unformat = formatter.unformat(text, caret: &caret)
                } else {
                    unformat = text
                }
                if let validator: IQInputValidator = field.validator {
                    field.isValid = validator.validate(unformat)
                } else {
                    field.isValid = true
                }
                if field.isValid == true || field.requireValidator == false {
                    var location: UITextPosition?
                    if let formatter: IQStringFormatter = field.formatter {
                        let format: String = formatter.format(unformat, caret: &caret)
                        location = textField.position(from: textField.beginningOfDocument, offset: caret)
                        textField.text = format
                    } else {
                        location = textField.position(from: textField.beginningOfDocument, offset: caret)
                        textField.text = unformat
                    }
                    if let location: UITextPosition = location {
                        textField.selectedTextRange = textField.textRange(from: location, to: location)
                    }
                    textField.sendActions(for: .editingChanged)
                    NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                    if let closure: Closure = field.onEdititing {
                        closure(field)
                    }
                }
                return false
            }

            public func textFieldShouldClear(_ textField: UITextField) -> Bool {
                if self.canShouldClear == true {
                    if self.delegate!.textFieldShouldClear!(textField) == false {
                        return false
                    }
                }
                if let field: QTextField = self.field {
                    if let shouldClosure: ShouldClosure = field.onShouldClear, let pressedClosure: Closure = field.onPressedClear {
                        if shouldClosure(field) == true {
                            pressedClosure(field)
                        }
                    } else if let pressedClosure: Closure = field.onPressedClear {
                        pressedClosure(field)
                    }
                }
                return true
            }

            public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                if self.canShouldReturn == true {
                    if self.delegate!.textFieldShouldReturn!(textField) == false {
                        return false
                    }
                }
                if let field: QTextField = self.field {
                    if let shouldClosure: ShouldClosure = field.onShouldReturn, let pressedClosure: Closure = field.onPressedReturn {
                        if shouldClosure(field) == true {
                            pressedClosure(field)
                        }
                    } else if let pressedClosure: Closure = field.onPressedReturn {
                        pressedClosure(field)
                    }
                }
                return true
            }

        }

        public class Field: UITextField {

            public var insets: UIEdgeInsets = UIEdgeInsets.zero

            open override func textRect(forBounds bounds: CGRect) -> CGRect {
                return UIEdgeInsetsInsetRect(bounds, self.insets)
            }

            open override func editingRect(forBounds bounds: CGRect) -> CGRect {
                return UIEdgeInsetsInsetRect(bounds, self.insets)
            }

        }

    }

    extension QTextField: UITextInputTraits {

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
