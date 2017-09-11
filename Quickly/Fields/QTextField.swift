//
//  Quickly
//

import UIKit

@IBDesignable
open class QTextField : QView {

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
    public var formatter: IQStringFormatter?

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
            var attributes: [String: Any] = [:]
            if let textStyle: QTextStyle = self.textStyle {
                attributes = textStyle.attributes
                self.textField.font = attributes[NSFontAttributeName] as? UIFont
                self.textField.textColor = attributes[NSForegroundColorAttributeName] as? UIColor
            } else {
                if let font: UIFont = self.textField.font {
                    attributes[NSFontAttributeName] = font
                }
                if let textColor: UIColor = self.textField.textColor {
                    attributes[NSForegroundColorAttributeName] = textColor
                }
            }
            self.textField.defaultTextAttributes = attributes
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
                self.textField.typingAttributes = typingStyle.attributes
            } else {
                self.textField.allowsEditingTextAttributes = false
                self.textField.typingAttributes = nil
            }
        }
    }
    public var isEditing: Bool {
        get { return self.textField.isEditing }
    }

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
            didSet {
                if let delegate: UITextFieldDelegate = self.delegate {
                    self.canDidEndEditing = delegate.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)))
                    self.canShouldChangeCharacters = delegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)))
                } else {
                    self.canDidEndEditing = false
                    self.canShouldChangeCharacters = false
                }
            }
        }
        private var canDidEndEditing: Bool = false
        private var canShouldChangeCharacters: Bool = false

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

        public func textFieldDidEndEditing(_ textField: UITextField) {
            if self.canDidEndEditing == true {
                self.delegate!.textFieldDidEndEditing!(textField)
            }
            if let field: QTextField = self.field {
                if let validator: IQInputValidator = field.validator {
                    field.isValid = validator.validate(field.unformatText)
                } else {
                    field.isValid = true
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
            var text: String = self.composed(textField.text, replacement: string, range: range)
            if let formatter: IQStringFormatter = field.formatter {
                text = formatter.unformat(text)
            }
            if let validator: IQInputValidator = field.validator {
                field.isValid = validator.validate(text)
            } else {
                field.isValid = true
            }
            if field.isValid == true || field.requireValidator == false {
                if let formatter: IQStringFormatter = field.formatter {
                    textField.text = formatter.format(text)
                } else {
                    textField.text = text
                }
            }
            return false
        }

        private func composed(_ string: String?, replacement: String, range: NSRange) -> String {
            guard let nsString: NSString = string as NSString? else {
                return ""
            }
            return nsString.replacingCharacters(in: range, with: replacement)
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
