//
//  Quickly
//

public protocol IQTextFieldSuggestion : class {
    
    func autoComplete(_ text: String) -> String?
    func variants(_ text: String) -> [String]
    
}

public protocol IQTextFieldSuggestionController : IQCollectionController {
    
    typealias SelectSuggestionClosure = (_ controller: IQTextFieldSuggestionController, _ suggestion: String) -> Void
    
    var onSelectSuggestion: SelectSuggestionClosure? { set get }
    
    func set(variants: [String])
    
}

public protocol IQTextFieldObserver : class {
    
    func beginEditing(textField: QTextField)
    func editing(textField: QTextField)
    func endEditing(textField: QTextField)
    func pressed(textField: QTextField, action: QFieldAction)
    func pressedClear(textField: QTextField)
    func pressedReturn(textField: QTextField)
    func select(textField: QTextField, suggestion: String)
    
}

open class QTextFieldStyleSheet : QDisplayStyleSheet {
    
    public var requireValidator: Bool
    public var validator: IQStringValidator?
    public var form: IQFieldForm?
    public var formatter: IQStringFormatter?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var editingInsets: UIEdgeInsets?
    public var placeholderInsets: UIEdgeInsets?
    public var placeholder: IQText?
    public var clearButtonMode: UITextField.ViewMode
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
    public var toolbarStyle: QToolbarStyleSheet?
    public var toolbarActions: QFieldAction
    public var suggestion: IQTextFieldSuggestion?
    public var suggestionStyle: QCollectionStyleSheet?
    public var suggestionController: IQTextFieldSuggestionController?
    
    public init(
        requireValidator: Bool = false,
        validator: IQStringValidator? = nil,
        form: IQFieldForm? = nil,
        formatter: IQStringFormatter? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        editingInsets: UIEdgeInsets? = nil,
        placeholderInsets: UIEdgeInsets? = nil,
        placeholder: IQText? = nil,
        clearButtonMode: UITextField.ViewMode = .never,
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
        toolbarStyle: QToolbarStyleSheet? = nil,
        toolbarActions: QFieldAction = [],
        suggestion: IQTextFieldSuggestion? = nil,
        suggestionStyle: QCollectionStyleSheet? = nil,
        suggestionController: IQTextFieldSuggestionController? = nil,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.requireValidator = requireValidator
        self.validator = validator
        self.form = form
        self.formatter = formatter
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.editingInsets = editingInsets
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
        self.clearButtonMode = clearButtonMode
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
        self.suggestion = suggestion
        self.suggestionStyle = suggestionStyle
        self.suggestionController = suggestionController
        
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
        self.form = styleSheet.form
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.editingInsets = styleSheet.editingInsets
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.clearButtonMode = styleSheet.clearButtonMode
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
        self.suggestion = styleSheet.suggestion
        self.suggestionStyle = styleSheet.suggestionStyle
        self.suggestionController = styleSheet.suggestionController
        
        super.init(styleSheet)
    }
    
}

public class QTextField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ textField: QTextField) -> Bool
    public typealias Closure = (_ textField: QTextField) -> Void
    public typealias ActionClosure = (_ textField: QTextField, _ action: QFieldAction) -> Void
    public typealias SelectSuggestionClosure = (_ textField: QTextField, _ suggestion: String) -> Void

    public var requireValidator: Bool = false
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
    public var formatter: IQStringFormatter? {
        willSet {
            if let formatter = self.formatter {
                if let text = self._field.text {
                    var caret: Int
                    if let selected = self._field.selectedTextRange {
                        caret = self._field.offset(from: self._field.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self._field.text = formatter.unformat(text, caret: &caret)
                    if let position = self._field.position(from: self._field.beginningOfDocument, offset: caret) {
                        self._field.selectedTextRange = self._field.textRange(from: position, to: position)
                    }
                }
            }
        }
        didSet {
            if let formatter = self.formatter {
                if let text = self._field.text {
                    var caret: Int
                    if let selected = self._field.selectedTextRange {
                        caret = self._field.offset(from: self._field.beginningOfDocument, to: selected.end)
                    } else {
                        caret = text.count
                    }
                    self._field.text = formatter.format(text, caret: &caret)
                    if let position = self._field.position(from: self._field.beginningOfDocument, offset: caret) {
                        self._field.selectedTextRange = self._field.textRange(from: position, to: position)
                    }
                }
            }
            if let form = self.form {
                form.validation()
            }
        }
    }
    public var textInsets: UIEdgeInsets {
        set(value) { self._field.textInsets = value }
        get { return self._field.textInsets }
    }
    public var textStyle: IQTextStyle? {
        didSet {
            var attributes: [NSAttributedString.Key: Any] = [:]
            if let textStyle = self.textStyle {
                attributes = textStyle.attributes
                self._field.font = attributes[.font] as? UIFont
                self._field.textColor = attributes[.foregroundColor] as? UIColor
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    self._field.textAlignment = paragraphStyle.alignment
                } else {
                    self._field.textAlignment = .left
                }
            } else {
                if let font = self._field.font {
                    attributes[.font] = font
                }
                if let textColor = self._field.textColor {
                    attributes[.foregroundColor] = textColor
                }
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = self._field.textAlignment
                attributes[.paragraphStyle] = paragraphStyle
            }
            self._field.defaultTextAttributes = Dictionary(uniqueKeysWithValues:
                attributes.lazy.map { (NSAttributedString.Key(rawValue: $0.key.rawValue), $0.value) }
            )
        }
    }
    public var text: String {
        set(value) {
            self._field.text = value
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
    public var unformatText: String {
        set(value) {
            if let formatter = self.formatter {
                var caret: Int
                if let selected = self._field.selectedTextRange {
                    caret = self._field.offset(from: self._field.beginningOfDocument, to: selected.end)
                } else {
                    caret = text.count
                }
                self._field.text = formatter.format(value, caret: &caret)
                if let position = self._field.position(from: self._field.beginningOfDocument, offset: caret) {
                    self._field.selectedTextRange = self._field.textRange(from: position, to: position)
                }
            } else {
                self._field.text = value
            }
            if let form = self.form {
                form.validation()
            }
        }
        get {
            var result: String
            if let text = self._field.text {
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
    public var editingInsets: UIEdgeInsets? {
        set(value) { self._field.editingInsets = value }
        get { return self._field.editingInsets }
    }
    public var placeholderInsets: UIEdgeInsets? {
        set(value) { self._field.placeholderInsets = value }
        get { return self._field.placeholderInsets }
    }
    public var typingStyle: IQTextStyle? {
        didSet {
            if let typingStyle = self.typingStyle {
                self._field.allowsEditingTextAttributes = true
                self._field.typingAttributes = Dictionary(uniqueKeysWithValues:
                    typingStyle.attributes.lazy.map { (NSAttributedString.Key(rawValue: $0.key.rawValue), $0.value) }
                )
            } else {
                self._field.allowsEditingTextAttributes = false
                self._field.typingAttributes = nil
            }
        }
    }
    public var isValid: Bool {
        get {
            guard let validator = self.validator else { return true }
            return validator.validate(self.unformatText).isValid
        }
    }
    public var placeholder: IQText? {
        set(value) {
            if let text = value {
                if let attributed = text.attributed {
                    self._field.attributedPlaceholder = attributed
                } else if let font = text.font, let color = text.color {
                    self._field.attributedPlaceholder = NSAttributedString(string: text.string, attributes: [
                        .font: font,
                        .foregroundColor: color
                    ])
                } else {
                    self._field.attributedPlaceholder = nil
                }
            } else {
                self._field.attributedPlaceholder = nil
            }
        }
        get {
            if let attributed = self._field.attributedPlaceholder {
                return QAttributedText(attributed: attributed)
            }
            return nil
        }
    }
    public var clearButtonMode: UITextField.ViewMode {
        set(value) { self._field.clearButtonMode = value }
        get { return self._field.clearButtonMode }
    }
    public var isEnabled: Bool {
        set(value) { self._field.isEnabled = value }
        get { return self._field.isEnabled }
    }
    public var isEditing: Bool {
        get { return self._field.isEditing }
    }
    public lazy var toolbar: QToolbar = QToolbar(items: self._toolbarItems())
    public var toolbarActions: QFieldAction = [] {
        didSet(oldValue) {
            if self.toolbarActions != oldValue {
                let items = self._toolbarItems()
                self.toolbar.items = items
                self.toolbar.isHidden = self.toolbarActions.isEmpty
                self._updateAccessoryView()
            }
        }
    }
    public var suggestion: IQTextFieldSuggestion? {
        didSet(oldValue) {
            if self.suggestion !== oldValue {
                self._updateAccessoryView()
            }
        }
    }
    public lazy var suggestionView: QCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = QCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50), collectionViewLayout: layout)
        return view
    }()
    public var suggestionController: IQTextFieldSuggestionController? {
        didSet {
            if let controller = self.suggestionController {
                controller.onSelectSuggestion = { [weak self] in self?._select(controller: $0, suggestion: $1) }
            }
            self.suggestionView.collectionController = self.suggestionController
        }
    }
    
    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onEditing: Closure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    public var onPressedAction: ActionClosure?
    public var onShouldClear: ShouldClosure?
    public var onPressedClear: Closure?
    public var onShouldReturn: ShouldClosure?
    public var onPressedReturn: Closure?
    public var onSelectSuggestion: SelectSuggestionClosure?
    
    open override var intrinsicContentSize: CGSize {
        get { return self._field.intrinsicContentSize }
    }

    private var _field: Field!
    private var _fieldDelegate: FieldDelegate!
    private var _observer: QObserver< IQTextFieldObserver > = QObserver< IQTextFieldObserver >()
    private lazy var _accessoryView: AccessoryView = AccessoryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    
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

        self._field = Field(frame: self.bounds)
        self._field.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self._field.inputAccessoryView = self._accessoryView
        self._field.delegate = self._fieldDelegate
        self.addSubview(self._field)
    }
    
    public func add(observer: IQTextFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQTextFieldObserver) {
        self._observer.remove(observer)
    }

    open func beginEditing() {
        self._field.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self._field.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self._field.sizeToFit()
    }
    
    public func apply(_ styleSheet: QTextFieldStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.requireValidator = styleSheet.requireValidator
        self.validator = styleSheet.validator
        self.form = styleSheet.form
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.editingInsets = styleSheet.editingInsets
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.clearButtonMode = styleSheet.clearButtonMode
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
        if let style = styleSheet.toolbarStyle {
            self.toolbar.apply(style)
        }
        self.toolbarActions = styleSheet.toolbarActions
        if let style = styleSheet.suggestionStyle {
            self.suggestionView.apply(style)
        }
        self.suggestionController = styleSheet.suggestionController
        self.suggestion = styleSheet.suggestion
    }
    
}

// MARK: Private

private extension QTextField {
    
    func _toolbarItems() -> [UIBarButtonItem] {
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
    
    func _updateAccessoryView() {
        var height: CGFloat = 0
        if self.toolbarActions.isEmpty == false {
            self._accessoryView.addSubview(self.toolbar)
            height += self.toolbar.frame.height
        }
        if self.suggestion != nil {
            self._accessoryView.addSubview(self.suggestionView)
            height += self.suggestionView.frame.height
        }
        let origin = self._accessoryView.frame.origin
        let size = self._accessoryView.frame.size
        if size.height != height {
            self._accessoryView.frame = CGRect(
                origin: origin,
                size: CGSize(
                    width: size.width,
                    height: height
                )
            )
            self._field.reloadInputViews()
        }
    }
    
    func _select(controller: IQTextFieldSuggestionController, suggestion: String) {
        self.suggestionController?.set(variants: [])
        self._field.text = suggestion
        self._field.sendActions(for: .editingChanged)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self._field)
        if let closure = self.onEditing {
            closure(self)
        }
        self._observer.notify({ (observer) in
            observer.editing(textField: self)
        })
        if let form = self.form {
            form.validation()
        }
        if let closure = self.onSelectSuggestion {
            closure(self, suggestion)
        }
        self._observer.notify({ (observer) in
            observer.select(textField: self, suggestion: suggestion)
        })
        self.endEditing(false)
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
            observer.pressed(textField: self, action: action)
        })
    }
    
}

// MARK: Private • AccessoryView

private extension QTextField {
    
    class AccessoryView : UIView {
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let bounds = self.bounds
            var offset: CGFloat = 0
            for subview in self.subviews {
                let height = subview.frame.height
                subview.frame = CGRect(x: bounds.origin.x, y: offset, width: bounds.size.width, height: height)
                offset += height
            }
        }
        
    }

}

// MARK: Private • Field

private extension QTextField {

    class Field : UITextField, IQView {

        public var textInsets: UIEdgeInsets = UIEdgeInsets.zero
        public var editingInsets: UIEdgeInsets?
        public var placeholderInsets: UIEdgeInsets?
        public override var inputAccessoryView: UIView? {
            set(value) { super.inputAccessoryView = value }
            get {
                guard let view = super.inputAccessoryView else { return nil }
                return view.isHidden == true ? nil : view
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
            return bounds.inset(by: self.textInsets)
        }

        open override func editingRect(forBounds bounds: CGRect) -> CGRect {
            guard let insets = self.editingInsets else {
                return bounds.inset(by: self.textInsets)
            }
            return bounds.inset(by: insets)
        }

        open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            guard let insets = self.placeholderInsets else {
                return bounds.inset(by: self.textInsets)
            }
            return bounds.inset(by: insets)
        }

    }
    
}

// MARK: Private • FieldDelegate

private extension QTextField {

    class FieldDelegate : NSObject, UITextFieldDelegate {

        public weak var field: QTextField?
        private var _shouldReplacementString: Bool

        public init(field: QTextField?) {
            self.field = field
            self._shouldReplacementString = false
            super.init()
        }

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            guard let field = self.field, let closure = field.onShouldBeginEditing else { return true }
            return closure(field)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            guard let field = self.field else { return }
            if let suggestion = field.suggestion {
                field.suggestionController?.set(variants: suggestion.variants(field.unformatText))
            }
            if let closure = field.onBeginEditing {
                closure(field)
            }
            field._observer.notify({ (observer) in
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
            field._observer.notify({ (observer) in
                observer.endEditing(textField: field)
            })
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let field = self.field else { return true }
            if self._shouldReplacementString == false {
                self._shouldReplacementString = true
                var caretPosition: Int = range.location + string.count
                var caretLength: Int = 0
                var sourceText = textField.text ?? ""
                if let sourceTextRange = sourceText.range(from: range) {
                    sourceText = sourceText.replacingCharacters(in: sourceTextRange, with: string)
                }
                var sourceUnformat: String
                if let formatter = field.formatter {
                    sourceUnformat = formatter.unformat(sourceText, caret: &caretPosition)
                } else {
                    sourceUnformat = sourceText
                }
                var autoCompleteVariants: [String] = []
                if let suggestion = field.suggestion {
                    if sourceUnformat.count > 0 {
                        autoCompleteVariants = suggestion.variants(sourceUnformat)
                    }
                    if sourceUnformat.isEmpty == false && sourceUnformat.count <= caretPosition && string.count > 0 {
                        if let autoComplete = suggestion.autoComplete(sourceUnformat) {
                            caretLength = autoComplete.count - sourceUnformat.count
                            sourceUnformat = autoComplete
                        }
                    }
                }
                var isValid: Bool
                if let validator = field.validator {
                    isValid = validator.validate(sourceUnformat).isValid
                } else {
                    isValid = true
                }
                if field.requireValidator == false || string.isEmpty == true || isValid == true {
                    var selectionFrom: UITextPosition?
                    var selectionTo: UITextPosition?
                    if let formatter = field.formatter {
                        let format = formatter.format(sourceUnformat, caret: &caretPosition)
                        textField.text = format
                        selectionFrom = textField.position(from: textField.beginningOfDocument, offset: caretPosition)
                        selectionTo = textField.position(from: textField.beginningOfDocument, offset: caretPosition + caretLength)
                    } else {
                        textField.text = sourceUnformat
                        selectionFrom = textField.position(from: textField.beginningOfDocument, offset: caretPosition)
                        selectionTo = textField.position(from: textField.beginningOfDocument, offset: caretPosition + caretLength)
                    }
                    if let selectionFrom = selectionFrom, let selectionTo = selectionTo {
                        textField.selectedTextRange = textField.textRange(from: selectionFrom, to: selectionTo)
                    }
                    field.suggestionController?.set(variants: autoCompleteVariants)
                    textField.sendActions(for: .editingChanged)
                    NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
                    if let closure = field.onEditing {
                        closure(field)
                    }
                    field._observer.notify({ (observer) in
                        observer.editing(textField: field)
                    })
                    if let form = field.form {
                        form.validation()
                    }
                }
                self._shouldReplacementString = false
            }
            return false
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            guard let field = self.field else { return true }
            field.text = ""
            if let shouldClosure = field.onShouldClear {
                if shouldClosure(field) == true {
                    if let pressedClosure = field.onPressedClear {
                        pressedClosure(field)
                    }
                    field._observer.notify({ (observer) in
                        observer.pressedClear(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedClear {
                    pressedClosure(field)
                }
                field._observer.notify({ (observer) in
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
                    field._observer.notify({ (observer) in
                        observer.pressedReturn(textField: field)
                    })
                }
            } else {
                if let pressedClosure = field.onPressedReturn {
                    pressedClosure(field)
                }
                field._observer.notify({ (observer) in
                    observer.pressedReturn(textField: field)
                })
            }
            return true
        }

    }
    
}

// MARK: UITextInputTraits

extension QTextField : UITextInputTraits {

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
