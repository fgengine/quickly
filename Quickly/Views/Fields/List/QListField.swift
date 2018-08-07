//
//  Quickly
//

public class QListFieldStyleSheet : QDisplayViewStyleSheet< QListField > {

    public var rows: [QListFieldPickerRow]
    public var rowHeight: CGFloat
    public var placeholder: IQText?
    public var isEnabled: Bool

    public init(
        rows: [QListFieldPickerRow],
        rowHeight: CGFloat = 40,
        placeholder: IQText? = nil,
        isEnabled: Bool = true,
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.rows = rows
        self.rowHeight = rowHeight
        self.placeholder = placeholder
        self.isEnabled = isEnabled
        
        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }

    public init(_ styleSheet: QListFieldStyleSheet) {
        self.rows = styleSheet.rows
        self.rowHeight = styleSheet.rowHeight
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled

        super.init(styleSheet)
    }

    public override func apply(target: QListField) {
        super.apply(target: target)

        target.rows = self.rows
        target.rowHeight = self.rowHeight
        target.placeholder = self.placeholder
        target.isEnabled = self.isEnabled
    }

}

public protocol IQListFieldObserver : class {
    
    func beginEditing(listField: QListField)
    func select(listField: QListField, row: QListFieldPickerRow)
    func endEditing(listField: QListField)
    
}

public class QListField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ listField: QListField) -> Bool
    public typealias SelectClosure = (_ listField: QListField, _ row: QListFieldPickerRow) -> Void
    public typealias Closure = (_ listField: QListField) -> Void

    public var rows: [QListFieldPickerRow] {
        set(value) { self.pickerSection.rows = value }
        get { return self.pickerSection.rows as! [QListFieldPickerRow] }
    }
    public var selectedRow: QListFieldPickerRow? {
        didSet {
            if let selectedRow = self.selectedRow {
                selectedRow.field.apply(target: self.label)
                self.pickerController.select(row: selectedRow, animated: self.isEditing)
            } else {
                self.label.text = self.placeholder
            }
            self.invalidateIntrinsicContentSize()
        }
    }
    public var rowHeight: CGFloat {
        set(value) {
            self.pickerSection.size.height = value
            self.pickerController.reload()
        }
        get { return self.pickerSection.size.height }
    }
    public var isValid: Bool {
        get { return self.selectedRow != nil }
    }
    public var placeholder: IQText? {
        didSet {
            if self.selectedRow == nil {
                self.label.text = self.placeholder
                self.invalidateIntrinsicContentSize()
            }
        }
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
    open override var intrinsicContentSize: CGSize {
        get { return self.label.intrinsicContentSize }
    }

    public var onShouldBeginEditing: ShouldClosure?
    public var onBeginEditing: Closure?
    public var onSelect: SelectClosure?
    public var onShouldEndEditing: ShouldClosure?
    public var onEndEditing: Closure?

    internal var label: QLabel!
    internal var picker: QPickerView!
    internal var pickerSection: QPickerSection!
    internal var pickerController: QPickerController!
    internal var tapGesture: UITapGestureRecognizer!
    
    private var observer: QObserver< IQListFieldObserver >
    
    public override init(frame: CGRect) {
        self.observer = QObserver< IQListFieldObserver >()
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self.observer = QObserver< IQListFieldObserver >()
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.label = QLabel(frame: self.bounds)
        self.label.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.label)

        self.picker = QPickerView()

        self.pickerSection = QPickerSection(cellType: QListFieldPickerCell.self, height: 40, rows: [])

        self.pickerController = QPickerController()
        self.pickerController.sections = [ self.pickerSection ]
        self.pickerController.delegate = self
        self.picker.pickerController = self.pickerController
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        self.addGestureRecognizer(self.tapGesture)
    }
    
    public func addObserver(_ observer: IQListFieldObserver, priority: UInt) {
        self.observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQListFieldObserver) {
        self.observer.remove(observer)
    }

    open func beginEditing() {
        self.becomeFirstResponder()
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
        if self.selectedRow == nil {
            self.selectedRow = self.rows.first
        }
        self.onBeginEditing?(self)
        self.observer.reverseNotify({ (observer) in
            observer.beginEditing(listField: self)
        })
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        self.observer.reverseNotify({ (observer) in
            observer.endEditing(listField: self)
        })
        return true
    }
    
    @objc
    private func tapGesture(_ sender: Any) {
        if self.canBecomeFirstResponder == true {
            self.becomeFirstResponder()
        }
    }

}

extension QListField : IQPickerControllerDelegate {

    public func select(_ controller: IQPickerController, section: IQPickerSection, row: IQPickerRow) {
        guard let row = row as? QListFieldPickerRow else { return }
        self.selectedRow = row
        if let closure = self.onSelect {
            closure(self, row)
        }
        self.observer.reverseNotify({ (observer) in
            observer.select(listField: self, row: row)
        })
    }

}
