//
//  Quickly
//

open class QListFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QListFieldComposable) -> Bool
    public typealias Closure = (_ composable: QListFieldComposable) -> Void

    public var fieldStyle: QListFieldStyleSheet
    public var selectedRow: QListFieldPickerRow?
    public var height: CGFloat
    public var isValid: Bool{
        get { return self.selectedRow != nil }
    }
    public var isEditing: Bool
    public var shouldBeginEditing: ShouldClosure?
    public var beginEditing: Closure?
    public var select: Closure?
    public var shouldEndEditing: ShouldClosure?
    public var endEditing: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        fieldStyle: QListFieldStyleSheet,
        height: CGFloat = 44,
        selectedRow: QListFieldPickerRow? = nil,
        shouldBeginEditing: ShouldClosure? = nil,
        beginEditing: Closure? = nil,
        select: Closure? = nil,
        shouldEndEditing: ShouldClosure? = nil,
        endEditing: Closure? = nil
    ) {
        self.fieldStyle = fieldStyle
        self.selectedRow = selectedRow
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

open class QListFieldComposition< Composable: QListFieldComposable > : QComposition< Composable >, IQEditableComposition {

    public lazy private(set) var fieldView: QListField = {
        let view = QListField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] _ in return self?._shouldBeginEditing() ?? true }
        view.onBeginEditing = { [weak self] _ in return self?._beginEditing() ?? () }
        view.onSelect = { [weak self] listField, composable in return self?._select(composable) ?? () }
        view.onShouldEndEditing = { [weak self] _ in return self?._shouldEndEditing() ?? true }
        view.onEndEditing = { [weak self] _ in return self?._endEditing() ?? () }
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
        if let observer = self.owner as? IQListFieldObserver {
            self.fieldView.remove(observer: observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQListFieldObserver {
            self.fieldView.add(observer: observer, priority: 0)
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.fieldView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.fieldView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.fieldView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.fieldView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.fieldView.apply(composable.fieldStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.fieldView.selectedRow = composable.selectedRow
    }
    
    // MARK: IQCompositionEditable
    
    open func beginEditing() {
        self.fieldView.beginEditing()
    }
    
    open func endEditing() {
        self.fieldView.endEditing(false)
    }
    
    // MARK: Private

    private func _shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    private func _beginEditing() {
        guard let composable = self.composable else { return }
        composable.selectedRow = self.fieldView.selectedRow
        composable.isEditing = self.fieldView.isEditing
        if let closure = composable.beginEditing {
            closure(composable)
        }
    }

    private func _select(_ pickerRow: QListFieldPickerRow) {
        guard let composable = self.composable else { return }
        composable.selectedRow = pickerRow
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
        composable.isEditing = self.fieldView.isEditing
        if let closure = composable.endEditing {
            closure(composable)
        }
    }

}
