//
//  Quickly
//

public protocol IQMultiTextFieldObserver : class {
    
    func beginEditing(multiTextField: QMultiTextField)
    func editing(multiTextField: QMultiTextField)
    func endEditing(multiTextField: QMultiTextField)
    func pressed(multiTextField: QMultiTextField, action: QFieldAction)
    func changed(multiTextField: QMultiTextField, height: CGFloat)
    
}

open class QMultiTextFieldStyleSheet : QDisplayStyleSheet {
    
    public var validator: IQStringValidator?
    public var form: IQFieldForm?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var placeholderInsets: UIEdgeInsets
    public var placeholder: IQText?
    public var maximumNumberOfCharecters: UInt
    public var maximumNumberOfLines: UInt
    public var minimumHeight: CGFloat
    public var maximumHeight: CGFloat
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
    public var toolbarStyle: QToolbarStyleSheet?
    public var toolbarActions: QFieldAction
    
    public init(
        validator: IQStringValidator? = nil,
        form: IQFieldForm? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        placeholderInsets: UIEdgeInsets = UIEdgeInsets.zero,
        placeholder: IQText? = nil,
        maximumNumberOfCharecters: UInt = 0,
        maximumNumberOfLines: UInt = 0,
        minimumHeight: CGFloat = 0,
        maximumHeight: CGFloat = 0,
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
        toolbarStyle: QToolbarStyleSheet? = nil,
        toolbarActions: QFieldAction = [ .done ],
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.validator = validator
        self.form = form
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
        self.maximumNumberOfCharecters = maximumNumberOfCharecters
        self.maximumNumberOfLines = maximumNumberOfLines
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
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
        self.toolbarStyle = toolbarStyle
        self.toolbarActions = toolbarActions
        
        super.init(
            backgroundColor: backgroundColor,
            tintColor: tintColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }
    
    public init(_ styleSheet: QMultiTextFieldStyleSheet) {
        self.validator = styleSheet.validator
        self.form = styleSheet.form
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.maximumNumberOfCharecters = styleSheet.maximumNumberOfCharecters
        self.maximumNumberOfLines = styleSheet.maximumNumberOfLines
        self.minimumHeight = styleSheet.minimumHeight
        self.maximumHeight = styleSheet.maximumHeight
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
        self.toolbarStyle = styleSheet.toolbarStyle
        self.toolbarActions = styleSheet.toolbarActions
        
        super.init(styleSheet)
    }
    
}


public class QMultiTextField : QDisplayView, IQField {
    
    public typealias ShouldClosure = (_ multiTextField: QMultiTextField) -> Bool
    public typealias ActionClosure = (_ multiTextField: QMultiTextField, _ action: QFieldAction) -> Void
    public typealias Closure = (_ multiTextField: QMultiTextField) -> Void
    
    public var validator: IQStringValidator? {
        willSet { self._field.delegate = nil }
        didSet {self._field.delegate = self._fieldDelegate }
    }
    public var form: IQFieldForm? {
        didSet(oldValue) {
            if self.form !== oldValue {
                if let form = oldValue {
                    form.remove(field: self)
                }
                if let form = self.form {
                    form.add(field: self)
                }
            }
        }
    }
    public var textStyle: IQTextStyle? {
        didSet {
            self._field.font = self.textStyle?.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            self._field.textColor = self.textStyle?.color ?? UIColor.black
            self._field.textAlignment = self.textStyle?.alignment ?? .left
            self.textHeight = self._textHeight()
        }
    }
    public var textInsets: UIEdgeInsets {
        set(value) {
            if self._field.textContainerInset != value {
                self._field.textContainerInset = value
                self.textHeight = self._textHeight()
            }
        }
        get { return self._field.textContainerInset }
    }
    public var text: String {
        set(value) {
            if self._field.text != value {
                self._field.text = value
                self._updatePlaceholderVisibility()
                self.textHeight = self._textHeight()
                if let form = self.form {
                    form.validation()
                }
            }
        }
        get { return self._field.text }
    }
    public var unformatText: String {
        set(value) {
            self._field.text = value
            self._updatePlaceholderVisibility()
            self.textHeight = self._textHeight()
            if let form = self.form {
                form.validation()
            }
        }
        get {
            if let text = self._field.text {
                return text
            }
            return ""
        }
    }
    public var placeholderInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet(oldValue) {
            if self.placeholderInsets != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var selectedRange: NSRange {
        set(value) { self._field.selectedRange = value }
        get { return self._field.selectedRange }
    }
    public var maximumNumberOfCharecters: UInt = 0
    public var maximumNumberOfLines: UInt = 0
    public var minimumHeight: CGFloat = 0 {
        didSet(oldValue) {
            if self.minimumHeight != oldValue {
                self.textHeight = self._textHeight()
            }
        }
    }
    public var maximumHeight: CGFloat = 0 {
        didSet(oldValue) {
            if self.maximumHeight != oldValue {
                self.textHeight = self._textHeight()
            }
        }
    }
    public private(set) var textHeight: CGFloat = 0
    public var isValid: Bool {
        get {
            guard let validator = self.validator else { return true }
            return validator.validate(self.unformatText).isValid
        }
    }
    public var placeholder: IQText? {
        set(value) {
            self._placeholderLabel.text = value
            self._updatePlaceholderVisibility()
        }
        get { return self._placeholderLabel.text }
    }
    public var isEditable: Bool {
        set(value) { self._field.isEditable = value }
        get { return self._field.isEditable }
    }
    public var isSelectable: Bool {
        set(value) { self._field.isSelectable = value }
        get { return self._field.isSelectable }
    }
    public var isEnabled: Bool {
        set(value) { self._field.isUserInteractionEnabled = value }
        get { return self._field.isUserInteractionEnabled }
    }
    public var isEditing: Bool {
        get { return self._field.isFirstResponder }
    }
    public lazy var toolbar: QToolbar = {
        let items = self._toolbarItems()
        let view = QToolbar(items: items)
        view.isHidden = items.isEmpty
        return view
    }()
    public var toolbarActions: QFieldAction = [] {
        didSet(oldValue) {
            if self.toolbarActions != oldValue {
                let items = self._toolbarItems()
                self.toolbar.items = items
                self.toolbar.isHidden = items.isEmpty
                self.reloadInputViews()
            }
        }
    }
    
    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onEditing: Closure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    public var onPressedAction: ActionClosure?
    public var onChangedHeight: Closure?

    private var _placeholderLabel: QLabel!
    private var _field: Field!
    private var _fieldDelegate: FieldDelegate!
    private var _observer: QObserver< IQMultiTextFieldObserver > = QObserver< IQMultiTextFieldObserver >()
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }
    
    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear
        
        self._fieldDelegate = FieldDelegate(field: self)
        
        self._placeholderLabel = QLabel(frame: self.bounds.inset(by: self.placeholderInsets))
        self._placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self._placeholderLabel)
        
        self._field = Field(frame: self.bounds)
        self._field.translatesAutoresizingMaskIntoConstraints = false
        self._field.textContainer.lineFragmentPadding = 0
        self._field.layoutManager.usesFontLeading = false
        self._field.inputAccessoryView = self.toolbar
        self._field.delegate = self._fieldDelegate
        self.insertSubview(self._field, aboveSubview: self._placeholderLabel)
        
        self.textHeight = self._textHeight()
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        self._constraints = [
            self._placeholderLabel.topLayout == self.topLayout.offset(self.placeholderInsets.top),
            self._placeholderLabel.leadingLayout == self.leadingLayout.offset(self.placeholderInsets.left),
            self._placeholderLabel.trailingLayout == self.trailingLayout.offset(-self.placeholderInsets.right),
            self._placeholderLabel.bottomLayout == self.bottomLayout.offset(-self.placeholderInsets.bottom),
            self._field.topLayout == self.topLayout,
            self._field.leadingLayout == self.leadingLayout,
            self._field.trailingLayout == self.trailingLayout,
            self._field.bottomLayout == self.bottomLayout
        ]
    }
    
    public func add(observer: IQMultiTextFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQMultiTextFieldObserver) {
        self._observer.remove(observer)
    }
    
    open func beginEditing() {
        self._field.becomeFirstResponder()
    }
    
    public func apply(_ styleSheet: QMultiTextFieldStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.validator = styleSheet.validator
        self.form = styleSheet.form
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.maximumNumberOfCharecters = styleSheet.maximumNumberOfCharecters
        self.maximumNumberOfLines = styleSheet.maximumNumberOfLines
        self.minimumHeight = styleSheet.minimumHeight
        self.maximumHeight = styleSheet.maximumHeight
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
        if let style = styleSheet.toolbarStyle {
            self.toolbar.apply(style)
        }
        self.toolbarActions = styleSheet.toolbarActions
    }
    
}

// MARK: Private

private extension QMultiTextField {
    
    func _updatePlaceholderVisibility() {
        self._placeholderLabel.isHidden = self._field.text.count > 0
    }
    
    func _textHeight() -> CGFloat {
        let textContainerInset = self._field.textContainerInset
        let textRect = self._field.layoutManager.usedRect(for: self._field.textContainer)
        var height = textContainerInset.top + textRect.height + textContainerInset.bottom
        if self.minimumHeight > CGFloat.leastNonzeroMagnitude {
            height = max(height, self.minimumHeight)
        }
        if self.maximumHeight > CGFloat.leastNonzeroMagnitude {
            height = min(height, self.maximumHeight)
        }
        return height
    }
    
    private func _toolbarItems() -> [UIBarButtonItem] {
        var items: [UIBarButtonItem] = []
        if self.toolbarActions.isEmpty == false {
            if self.toolbarActions.contains(.cancel) == true {
                items.append(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self._pressedCancel(_:))))
            }
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
            if self.toolbarActions.contains(.done) == true {
                items.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self._pressedDone(_:))))
            }
        }
        return items
    }
    
    @objc
    func _pressedCancel(_ sender: Any) {
        self._pressed(action: .cancel)
        self.endEditing(false)
    }
    
    @objc
    func _pressedDone(_ sender: Any) {
        self._pressed(action: .done)
        self.endEditing(false)
    }
    
    func _pressed(action: QFieldAction) {
        if let closure = self.onPressedAction {
            closure(self, action)
        }
        self._observer.notify({ (observer) in
            observer.pressed(multiTextField: self, action: action)
        })
    }
    
}

// MARK: Private • Field

private extension QMultiTextField {

    class Field : UITextView, IQView {
        
        public override var inputAccessoryView: UIView? {
            set(value) { super.inputAccessoryView = value }
            get {
                guard let view = super.inputAccessoryView else { return nil }
                return view.isHidden == true ? nil : view
            }
        }
        
        required init() {
            super.init(
                frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40),
                textContainer: nil
            )
            self.setup()
        }
        
        public override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(
                frame: frame,
                textContainer: nil
            )
            self.setup()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }
        
        open func setup() {
            self.backgroundColor = UIColor.clear
        }

    }
    
}

// MARK: Private • FieldDelegate

private extension QMultiTextField {
    
    class FieldDelegate : NSObject, UITextViewDelegate {
        
        public weak var field: QMultiTextField?
        
        public init(field: QMultiTextField?) {
            self.field = field
            super.init()
        }
        
        public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            guard let field = self.field, let closure = field.onShouldBeginEditing else { return true }
            return closure(field)
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            guard let field = self.field else { return }
            if let closure = field.onBeginEditing {
                closure(field)
            }
            field._observer.notify({ (observer) in
                observer.beginEditing(multiTextField: field)
            })
        }
        
        public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            guard let field = self.field, let closure = field.onShouldEndEditing else { return true }
            return closure(field)
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            guard let field = self.field else { return }
            if let closure = field.onEndEditing {
                closure(field)
            }
            field._observer.notify({ (observer) in
                observer.endEditing(multiTextField: field)
            })
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let field = self.field else { return true }
            var sourceText = textView.text ?? ""
            if let sourceTextRange = sourceText.range(from: range) {
                sourceText = sourceText.replacingCharacters(in: sourceTextRange, with: text)
            }
            var isValid: Bool = true
            if let font = textView.font, field.maximumNumberOfCharecters > 0 || field.maximumNumberOfLines > 0 {
                if field.maximumNumberOfCharecters > 0 {
                    if sourceText.count > field.maximumNumberOfCharecters {
                        isValid = false
                    }
                }
                if field.maximumNumberOfLines > 0 {
                    let allowWidth = textView.frame.inset(by: textView.textContainerInset).width - (2.0 * textView.textContainer.lineFragmentPadding)
                    let textSize = textView.textStorage.boundingRect(
                        with: CGSize(width: allowWidth, height: CGFloat.greatestFiniteMagnitude),
                        options: [ .usesLineFragmentOrigin ],
                        context: nil
                    )
                    if UInt(textSize.height / font.lineHeight) > field.maximumNumberOfLines {
                        isValid = false
                    }
                }
            }
            return isValid
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            guard let field = self.field else { return }
            field._updatePlaceholderVisibility()
            let height = field._textHeight()
            if abs(field.textHeight - height) > CGFloat.leastNonzeroMagnitude {
                field.textHeight = height
                UIView.animate(withDuration: 0.1, animations: {
                    if let onChangedHeight = field.onChangedHeight {
                        onChangedHeight(field)
                    }
                    field._observer.notify({ (observer) in
                        observer.changed(multiTextField: field, height: height)
                    })
                    textView.scrollRangeToVisible(textView.selectedRange)
                }, completion: { _ in
                    textView.scrollRangeToVisible(textView.selectedRange)
                })
            }
            if let closure = field.onEditing {
                closure(field)
            }
            field._observer.notify({ (observer) in
                observer.editing(multiTextField: field)
            })
            if let form = field.form {
                form.validation()
            }
        }
        
    }
    
}

// MARK: UITextInputTraits

extension QMultiTextField : UITextInputTraits {

    public var autocapitalizationType: UITextAutocapitalizationType {
        set(value) { self._field.autocapitalizationType = value }
        get { return self._field.autocapitalizationType }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        set(value) { self._field.autocorrectionType = value }
        get { return self._field.autocorrectionType }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        set(value) { self._field.spellCheckingType = value }
        get { return self._field.spellCheckingType }
    }

    public var keyboardType: UIKeyboardType {
        set(value) { self._field.keyboardType = value }
        get { return self._field.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        set(value) { self._field.keyboardAppearance = value }
        get { return self._field.keyboardAppearance }
    }

    public var returnKeyType: UIReturnKeyType {
        set(value) { self._field.returnKeyType = value }
        get { return self._field.returnKeyType }
    }

    public var enablesReturnKeyAutomatically: Bool {
        set(value) { self._field.enablesReturnKeyAutomatically = value }
        get { return self._field.enablesReturnKeyAutomatically }
    }

    public var isSecureTextEntry: Bool {
        set(value) { self._field.isSecureTextEntry = value }
        get { return self._field.isSecureTextEntry }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        set(value) { self._field.textContentType = value }
        get { return self._field.textContentType }
    }

}
