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
    public var fieldSelect: Closure?
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QDateFieldStyleSheet,
        fieldDate: Date? = nil,
        fieldHeight: CGFloat = 44,
        fieldSelectedRow: QListFieldPickerRow? = nil,
        fieldShouldBeginEditing: ShouldClosure? = nil,
        fieldBeginEditing: Closure? = nil,
        fieldSelect: Closure? = nil,
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

open class QDateFieldComposition< Composable: QDateFieldComposable > : QComposition< Composable > {

    public lazy private(set) var dateField: QDateField = {
        let view = QDateField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        view.onSelect = { [weak self] (dateField: QDateField, date: Date) in
            guard let strong = self else { return }
            strong.select(date)
        }
        view.onShouldEndEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (dateField: QDateField) in
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
        if let observer = self.owner as? IQDateFieldObserver {
            self.dateField.removeObserver(observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQDateFieldObserver {
            self.dateField.addObserver(observer, priority: 0)
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
                self.dateField.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.dateField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.dateField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.dateField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.field.apply(self.dateField)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
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
        if let closure = composable.fieldSelect {
            closure(composable)
        }
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
