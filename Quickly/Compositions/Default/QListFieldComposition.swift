//
//  Quickly
//

open class QListFieldCompositionData : QCompositionData {

    public typealias ShouldClosure = (_ data: QListFieldCompositionData) -> Bool
    public typealias Closure = (_ data: QListFieldCompositionData) -> Void

    public var field: QListFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldSelectedRow: QListFieldPickerRow?
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool
    public var fieldShouldBeginEditing: ShouldClosure?
    public var fieldBeginEditing: Closure?
    public var fieldSelect: Closure?
    public var fieldShouldEndEditing: ShouldClosure?
    public var fieldEndEditing: Closure?

    public init(
        field: QListFieldStyleSheet,
        text: String
    ) {
        self.field = field
        self.fieldHeight = 44
        self.fieldIsValid = true
        self.fieldIsEditing = false
        super.init()
    }

}

public class QListFieldComposition< DataType: QListFieldCompositionData >: QComposition< DataType > {

    public private(set) var listField: QListField!

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

        self.listField = QListField(frame: self.contentView.bounds)
        self.listField.translatesAutoresizingMaskIntoConstraints = false
        self.listField.onShouldBeginEditing = { [weak self] (listField: QListField) in
            guard let strongify = self else { return true }
            return strongify.shouldBeginEditing()
        }
        self.listField.onBeginEditing = { [weak self] (listField: QListField) in
            guard let strongify = self else { return }
            strongify.beginEditing()
        }
        self.listField.onSelect = { [weak self] (listField: QListField, data: QListFieldPickerRow) in
            guard let strongify = self else { return }
            strongify.select(data)
        }
        self.listField.onShouldEndEditing = { [weak self] (listField: QListField) in
            guard let strongify = self else { return true }
            return strongify.shouldEndEditing()
        }
        self.listField.onEndEditing = { [weak self] (listField: QListField) in
            guard let strongify = self else { return }
            strongify.endEditing()
        }
        self.contentView.addSubview(self.listField)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.listField.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.listField.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.listField.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.listField.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.field.apply(target: self.listField)
        self.listField.selectedRow = data.fieldSelectedRow
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
        data.fieldIsEditing = self.listField.isEditing
        if let closure = data.fieldBeginEditing {
            closure(data)
        }
    }

    private func select(_ pickerRow: QListFieldPickerRow) {
        guard let data = self.data else { return }
        data.fieldIsValid = self.listField.isValid
        data.fieldSelectedRow = pickerRow
        if let closure = data.fieldSelect {
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
        data.fieldIsEditing = self.listField.isEditing
        if let closure = data.fieldEndEditing {
            closure(data)
        }
    }

}
