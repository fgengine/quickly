//
//  Quickly
//

open class QMultiTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QMultiTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QMultiTextFieldComposable) -> Void

    public var field: QMultiTextFieldStyleSheet
    public var maximumNumberOfCharecters: UInt
    public var maximumNumberOfLines: UInt
    public var minimumHeight: CGFloat
    public var maximumHeight: CGFloat
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
    public var changedHeight: Closure?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        field: QMultiTextFieldStyleSheet,
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
        self.field = field
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

open class QMultiTextFieldComposition< Composable: QMultiTextFieldComposable > : QComposition< Composable > {

    public lazy private(set) var multiTextField: QMultiTextField = {
        let view = QMultiTextField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return true }
            return strong._shouldBeginEditing()
        }
        view.onBeginEditing = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return }
            strong._beginEditing()
        }
        view.onEditing = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return }
            strong._editing()
        }
        view.onShouldEndEditing = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return true }
            return strong._shouldEndEditing()
        }
        view.onEndEditing = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return }
            strong._endEditing()
        }
        view.onChangedHeight = { [weak self] (multiTextField: QMultiTextField) in
            guard let strong = self else { return }
            strong._changedHeight()
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
        if let observer = self.owner as? IQMultiTextFieldObserver {
            self.multiTextField.removeObserver(observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQMultiTextFieldObserver {
            self.multiTextField.addObserver(observer, priority: 0)
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
                self.multiTextField.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.multiTextField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.multiTextField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.multiTextField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.multiTextField.apply(composable.field)
    }

    private func _shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    private func _beginEditing() {
        guard let composable = self.composable else { return }
        composable.isEditing = self.multiTextField.isEditing
        if let closure = composable.beginEditing {
            closure(composable)
        }
    }

    private func _editing() {
        guard let composable = self.composable else { return }
        composable.text = self.multiTextField.unformatText
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
        composable.isEditing = self.multiTextField.isEditing
        if let closure = composable.endEditing {
            closure(composable)
        }
    }

    private func _changedHeight() {
        guard let composable = self.composable else { return }
        composable.height = self.multiTextField.textHeight
        if let closure = composable.changedHeight {
            closure(composable)
        }
    }

}
