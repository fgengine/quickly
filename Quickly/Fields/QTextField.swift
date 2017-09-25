//
//  Quickly
//

import UIKit

@IBDesignable
open class QTextField : QView {

    public typealias ShouldClosure = (_ textField: QTextField) -> Bool
    public typealias Closure = (_ textField: QTextField) -> Void

    @IBInspectable public weak var delegate: UITextFieldDelegate? {
        set(value) { self.textField.delegate = value }
        get { return self.textField.delegate }
    }
    public var requireValidator: Bool = true
    public var validator: IQInputValidator? {
        willSet { self.textField.delegate = nil }
        didSet {
            self.textField.delegate = self.proxy
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
                if let text: String = self.textField.text {
                    self.textField.text = formatter.unformat(text)
                }
            }
        }
        didSet {
            if let formatter: IQStringFormatter = self.formatter {
                if let text: String = self.textField.text {
                    self.textField.text = formatter.format(text)
                }
            }
        }
    }

    public var textInsets: UIEdgeInsets {
        set(value) { self.textField.insets = value }
        get { return self.textField.insets }
    }
    public var textAlignment: NSTextAlignment {
        set(value) { self.textField.textAlignment = value }
        get { return self.textField.textAlignment }
    }
    public var textStyle: QTextStyle? {
        didSet {
            var attributes: [NSAttributedStringKey: Any] = [:]
            if let textStyle: QTextStyle = self.textStyle {
                attributes = textStyle.attributes
                self.textField.font = attributes[.font] as? UIFont
                self.textField.textColor = attributes[.foregroundColor] as? UIColor
            } else {
                if let font: UIFont = self.textField.font {
                    attributes[.font] = font
                }
                if let textColor: UIColor = self.textField.textColor {
                    attributes[.foregroundColor] = textColor
                }
            }
            self.textField.defaultTextAttributes = Dictionary(uniqueKeysWithValues:
                attributes.lazy.map { ($0.key.rawValue, $0.value) }
            )
        }
    }
    public var text: String {
        set(value) { self.textField.text = value }
        get {
            if let text: String = self.textField.text {
                return text
            }
            return ""
        }
    }
    public var unformatText: String {
        set(value) {
            if let formatter: IQStringFormatter = self.formatter {
                self.textField.text = formatter.format(value)
            } else {
                self.textField.text = value
            }
        }
        get {
            if let text: String = self.textField.text {
                if let formatter: IQStringFormatter = self.formatter {
                    return formatter.unformat(text)
                } else {
                    return text
                }
            }
            return ""
        }
    }
    public var placeholder: IQText? {
        set(value) {
            if let text: IQText = value {
                self.textField.attributedPlaceholder = text.attributed
            } else {
                self.textField.attributedPlaceholder = nil
            }
        }
        get {
            if let attributed: NSAttributedString = self.textField.attributedPlaceholder {
                return QText(attributed)
            }
            return nil
        }
    }
    public var typingStyle: QTextStyle? {
        didSet {
            if let typingStyle: QTextStyle = self.typingStyle {
                self.textField.allowsEditingTextAttributes = true
                self.textField.typingAttributes = Dictionary(uniqueKeysWithValues:
                    typingStyle.attributes.lazy.map { ($0.key.rawValue, $0.value) }
                )
            } else {
                self.textField.allowsEditingTextAttributes = false
                self.textField.typingAttributes = nil
            }
        }
    }
    public var isEditing: Bool {
        get { return self.textField.isEditing }
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
    public private(set) var textField: Field!

    open override var intrinsicContentSize: CGSize {
        get {
            return self.textField.intrinsicContentSize
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

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.proxy = ProxyDelegate(field: self)

        self.textField = Field(frame: self.bounds)
        self.textField.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.textField.delegate = self.proxy
        self.addSubview(self.textField)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.textField.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.textField.sizeToFit()
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
            let origin: String = textField.text ?? ""
            var text: String = origin
            if let formatter: IQStringFormatter = field.formatter {
                text = formatter.unformat(text)
            }
            text = self.composed(origin, text, string, range)
            if let validator: IQInputValidator = field.validator {
                field.isValid = validator.validate(text)
            } else {
                field.isValid = true
            }
            if field.isValid == true || field.requireValidator == false {
                let location: UITextPosition? = textField.position(from: textField.beginningOfDocument, offset: range.location + string.characters.count)
                if let formatter: IQStringFormatter = field.formatter {
                    textField.text = formatter.format(text)
                } else {
                    textField.text = text
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
            if self.canShouldEndEditing == true {
                if self.delegate!.textFieldShouldClear!(textField) == false {
                    return false
                }
            }
            if let field: QTextField = self.field {
                if let closure: ShouldClosure = field.onShouldClear {
                    return closure(field)
                }
            }
            return true
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if self.canShouldEndEditing == true {
                if self.delegate!.textFieldShouldReturn!(textField) == false {
                    return false
                }
            }
            if let field: QTextField = self.field {
                if let closure: ShouldClosure = field.onShouldReturn {
                    return closure(field)
                }
            }
            return true
        }

        private func composed(_ origin: String, _ text: String, _ replacement: String, _ range: NSRange) -> String {
            guard var stringRange: Range< String.Index > = origin.range(from: range) else {
                return ""
            }
            let diff: Int = origin.characters.count - text.characters.count
            let lower: String.Index = origin.index(stringRange.lowerBound, offsetBy: -diff)
            let upper: String.Index = origin.index(stringRange.upperBound, offsetBy: -diff)
            return text.replacingCharacters(in: Range< String.Index >(uncheckedBounds: (lower, upper)), with: replacement)
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
        set(value) { self.textField.autocapitalizationType = value }
        get { return self.textField.autocapitalizationType }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        set(value) { self.textField.autocorrectionType = value }
        get { return self.textField.autocorrectionType }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        set(value) { self.textField.spellCheckingType = value }
        get { return self.textField.spellCheckingType }
    }

    public var keyboardType: UIKeyboardType {
        set(value) { self.textField.keyboardType = value }
        get { return self.textField.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        set(value) { self.textField.keyboardAppearance = value }
        get { return self.textField.keyboardAppearance }
    }

    public var returnKeyType: UIReturnKeyType {
        set(value) { self.textField.returnKeyType = value }
        get { return self.textField.returnKeyType }
    }

    public var enablesReturnKeyAutomatically: Bool {
        set(value) { self.textField.enablesReturnKeyAutomatically = value }
        get { return self.textField.enablesReturnKeyAutomatically }
    }

    public var isSecureTextEntry: Bool {
        set(value) { self.textField.isSecureTextEntry = value }
        get { return self.textField.isSecureTextEntry }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        set(value) { self.textField.textContentType = value }
        get { return self.textField.textContentType }
    }

}
