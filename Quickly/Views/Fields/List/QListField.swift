//
//  Quickly
//

public protocol IQListFieldObserver : class {
    
    func beginEditing(listField: QListField)
    func select(listField: QListField, row: QListFieldPickerRow)
    func endEditing(listField: QListField)
    func pressedCancel(listField: QListField)
    func pressedDone(listField: QListField)
    
}

public class QListField : QDisplayView, IQField {

    public typealias ShouldClosure = (_ listField: QListField) -> Bool
    public typealias SelectClosure = (_ listField: QListField, _ row: QListFieldPickerRow) -> Void
    public typealias Closure = (_ listField: QListField) -> Void

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
    public var rows: [QListFieldPickerRow] {
        set(value) { self._section.rows = value }
        get { return self._section.rows as! [QListFieldPickerRow] }
    }
    public var selectedRow: QListFieldPickerRow? {
        didSet {
            if let selectedRow = self.selectedRow {
                self._label.apply(selectedRow.field)
                self._controller.select(row: selectedRow, animated: self.isEditing)
            } else {
                self._label.text = self.placeholder
            }
            self.invalidateIntrinsicContentSize()
        }
    }
    public var rowHeight: CGFloat {
        set(value) {
            self._section.size.height = value
            self._controller.reload()
        }
        get { return self._section.size.height }
    }
    public var isValid: Bool {
        get { return self.selectedRow != nil }
    }
    public var placeholder: IQText? {
        didSet {
            if self.selectedRow == nil {
                self._label.text = self.placeholder
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public var isEnabled: Bool = true
    public var isEditing: Bool {
        get { return self.isFirstResponder }
    }
    public lazy var toolbar: QToolbar = QToolbar(items: self._toolbarItems())
    public var toolbarActions: QFieldAction = [] {
        didSet(oldValue) {
            if self.toolbarActions != oldValue {
                self.toolbar.items = self._toolbarItems()
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
    private var _picker: QPickerView!
    private var _section: QPickerSection!
    private var _controller: QPickerController!
    private var _tapGesture: UITapGestureRecognizer!
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

        self._label = QLabel(frame: self.bounds)
        self._label.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self._label)

        self._picker = QPickerView()

        self._section = QPickerSection(cellType: QListFieldPickerCell.self, height: 40, rows: [])

        self._controller = QPickerController()
        self._controller.sections = [ self._section ]
        self._controller.delegate = self
        self._picker.pickerController = self._controller
        
        self._tapGesture = UITapGestureRecognizer(target: self, action: #selector(self._tapGesture(_:)))
        self.addGestureRecognizer(self._tapGesture)
    }
    
    public func add(observer: IQListFieldObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQListFieldObserver) {
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
        if self.selectedRow == nil {
            self.selectedRow = self.rows.first
            changeSelection = self.selectedRow != nil
        } else {
            changeSelection = false
        }
        self.onBeginEditing?(self)
        self._observer.notify({ (observer) in
            observer.beginEditing(listField: self)
        })
        if changeSelection == true {
            if let closure = self.onSelect {
                closure(self, self.selectedRow!)
            }
            self._observer.notify({ (observer) in
                observer.select(listField: self, row: self.selectedRow!)
            })
            if let form = self.form {
                form.changed(field: self)
            }
        }
        return true
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() == true else { return false }
        self.onEndEditing?(self)
        self._observer.notify({ (observer) in
            observer.endEditing(listField: self)
        })
        return true
    }
    
    public func apply(_ styleSheet: QListFieldStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.form = styleSheet.form
        self.rows = styleSheet.rows
        self.rowHeight = styleSheet.rowHeight
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled
        if let style = styleSheet.toolbarStyle {
            self.toolbar.apply(style)
        }
        self.toolbarActions = styleSheet.toolbarActions
    }
    
}

extension QListField {
    
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
            observer.pressedCancel(listField: self)
        })
        self.endEditing(false)
    }
    
    @objc
    private func _pressedDone(_ sender: Any) {
        if let closure = self.onPressedDone {
            closure(self)
        }
        self._observer.notify({ (observer) in
            observer.pressedDone(listField: self)
        })
        self.endEditing(false)
    }

}

extension QListField : IQPickerControllerDelegate {

    public func select(_ controller: IQPickerController, section: IQPickerSection, row: IQPickerRow) {
        guard let row = row as? QListFieldPickerRow else { return }
        self.selectedRow = row
        if let closure = self.onSelect {
            closure(self, row)
        }
        self._observer.notify({ (observer) in
            observer.select(listField: self, row: row)
        })
        if let form = self.form {
            form.changed(field: self)
        }
    }

}
