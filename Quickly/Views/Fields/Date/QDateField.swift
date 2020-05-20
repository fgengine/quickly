//
//  Quickly
//

public enum QDateFieldMode {
    case date
    case time
    case dateAndTime

    public var datePickerMode: UIDatePicker.Mode {
        get {
            switch self {
            case .date: return UIDatePicker.Mode.date
            case .time: return UIDatePicker.Mode.time
            case .dateAndTime: return UIDatePicker.Mode.dateAndTime
            }
        }
    }
}

public protocol IQDateFieldObserver : class {
    
    func beginEditing(dateField: QDateField)
    func select(dateField: QDateField, date: Date)
    func endEditing(dateField: QDateField)
    func pressedCancel(dateField: QDateField)
    func pressedDone(dateField: QDateField)
    
}

public class QDateField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ dateField: QDateField) -> Bool
    public typealias SelectClosure = (_ dateField: QDateField, _ date: Date) -> Void
    public typealias Closure = (_ dateField: QDateField) -> Void

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
    public var formatter: IQDateFieldFormatter? {
        didSet { self._updateText() }
    }
    public var mode: QDateFieldMode = .date {
        didSet { self._picker.datePickerMode = self.mode.datePickerMode }
    }
    public var calendar: Calendar? {
        set(value) { self._picker.calendar = value }
        get { return self._picker.calendar }
    }
    public var locale: Locale? {
        set(value) { self._picker.locale = value }
        get { return self._picker.locale }
    }
    public var date: Date? {
        didSet {
            if var date = self.date {
                self._processDate(&date)
                self._picker.setDate(date, animated: self.isFirstResponder)
            }
            self._updateText()
        }
    }
    public var minimumDate: Date? {
        set(value) {
            self._picker.minimumDate = value
            if var date = self.date {
                if self._processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self._picker.minimumDate }
    }
    public var maximumDate: Date? {
        set(value) {
            self._picker.maximumDate = value
            if var date = self.date {
                if self._processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self._picker.maximumDate }
    }
    public var isValid: Bool {
        get { return self.date != nil }
    }
    public var placeholder: IQText? {
        didSet { self._updateText() }
    }
    public var isEnabled: Bool = true
    public var isEditing: Bool {
        get { return self.isFirstResponder }
    }
    public lazy var toolbar: QToolbar = QToolbar(items: self._toolbarItems())
    public var toolbarActions: QFieldAction = [] {
        didSet(oldValue) {
            if self.toolbarActions != oldValue {
                let items = self._toolbarItems()
                self.toolbar.items = items
                self.toolbar.isHidden = items.isEmpty
            }
        }
    }
    
    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onSelect: SelectClosure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    public var onPressedCancel: Closure?
    public var onPressedDone: Closure?
    
    open override var canBecomeFirstResponder: Bool {
        get {
            guard self.isEnabled == true else { return false }
            guard let closure = self.onShouldBeginEditing else { return true }
            return closure(self)
        }
    }
    open override var canResignFirstResponder: Bool {
        get {
            guard let closure = self.onShouldEndEditing else { return true }
            return closure(self)
        }
    }
    open override var inputView: UIView? {
        get { return self._picker }
    }
    open override var inputAccessoryView: UIView? {
        get { return self.toolbar }
    }
    open override var intrinsicContentSize: CGSize {
        get { return self._label.intrinsicContentSize }
    }

    private var _label: QLabel!
    private var _picker: UIDatePicker!
    private var _tapGesture: UITapGestureRecognizer!
    private var _observer: QObserver< IQDateFieldObserver >
    
    public required init() {
        self._observer = QObserver< IQDateFieldObserver >()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        self._observer = QObserver< IQDateFieldObserver >()
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self._observer = QObserver< IQDateFieldObserver >()
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self._label = QLabel(frame: self.bounds)
        self._label.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self._label)

        self._picker = UIDatePicker()
        self._picker.datePickerMode = self.mode.datePickerMode
        self._picker.addValueChanged(self, action: #selector(self._changeDate(_:)))
        
        self._tapGesture = UITapGestureRecognizer(target: self, action: #selector(self._tapGesture(_:)))
        self.addGestureRecognizer(self._tapGesture)
    }
    
    public func add(observer: IQDateFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQDateFieldObserver) {
        self._observer.remove(observer)
    }

    open func beginEditing() {
        self.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self._label.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self._label.sizeToFit()
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() == true else { return false }
        var changeSelection: Bool
        if self.date == nil {
            self.date = self._picker.date
            changeSelection = true
        } else {
            changeSelection = false
        }
        self.onBeginEditing?(self)
        self._observer.notify({ (observer) in
            observer.beginEditing(dateField: self)
        })
        if changeSelection == true {
            if let closure = self.onSelect {
                closure(self, self.date!)
            }
            self._observer.notify({ (observer) in
                observer.select(dateField: self, date: self.date!)
            })
            if let form = self.form {
                form.validation()
            }
        }
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        self._observer.notify({ (observer) in
            observer.endEditing(dateField: self)
        })
        return true
    }
    
    public func apply(_ styleSheet: QDateFieldStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.form = styleSheet.form
        self.formatter = styleSheet.formatter
        self.mode = styleSheet.mode
        self.calendar = styleSheet.calendar
        self.locale = styleSheet.locale
        self.minimumDate = styleSheet.minimumDate
        self.maximumDate = styleSheet.maximumDate
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled
        if let style = styleSheet.toolbarStyle {
            self.toolbar.apply(style)
        }
        self.toolbarActions = styleSheet.toolbarActions
    }
    
}

extension QDateField {

    private func _updateText() {
        guard let date = self.date, let formatter = self.formatter else {
            self._label.text = self.placeholder
            self.invalidateIntrinsicContentSize()
            return
        }
        self._label.text = formatter.from(date)
        self.invalidateIntrinsicContentSize()
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

    @discardableResult
    private func _processDate(_ newDate: inout Date) -> Bool {
        guard
            let date = self.date,
            let minimumDate = self.minimumDate,
            let maximumDate = self.maximumDate
            else { return false }
        if date < minimumDate {
            newDate = date
            return true
        } else if date > maximumDate {
            newDate = date
            return true
        }
        return false
    }

    @objc
    private func _changeDate(_ sender: Any) {
        self.date = self._picker.date
        self._updateText()
        if let closure = self.onSelect {
            closure(self, self._picker.date)
        }
        self._observer.notify({ (observer) in
            observer.select(dateField: self, date: self._picker.date)
        })
        if let form = self.form {
            form.validation()
        }
    }
    
    @objc
    private func _tapGesture(_ sender: Any) {
        if self.canBecomeFirstResponder == true {
            self.becomeFirstResponder()
        }
    }
    
    @objc
    private func _pressedCancel(_ sender: Any) {
        if let closure = self.onPressedCancel {
            closure(self)
        }
        self._observer.notify({ (observer) in
            observer.pressedCancel(dateField: self)
        })
        self.endEditing(false)
    }
    
    @objc
    private func _pressedDone(_ sender: Any) {
        if let closure = self.onPressedDone {
            closure(self)
        }
        self._observer.notify({ (observer) in
            observer.pressedDone(dateField: self)
        })
        self.endEditing(false)
    }

}
