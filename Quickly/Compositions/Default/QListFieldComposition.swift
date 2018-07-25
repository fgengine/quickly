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
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
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

    public private(set) var listField: QListField!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + composable.fieldHeight + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.listField = QListField(frame: self.contentView.bounds)
        self.listField.translatesAutoresizingMaskIntoConstraints = false
        self.listField.onShouldBeginEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        self.listField.onBeginEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        self.listField.onSelect = { [weak self] (listField: QListField, composable: QListFieldPickerRow) in
            guard let strong = self else { return }
            strong.select(composable)
        }
        self.listField.onShouldEndEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        self.listField.onEndEditing = { [weak self] (listField: QListField) in
            guard let strong = self else { return }
            strong.endEditing()
        }
        self.contentView.addSubview(self.listField)
    }

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets {
            self.currentEdgeInsets = composable.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.listField.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.listField.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.listField.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.listField.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.field.apply(target: self.listField)
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
