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

open class QDateFieldStyleSheet : QDisplayViewStyleSheet< QDateField > {

    public var formatter: IQDateFieldFormatter
    public var mode: QDateFieldMode
    public var calendar: Calendar?
    public var locale: Locale?
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var placeholder: IQText?
    public var isEnabled: Bool

    public init(
        formatter: IQDateFieldFormatter,
        mode: QDateFieldMode = .date,
        calendar: Calendar? = nil,
        locale: Locale? = nil,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        placeholder: IQText? = nil,
        isEnabled: Bool = true,
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.formatter = formatter
        self.mode = mode
        self.calendar = calendar
        self.locale = locale
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.placeholder = placeholder
        self.isEnabled = isEnabled
        
        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }

    public init(_ styleSheet: QDateFieldStyleSheet) {
        self.formatter = styleSheet.formatter
        self.mode = styleSheet.mode
        self.calendar = styleSheet.calendar
        self.locale = styleSheet.locale
        self.minimumDate = styleSheet.minimumDate
        self.maximumDate = styleSheet.maximumDate
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled

        super.init(styleSheet)
    }

    public override func apply(_ target: QDateField) {
        super.apply(target)

        target.formatter = self.formatter
        target.mode = self.mode
        target.calendar = self.calendar
        target.locale = self.locale
        target.minimumDate = self.minimumDate
        target.maximumDate = self.maximumDate
        target.placeholder = self.placeholder
        target.isEnabled = self.isEnabled
    }

}

public protocol IQDateFieldObserver : class {
    
    func beginEditing(dateField: QDateField)
    func select(dateField: QDateField, date: Date)
    func endEditing(dateField: QDateField)
    
}

public class QDateField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ dateField: QDateField) -> Bool
    public typealias SelectClosure = (_ dateField: QDateField, _ date: Date) -> Void
    public typealias Closure = (_ dateField: QDateField) -> Void

    public var formatter: IQDateFieldFormatter? {
        didSet { self.updateText() }
    }
    public var mode: QDateFieldMode = .date {
        didSet { self.pickerView.datePickerMode = self.mode.datePickerMode }
    }
    public var calendar: Calendar? {
        set(value) { self.pickerView.calendar = value }
        get { return self.pickerView.calendar }
    }
    public var locale: Locale? {
        set(value) { self.pickerView.locale = value }
        get { return self.pickerView.locale }
    }
    public var date: Date? {
        didSet {
            if var date = self.date {
                self.processDate(&date)
                self.pickerView.setDate(date, animated: self.isFirstResponder)
            }
            self.updateText()
        }
    }
    public var minimumDate: Date? {
        set(value) {
            self.pickerView.minimumDate = value
            if var date = self.date {
                if self.processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self.pickerView.minimumDate }
    }
    public var maximumDate: Date? {
        set(value) {
            self.pickerView.maximumDate = value
            if var date = self.date {
                if self.processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self.pickerView.maximumDate }
    }
    public var isValid: Bool {
        get { return self.date != nil }
    }
    public var placeholder: IQText? {
        didSet { self.updateText() }
    }
    public var isEnabled: Bool = true
    public var isEditing: Bool {
        get { return self.isFirstResponder }
    }
    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onSelect: SelectClosure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?
    
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
        get { return self.pickerView }
    }
    open override var intrinsicContentSize: CGSize {
        get { return self.valueLabel.intrinsicContentSize }
    }

    internal private(set) var valueLabel: QLabel!
    internal private(set) var pickerView: UIDatePicker!
    internal private(set) var tapGesture: UITapGestureRecognizer!
    
    private var observer: QObserver< IQDateFieldObserver >
    
    public required init() {
        self.observer = QObserver< IQDateFieldObserver >()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        self.observer = QObserver< IQDateFieldObserver >()
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self.observer = QObserver< IQDateFieldObserver >()
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.valueLabel = QLabel(frame: self.bounds)
        self.valueLabel.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.valueLabel)

        self.pickerView = UIDatePicker()
        self.pickerView.datePickerMode = self.mode.datePickerMode
        self.pickerView.addValueChanged(self, action: #selector(self.changeDate(_:)))
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        self.addGestureRecognizer(self.tapGesture)
    }
    
    public func addObserver(_ observer: IQDateFieldObserver, priority: UInt) {
        self.observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQDateFieldObserver) {
        self.observer.remove(observer)
    }

    open func beginEditing() {
        self.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.valueLabel.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.valueLabel.sizeToFit()
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() == true else { return false }
        if self.date == nil {
            self.date = self.pickerView.date
        }
        self.onBeginEditing?(self)
        self.observer.reverseNotify({ (observer) in
            observer.beginEditing(dateField: self)
        })
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        self.observer.reverseNotify({ (observer) in
            observer.endEditing(dateField: self)
        })
        return true
    }

    private func updateText() {
        guard let date = self.date, let formatter = self.formatter else {
            self.valueLabel.text = self.placeholder
            self.invalidateIntrinsicContentSize()
            return
        }
        self.valueLabel.text = formatter.from(date)
        self.invalidateIntrinsicContentSize()
    }

    @discardableResult
    private func processDate(_ newDate: inout Date) -> Bool {
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
    private func changeDate(_ sender: Any) {
        self.date = self.pickerView.date
        self.updateText()
        if let closure = self.onSelect {
            closure(self, self.pickerView.date)
        }
        self.observer.reverseNotify({ (observer) in
            observer.select(dateField: self, date: self.pickerView.date)
        })
    }
    
    @objc
    private func tapGesture(_ sender: Any) {
        if self.canBecomeFirstResponder == true {
            self.becomeFirstResponder()
        }
    }

}
