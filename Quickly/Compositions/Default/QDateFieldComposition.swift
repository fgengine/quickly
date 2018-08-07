//
//  Quickly
//

open class QDateFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QDateFieldComposable) -> Bool
    public typealias Closure = (_ composable: QDateFieldComposable) -> Void

    public var field: QDateFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldDate: Date?
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool
    public var fieldShouldBeginEditing: ShouldClosure?
    public var fieldBeginEditing: Closure?
    public var fieldSelect: Closure
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        field: QDateFieldStyleSheet,
        fieldDate: Date? = nil,
        fieldHeight: CGFloat = 44,
        fieldSelectedRow: QListFieldPickerRow? = nil,
        fieldShouldBeginEditing: ShouldClosure? = nil,
        fieldBeginEditing: Closure? = nil,
        fieldSelect: @escaping Closure,
        fieldShouldEndEditing: ShouldClosure? = nil,
        fieldEndEditing: Closure? = nil
    ) {
        self.field = field
        self.fieldDate = fieldDate
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

open class QDateFieldComposition< Composable: QDateFieldComposable >: QComposition< Composable > {

    open override weak var delegate: IQCompositionDelegate? {
        willSet {
            if let delegate = self.delegate {
                self.dateField.removeObserver(delegate)
            }
        }
        didSet {
            if let delegate = self.delegate {
                self.dateField.addObserver(delegate, priority: 0)
            }
        }
    }
    public private(set) var dateField: QDateField!

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

    open override func setup() {
        super.setup()

        self.dateField = QDateField(frame: self.contentView.bounds)
        self.dateField.translatesAutoresizingMaskIntoConstraints = false
        self.dateField.onShouldBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        self.dateField.onBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        self.dateField.onSelect = { [weak self] (dateField: QDateField, date: Date) in
            guard let strong = self else { return }
            strong.select(date)
        }
        self.dateField.onShouldEndEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        self.dateField.onEndEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return }
            strong.endEditing()
        }
        if let delegate = self.delegate {
            self.dateField.addObserver(delegate, priority: 0)
        }
        self.contentView.addSubview(self.dateField)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftEdgeInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightEdgeInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.dateField.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.dateField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.dateField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.dateField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.field.apply(target: self.dateField)
        self.dateField.date = composable.fieldDate
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
        composable.fieldIsEditing = self.dateField.isEditing
        if let closure = composable.fieldBeginEditing {
            closure(composable)
        }
    }

    private func select(_ date: Date) {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.dateField.isValid
        composable.fieldDate = date
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
        composable.fieldIsEditing = self.dateField.isEditing
        if let closure = composable.fieldEndEditing {
            closure(composable)
        }
    }

}
