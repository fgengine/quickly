//
//  Quickly
//

open class QMultiTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QMultiTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QMultiTextFieldComposable) -> Void

    public var fieldStyle: QMultiTextFieldStyleSheet
    public var maximumNumberOfCharecters: UInt
    public var maximumNumberOfLines: UInt
    public var minimumHeight: CGFloat
    public var maximumHeight: CGFloat
    public var height: CGFloat
    public var text: String
    public var isValid: Bool {
        get {
            guard let validator = self.fieldStyle.validator else { return true }
            return validator.validate(self.text).isValid
        }
    }
    public var isEditing: Bool
    public var shouldBeginEditing: ShouldClosure?
    public var beginEditing: Closure?
    public var editing: Closure?
    public var shouldEndEditing: ShouldClosure?
    public var endEditing: Closure?
    public var changedHeight: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        fieldStyle: QMultiTextFieldStyleSheet,
        text: String,
        maximumNumberOfCharecters: UInt = 0,
        maximumNumberOfLines: UInt = 0,
        minimumHeight: CGFloat = 0,
        maximumHeight: CGFloat = 0,
        height: CGFloat = 44,
        shouldBeginEditing: ShouldClosure? = nil,
        beginEditing: Closure? = nil,
        editing: Closure? = nil,
        shouldEndEditing: ShouldClosure? = nil,
        endEditing: Closure? = nil,
        changedHeight: Closure? = nil
    ) {
        self.fieldStyle = fieldStyle
        self.text = text
        self.maximumNumberOfCharecters = maximumNumberOfCharecters
        self.maximumNumberOfLines = maximumNumberOfLines
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
        self.height = height
        self.isEditing = false
        self.shouldBeginEditing = shouldBeginEditing
        self.beginEditing = beginEditing
        self.editing = editing
        self.shouldEndEditing = shouldEndEditing
        self.endEditing = endEditing
        self.changedHeight = changedHeight
        super.init(edgeInsets: edgeInsets)
    }

}

open class QMultiTextFieldComposition< Composable: QMultiTextFieldComposable > : QComposition< Composable >, IQEditableComposition {

    public lazy private(set) var fieldView: QMultiTextField = {
        let view = QMultiTextField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] _ in return self?._shouldBeginEditing() ?? true }
        view.onBeginEditing = { [weak self] _ in self?._beginEditing() }
        view.onEditing = { [weak self] _ in self?._editing() }
        view.onShouldEndEditing = { [weak self] _ in return self?._shouldEndEditing() ?? true }
        view.onEndEditing = { [weak self] _ in self?._endEditing() }
        view.onChangedHeight = { [weak self] _ in self?._changedHeight() }
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
        if let observer = self.owner as? IQMultiTextFieldObserver {
            self.fieldView.remove(observer: observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQMultiTextFieldObserver {
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
        self.fieldView.unformatText = composable.text
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
        composable.isEditing = self.fieldView.isEditing
        if let closure = composable.beginEditing {
            closure(composable)
        }
    }

    private func _editing() {
        guard let composable = self.composable else { return }
        composable.text = self.fieldView.unformatText
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
        composable.isEditing = self.fieldView.isEditing
        if let closure = composable.endEditing {
            closure(composable)
        }
    }

    private func _changedHeight() {
        guard let composable = self.composable else { return }
        composable.height = self.fieldView.textHeight
        if let closure = composable.changedHeight {
            closure(composable)
        }
    }

}
