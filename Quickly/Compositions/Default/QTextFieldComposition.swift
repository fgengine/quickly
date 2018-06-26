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
    public var fieldEditing: Closure?
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?
    public var fieldShouldClear: ShouldClosure?
    public var fieldPressedClear: Closure?
    public var fieldShouldReturn: ShouldClosure?
    public var fieldPressedReturn: Closure?

    public init(
        field: QTextFieldStyleSheet,
        text: String
    ) {
        self.field = field
        self.fieldHeight = 44
        self.fieldText = text
        self.fieldIsValid = true
        self.fieldIsEditing = false
        super.init()
    }

}

open class QTextFieldComposition< Composable: QTextFieldComposable >: QComposition< Composable > {

    public private(set) var textField: QTextField!

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
        self.contentView.addSubview(self.textField)
    }

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets {
            self.currentEdgeInsets = composable.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.textField.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.textField.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.textField.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.textField.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
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
        if let closure = composable.fieldEditing {
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
