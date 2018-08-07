//
//  Quickly
//

open class QTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QTextFieldComposable) -> Void

    public var field: QTextFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldText: String
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool
    public var fieldShouldBeginEditing: ShouldClosure?
    public var fieldBeginEditing: Closure?
    public var fieldEditing: Closure
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?
    public var fieldShouldClear: ShouldClosure?
    public var fieldPressedClear: Closure?
    public var fieldShouldReturn: ShouldClosure?
    public var fieldPressedReturn: Closure?

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        field: QTextFieldStyleSheet,
        fieldText: String,
        fieldHeight: CGFloat = 44,
        fieldShouldBeginEditing: ShouldClosure? = nil,
        fieldBeginEditing: Closure? = nil,
        fieldEditing: @escaping Closure,
        fieldShouldEndEditing: ShouldClosure? = nil,
        fieldEndEditing: Closure? = nil,
        fieldShouldClear: ShouldClosure? = nil,
        fieldPressedClear: Closure? = nil,
        fieldShouldReturn: ShouldClosure? = nil,
        fieldPressedReturn: Closure? = nil
    ) {
        self.field = field
        self.fieldText = fieldText
        self.fieldHeight = fieldHeight
        self.fieldIsValid = true
        self.fieldIsEditing = false
        self.fieldShouldBeginEditing = fieldShouldBeginEditing
        self.fieldBeginEditing = fieldBeginEditing
        self.fieldEditing = fieldEditing
        self.fieldShouldEndEditing = fieldShouldEndEditing
        self.fieldEndEditing = fieldEndEditing
        self.fieldShouldClear = fieldShouldClear
        self.fieldPressedClear = fieldPressedClear
        self.fieldShouldReturn = fieldShouldReturn
        self.fieldPressedReturn = fieldPressedReturn
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTextFieldComposition< Composable: QTextFieldComposable > : QComposition< Composable > {

    open override weak var delegate: IQCompositionDelegate? {
        willSet {
            if let delegate = self.delegate {
                self.textField.removeObserver(delegate)
            }
        }
        didSet {
            if let delegate = self.delegate {
                self.textField.addObserver(delegate, priority: 0)
            }
        }
    }
    public private(set) var textField: QTextField!

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

        self.textField = QTextField(frame: self.contentView.bounds)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.onShouldBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldBeginEditing()
        }
        self.textField.onBeginEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.beginEditing()
        }
        self.textField.onEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.editing()
        }
        self.textField.onShouldEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldEndEditing()
        }
        self.textField.onEndEditing = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.endEditing()
        }
        self.textField.onShouldClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldClear()
        }
        self.textField.onPressedClear = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.pressedClear()
        }
        self.textField.onShouldReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return true }
            return strong.shouldReturn()
        }
        self.textField.onPressedReturn = { [weak self] (textField: QTextField) in
            guard let strong = self else { return }
            strong.pressedReturn()
        }
        if let delegate = self.delegate {
            self.textField.addObserver(delegate, priority: 0)
        }
        self.contentView.addSubview(self.textField)
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
            selfConstraints.append(self.textField.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.textField.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.textField.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.textField.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.field.apply(target: self.textField)
        self.textField.unformatText = composable.fieldText
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
        composable.fieldIsEditing = self.textField.isEditing
        if let closure = composable.fieldBeginEditing {
            closure(composable)
        }
    }

    private func editing() {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.textField.isValid
        composable.fieldText = self.textField.unformatText
        composable.fieldEditing(composable)
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
        composable.fieldIsEditing = self.textField.isEditing
        if let closure = composable.fieldEndEditing {
            closure(composable)
        }
    }

    private func shouldClear() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldClear {
            return closure(composable)
        }
        return true
    }

    private func pressedClear() {
        guard let composable = self.composable else { return }
        composable.fieldIsValid = self.textField.isValid
        composable.fieldText = self.textField.unformatText
        if let closure = composable.fieldPressedClear {
            closure(composable)
        }
    }

    private func shouldReturn() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.fieldShouldReturn {
            return closure(composable)
        }
        return true
    }

    private func pressedReturn() {
        guard let composable = self.composable else { return }
        if let closure = composable.fieldPressedReturn {
            closure(composable)
        }
    }

}
