//
//  Quickly
//

open class QDateFieldCompositionData : QCompositionData {

    public typealias ShouldClosure = (_ data: QDateFieldCompositionData) -> Bool
    public typealias Closure = (_ data: QDateFieldCompositionData) -> Void

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
        field: QDateFieldStyleSheet,
        date: Date?
    ) {
        self.field = field
        self.fieldHeight = 44
        self.fieldDate = date
        self.fieldIsValid = true
        self.fieldIsEditing = false
        super.init()
    }

}

public class QDateFieldComposition< DataType: QDateFieldCompositionData >: QComposition< DataType > {

    public private(set) var dateField: QDateField!

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

        self.dateField = QDateField(frame: self.contentView.bounds)
        self.dateField.translatesAutoresizingMaskIntoConstraints = false
        self.dateField.onShouldBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strongify = self else { return true }
            return strongify.shouldBeginEditing()
        }
        self.dateField.onBeginEditing = { [weak self] (dateField: QDateField) in
            guard let strongify = self else { return }
            strongify.beginEditing()
        }
        self.dateField.onSelect = { [weak self] (dateField: QDateField, date: Date) in
            guard let strongify = self else { return }
            strongify.select(date)
        }
        self.dateField.onShouldEndEditing = { [weak self] (dateField: QDateField) in
            guard let strongify = self else { return true }
            return strongify.shouldEndEditing()
        }
        self.dateField.onEndEditing = { [weak self] (dateField: QDateField) in
            guard let strongify = self else { return }
            strongify.endEditing()
        }
        self.contentView.addSubview(self.dateField)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.dateField.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.dateField.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.dateField.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.dateField.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.field.apply(target: self.dateField)
        self.dateField.date = data.fieldDate
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
        data.fieldIsEditing = self.dateField.isEditing
        if let closure = data.fieldBeginEditing {
            closure(data)
        }
    }

    private func select(_ date: Date) {
        guard let data = self.data else { return }
        data.fieldIsValid = self.dateField.isValid
        data.fieldDate = date
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
        data.fieldIsEditing = self.dateField.isEditing
        if let closure = data.fieldEndEditing {
            closure(data)
        }
    }

}
