//
//  Quickly
//

public class QListFieldStyleSheet : QDisplayViewStyleSheet {

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
                self.valieLabel.apply(selectedRow.field)
                self.pickerController.select(row: selectedRow, animated: self.isEditing)
            } else {
                self.valieLabel.text = self.placeholder
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
                self.valieLabel.text = self.placeholder
                self.invalidateIntrinsicContentSize()
            }
        }
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
        get { return self.valieLabel.intrinsicContentSize }
    }

    internal private(set) var valieLabel: QLabel!
    internal private(set) var pickerView: QPickerView!
    internal private(set) var pickerSection: QPickerSection!
    internal private(set) var pickerController: QPickerController!
    internal private(set) var tapGesture: UITapGestureRecognizer!
    
    private var _observer: QObserver< IQListFieldObserver >
    
    public required init() {
        self._observer = QObserver< IQListFieldObserver >()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        self._observer = QObserver< IQListFieldObserver >()
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self._observer = QObserver< IQListFieldObserver >()
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.valieLabel = QLabel(frame: self.bounds)
        self.valieLabel.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self.valieLabel)

        self.pickerView = QPickerView()

        self.pickerSection = QPickerSection(cellType: QListFieldPickerCell.self, height: 40, rows: [])

        self.pickerController = QPickerController()
        self.pickerController.sections = [ self.pickerSection ]
        self.pickerController.delegate = self
        self.pickerView.pickerController = self.pickerController
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self._tapGesture(_:)))
        self.addGestureRecognizer(self.tapGesture)
    }
    
    public func addObserver(_ observer: IQListFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func removeObserver(_ observer: IQListFieldObserver) {
        self._observer.remove(observer)
    }

    open func beginEditing() {
        self.becomeFirstResponder()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.valieLabel.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.valieLabel.sizeToFit()
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() == true else { return false }
        if self.selectedRow == nil {
            self.selectedRow = self.rows.first
        }
        self.onBeginEditing?(self)
        self._observer.reverseNotify({ (observer) in
            observer.beginEditing(listField: self)
        })
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        self._observer.reverseNotify({ (observer) in
            observer.endEditing(listField: self)
        })
        return true
    }
    
    public func apply(_ styleSheet: QListFieldStyleSheet) {
        self.apply(styleSheet as QDisplayViewStyleSheet)
        
        self.rows = styleSheet.rows
        self.rowHeight = styleSheet.rowHeight
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled
    }
    
}

extension QListField {
    
    @objc
    private func _tapGesture(_ sender: Any) {
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
        self._observer.reverseNotify({ (observer) in
            observer.select(listField: self, row: row)
        })
    }

}
