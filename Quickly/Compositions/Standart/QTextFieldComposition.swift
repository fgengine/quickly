//
//  Quickly
//

open class QTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QTextFieldComposable) -> Void

    public var field: QTextFieldStyleSheet
    public var height: CGFloat
    public var text: String
    public var isValid: Bool {
        get {
            guard let validator = self.field.validator else { return true }
            return validator.validate(self.text)
        }
    }
    public var isEditing: Bool
    public var shouldBeginEditing: ShouldClosure?
    public var beginEditing: Closure?
    public var editing: Closure?
    public var shouldEndEditing: ShouldClosure?
    public var endEditing: Closure?
    public var shouldClear: ShouldClosure?
    public var pressedClear: Closure?
    public var shouldReturn: ShouldClosure?
    public var pressedReturn: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QTextFieldStyleSheet,
        text: String,
        height: CGFloat = 44,
        shouldBeginEditing: ShouldClosure? = nil,
        beginEditing: Closure? = nil,
        editing: Closure? = nil,
        shouldEndEditing: ShouldClosure? = nil,
        endEditing: Closure? = nil,
        shouldClear: ShouldClosure? = nil,
        pressedClear: Closure? = nil,
        shouldReturn: ShouldClosure? = nil,
        pressedReturn: Closure? = nil
    ) {
        self.field = field
        self.text = text
        self.height = height
        self.isEditing = false
        self.shouldBeginEditing = shouldBeginEditing
        self.beginEditing = beginEditing
        self.editing = editing
        self.shouldEndEditing = shouldEndEditing
        self.endEditing = endEditing
        self.shouldClear = shouldClear
        self.pressedClear = pressedClear
        self.shouldReturn = shouldReturn
        self.pressedReturn = pressedReturn
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTextFieldComposition< Composable: QTextFieldComposable > : QComposition< Composable >, IQEditableComposition {

    public lazy private(set) var field: QTextField = {
        let view = QTextField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong._shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong._beginEditing()
        }
        view.onEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong._editing()
        }
        view.onShouldEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong._shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong._endEditing()
        }
        view.onShouldClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong._shouldClear()
        }
        view.onPressedClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong._pressedClear()
        }
        view.onShouldReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong._shouldReturn()
        }
        view.onPressedReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong._pressedReturn()
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
        if let observer = self.owner as? IQTextFieldObserver {
            self.field.removeObserver(observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQTextFieldObserver {
            self.field.addObserver(observer, priority: 0)
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self._edgeInsets != edgeInsets {
            self._edgeInsets = edgeInsets
            self._constraints = [
                self.field.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.field.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.field.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.field.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.field.apply(composable.field)
        self.field.unformatText = composable.text
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

    private func _editing() {
        guard let composable = self.composable else { return }
        composable.text = self.field.unformatText
        if let closure = composable.editing {
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

    private func _shouldClear() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldClear {
            return closure(composable)
        }
        return true
    }

    private func _pressedClear() {
        guard let composable = self.composable else { return }
        composable.text = self.field.unformatText
        if let closure = composable.pressedClear {
            closure(composable)
        }
    }

    private func _shouldReturn() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldReturn {
            return closure(composable)
        }
        return true
    }

    private func _pressedReturn() {
        guard let composable = self.composable else { return }
        if let closure = composable.pressedReturn {
            closure(composable)
        }
    }

}
