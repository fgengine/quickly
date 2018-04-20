//
//  Quickly
//

public enum QDateFieldMode {
    case date
    case time
    case dateAndTime

    public var datePickerMode: UIDatePickerMode {
        get {
            switch self {
            case .date: return UIDatePickerMode.date
            case .time: return UIDatePickerMode.time
            case .dateAndTime: return UIDatePickerMode.dateAndTime
            }
        }
    }
}

public class QDateFieldStyleSheet : QDisplayViewStyleSheet< QDateField > {

    public var formatter: IQDateFieldFormatter?
    public var mode: QDateFieldMode
    public var calendar: Calendar?
    public var locale: Locale?
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var placeholder: IQText?
    public var isEnabled: Bool

    public override init() {
        self.mode = .date
        self.isEnabled = true

        super.init()
    }

    public override func apply(target: QDateField) {
        super.apply(target: target)

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

public class QDateField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ dateField: QDateField) -> Bool
    public typealias SelectClosure = (_ dateField: QDateField, _ date: Date) -> Void
    public typealias Closure = (_ dateField: QDateField) -> Void

    public var formatter: IQDateFieldFormatter? {
        didSet { self.updateText() }
    }
    public var mode: QDateFieldMode = .date {
        didSet { self.picker.datePickerMode = self.mode.datePickerMode }
    }
    public var calendar: Calendar? {
        set(value) { self.picker.calendar = value }
        get { return self.picker.calendar }
    }
    public var locale: Locale? {
        set(value) { self.picker.locale = value }
        get { return self.picker.locale }
    }
    public var date: Date? {
        didSet {
            if var date = self.date {
                self.processDate(&date)
                self.picker.setDate(date, animated: self.isFirstResponder)
            }
            self.updateText()
        }
    }
    public var minimumDate: Date? {
        set(value) {
            self.picker.minimumDate = value
            if var date = self.date {
                if self.processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self.picker.minimumDate }
    }
    public var maximumDate: Date? {
        set(value) {
            self.picker.maximumDate = value
            if var date = self.date {
                if self.processDate(&date) == true {
                    self.date = date
                }
            }
        }
        get { return self.picker.maximumDate }
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
        get { return self.picker }
    }

    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onSelect: SelectClosure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?

    private var label: QLabel!
    private var picker: UIDatePicker!

    open override var intrinsicContentSize: CGSize {
        get { return self.label.intrinsicContentSize }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.label = QLabel(frame: self.bounds)
        self.label.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.label)

        self.picker = UIDatePicker()
        self.picker.datePickerMode = self.mode.datePickerMode
        self.picker.addValueChanged(self, action: #selector(self.changeDate(_:)))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.label.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.label.sizeToFit()
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() == true else { return false }
        if self.date == nil {
            self.date = self.picker.date
        }
        self.onBeginEditing?(self)
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        return true
    }

    private func updateText() {
        guard let date = self.date, let formatter = self.formatter else {
            self.label.text = self.placeholder
            self.invalidateIntrinsicContentSize()
            return
        }
        self.label.text = formatter.from(date)
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
        self.date = self.picker.date
        self.updateText()
        self.onSelect?(self, self.picker.date)
    }

}
