//
//  Quickly
//

open class QListFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QListFieldComposable) -> Bool
    public typealias Closure = (_ composable: QListFieldComposable) -> Void

    public var field: QListFieldStyleSheet
    public var fieldSelectedRow: QListFieldPickerRow?
    public var fieldHeight: CGFloat
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool
    public var fieldShouldBeginEditing: ShouldClosure?
    public var fieldBeginEditing: Closure?
    public var fieldSelect: Closure
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QListFieldStyleSheet,
        fieldHeight: CGFloat = 44,
        fieldSelectedRow: QListFieldPickerRow? = nil,
        fieldShouldBeginEditing: ShouldClosure? = nil,
        fieldBeginEditing: Closure? = nil,
        fieldSelect: @escaping Closure,
        fieldShouldEndEditing: ShouldClosure? = nil,
        fieldEndEditing: Closure? = nil
    ) {
        self.field = field
        self.fieldSelectedRow = fieldSelectedRow
        self.fieldHeight = fieldHeight
        self.fieldIsValid = true
        self.fieldIsEditing = false
        self.fieldShouldBeginEditing = fieldShouldBeginEditing
        self.fieldBeginEditing = fieldBeginEditing
        self.fieldSelect = fieldSelect
        self.fieldShouldEndEditing = fieldShouldEndEditing
        self.fieldEndEditing = fieldEndEditing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QListFieldComposition< Composable: QListFieldComposable > : QComposition< Composable > {

    lazy private var listField: QListField = {
        let view = QListField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        view.onSelect = { [weak self] (listField: QListField, composable: QListFieldPickerRow) in
            guard let strong = self else { return }
            strong.select(composable)
        }
        view.onShouldEndEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return }
            strong.endEditing()
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.fieldHeight + composable.edgeInsets.bottom
        )
    }
    
    deinit {
        if let observer = self.owner as? IQListFieldObserver {
            self.listField.removeObserver(observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQListFieldObserver {
            self.listField.addObserver(observer, priority: 0)
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets
            self.selfConstraints = [
                self.listField.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.listField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.listField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.listField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.field.apply(self.listField)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.listField.selectedRow = composable.fieldSelectedRow
    }

    private func shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    private func beginEditing() {
        guard let composable = self.composable else { return }
        composable.fieldIsEditing = self.listField.isEditing
        if let closure = composable.fieldBeginEditing {
            closure(composable)
        }
    }

    private func select(_ pickerRow: QListFieldPickerRow) {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.listField.isValid
        composable.fieldSelectedRow = pickerRow
        composable.fieldSelect(composable)
    }

    private func shouldEndEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldEndEditing {
            return closure(composable)
        }
        return true
    }

    private func endEditing() {
        guard let composable = self.composable else { return }
        composable.fieldIsEditing = self.listField.isEditing
        if let closure = composable.fieldEndEditing {
            closure(composable)
        }
    }

}
