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
    public var text: String? {
        set(value) { self.textField.text = value }
        get { return self.textField.text }
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

        self.textField = Field(frame: self.bounds)
        self.textField.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.textField)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.textField.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.textField.sizeToFit()
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
