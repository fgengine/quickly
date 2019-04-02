//
//  Quickly
//

open class QDateFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QDateFieldComposable) -> Bool
    public typealias Closure = (_ composable: QDateFieldComposable) -> Void

    public var field: QDateFieldStyleSheet
    public var height: CGFloat
    public var date: Date?
    public var isValid: Bool {
        get { return self.date != nil }
    }
    public var isEditing: Bool
    public var shouldBeginEditing: ShouldClosure?
    public var beginEditing: Closure?
    public var select: Closure?
    public var shouldEndEditing: ShouldClosure?
    public var endEditing: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QDateFieldStyleSheet,
        date: Date? = nil,
        height: CGFloat = 44,
        selectedRow: QListFieldPickerRow? = nil,
        shouldBeginEditing: ShouldClosure? = nil,
        beginEditing: Closure? = nil,
        select: Closure? = nil,
        shouldEndEditing: ShouldClosure? = nil,
        endEditing: Closure? = nil
    ) {
        self.field = field
        self.date = date
        self.height = height
        self.isEditing = false
        self.shouldBeginEditing = shouldBeginEditing
        self.beginEditing = beginEditing
        self.select = select
        self.shouldEndEditing = shouldEndEditing
        self.endEditing = endEditing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QDateFieldComposition< Composable: QDateFieldComposable > : QComposition< Composable >, IQEditableComposition {

    public lazy private(set) var field: QDateField = {
        let view = QDateField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong._shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return }
            strong._beginEditing()
        }
        view.onSelect = { [weak self] (dateField: QDateField, date: Date) in
            guard let strong = self else { return }
            strong._select(date)
        }
        view.onShouldEndEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return true }
            return strong._shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (dateField: QDateField) in
            guard let strong = self else { return }
            strong._endEditing()
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.height + composable.edgeInsets.bottom
        )
    }
    
    deinit {
        if let observer = self.owner as? IQDateFieldObserver {
            self.field.remove(observer: observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQDateFieldObserver {
            self.field.add(observer: observer, priority: 0)
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.field.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.field.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.field.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.field.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.field.apply(composable.field)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.field.date = composable.date
    }
    
    // MARK: - IQCompositionEditable
    
    open func beginEditing() {
        self.field.beginEditing()
    }
    
    open func endEditing() {
        self.field.endEditing(false)
    }
    
    // MARK: - Private

    private func _shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    private func _beginEditing() {
        guard let composable = self.composable else { return }
        composable.isEditing = self.field.isEditing
        if let closure = composable.beginEditing {
            closure(composable)
        }
    }

    private func _select(_ date: Date) {
        guard let composable = self.composable else { return }
        composable.date = date
        if let closure = composable.select {
            closure(composable)
        }
    }

    private func _shouldEndEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldEndEditing {
            return closure(composable)
        }
        return true
    }

    private func _endEditing() {
        guard let composable = self.composable else { return }
        composable.isEditing = self.field.isEditing
        if let closure = composable.endEditing {
            closure(composable)
        }
    }

}
