//
//  Quickly
//

open class QTextFieldCompositionData : QCompositionData {

    public typealias ShouldClosure = (_ data: QTextFieldCompositionData) -> Bool
    public typealias Closure = (_ data: QTextFieldCompositionData) -> Void

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

public class QTextFieldComposition< DataType: QTextFieldCompositionData >: QComposition< DataType > {

    public private(set) var textField: QTextField!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType, size: CGSize) -> CGSize {
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + data.fieldHeight + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.textField = QTextField(frame: self.contentView.bounds)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.onShouldBeginEditing = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return true }
            return strongify.shouldBeginEditing()
        }
        self.textField.onBeginEditing = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return }
            strongify.beginEditing()
        }
        self.textField.onEditing = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return }
            strongify.editing()
        }
        self.textField.onShouldEndEditing = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return true }
            return strongify.shouldEndEditing()
        }
        self.textField.onEndEditing = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return }
            strongify.endEditing()
        }
        self.textField.onShouldClear = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return true }
            return strongify.shouldClear()
        }
        self.textField.onPressedClear = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return }
            strongify.pressedClear()
        }
        self.textField.onShouldReturn = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return true }
            return strongify.shouldReturn()
        }
        self.textField.onPressedReturn = { [weak self] (textField: QTextField) in
            guard let strongify = self else { return }
            strongify.pressedReturn()
        }
        self.contentView.addSubview(self.textField)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.textField.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.textField.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.textField.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.textField.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.field.apply(target: self.textField)
        self.textField.unformatText = data.fieldText
    }

    private func shouldBeginEditing() -> Bool {
        guard let data = self.data else { return true }
        if let closure = data.fieldShouldBeginEditing {
            return closure(data)
        }
        return true
    }

    private func beginEditing() {
        guard let data = self.data else { return }
        data.fieldIsEditing = self.textField.isEditing
        if let closure = data.fieldBeginEditing {
            closure(data)
        }
    }

    private func editing() {
        guard let data = self.data else { return }
        data.fieldIsValid = self.textField.isValid
        data.fieldText = self.textField.unformatText
        if let closure = data.fieldEditing {
            closure(data)
        }
    }

    private func shouldEndEditing() -> Bool {
        guard let data = self.data else { return true }
        if let closure = data.fieldShouldEndEditing {
            return closure(data)
        }
        return true
    }

    private func endEditing() {
        guard let data = self.data else { return }
        data.fieldIsEditing = self.textField.isEditing
        if let closure = data.fieldEndEditing {
            closure(data)
        }
    }

    private func shouldClear() -> Bool {
        guard let data = self.data else { return true }
        if let closure = data.fieldShouldClear {
            return closure(data)
        }
        return true
    }

    private func pressedClear() {
        guard let data = self.data else { return }
        data.fieldIsValid = self.textField.isValid
        data.fieldText = self.textField.unformatText
        if let closure = data.fieldPressedClear {
            closure(data)
        }
    }

    private func shouldReturn() -> Bool {
        guard let data = self.data else { return true }
        if let closure = data.fieldShouldReturn {
            return closure(data)
        }
        return true
    }

    private func pressedReturn() {
        guard let data = self.data else { return }
        if let closure = data.fieldPressedReturn {
            closure(data)
        }
    }

}
