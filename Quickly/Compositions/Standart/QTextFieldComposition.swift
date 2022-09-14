//
//  Quickly
//

import UIKit

open class QTextFieldComposable : QComposable {

    public typealias ShouldClosure = (_ composable: QTextFieldComposable) -> Bool
    public typealias Closure = (_ composable: QTextFieldComposable) -> Void
    public typealias SelectSuggestionClosure = (_ composable: QTextFieldComposable, _ suggestion: String) -> Void

    public var field: QTextFieldStyleSheet
    public var height: CGFloat
    public var text: String
    public var isValid: Bool {
        get {
            guard let validator = self.field.validator else { return true }
            return validator.validate(self.text).isValid
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
    public var selectSuggestion: SelectSuggestionClosure?

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
        pressedReturn: Closure? = nil,
        selectSuggestion: SelectSuggestionClosure? = nil
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
        self.selectSuggestion = selectSuggestion
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTextFieldComposition< Composable: QTextFieldComposable > : QComposition< Composable >, IQEditableComposition {

    public lazy private(set) var field: QTextField = {
        let view = QTextField(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] _ in return self?._shouldBeginEditing() ?? true }
        view.onBeginEditing = { [weak self] _ in self?._beginEditing() }
        view.onEditing = { [weak self] _ in self?._editing() }
        view.onShouldEndEditing = { [weak self] _ in return self?._shouldEndEditing() ?? true }
        view.onEndEditing = { [weak self] _ in self?._endEditing() }
        view.onShouldClear = { [weak self] _ in return self?._shouldClear() ?? true }
        view.onPressedClear = { [weak self] _ in self?._pressedClear() }
        view.onShouldReturn = { [weak self] _ in return self?._shouldReturn() ?? true }
        view.onPressedReturn = { [weak self] _ in self?._pressedReturn() }
        view.onSelectSuggestion = { [weak self] _, suggestion in self?._select(suggestion: suggestion) }
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
            self.field.remove(observer: observer)
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        if let observer = owner as? IQTextFieldObserver {
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
        self.field.unformatText = composable.text
    }
    
    // MARK: IQCompositionEditable
    
    open func beginEditing() {
        self.field.beginEditing()
    }
    
    open func endEditing() {
        self.field.endEditing(false)
    }
    
}

// MARK: Private

private extension QTextFieldComposition {

    func _shouldBeginEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldBeginEditing {
            return closure(composable)
        }
        return true
    }

    func _beginEditing() {
        guard let composable = self.composable else { return }
        composable.isEditing = self.field.isEditing
        if let closure = composable.beginEditing {
            closure(composable)
        }
    }

    func _editing() {
        guard let composable = self.composable else { return }
        composable.text = self.field.unformatText
        if let closure = composable.editing {
            closure(composable)
        }
    }

    func _shouldEndEditing() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldEndEditing {
            return closure(composable)
        }
        return true
    }

    func _endEditing() {
        guard let composable = self.composable else { return }
        composable.isEditing = self.field.isEditing
        if let closure = composable.endEditing {
            closure(composable)
        }
    }

    func _shouldClear() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldClear {
            return closure(composable)
        }
        return true
    }

    func _pressedClear() {
        guard let composable = self.composable else { return }
        composable.text = self.field.unformatText
        if let closure = composable.pressedClear {
            closure(composable)
        }
    }

    func _shouldReturn() -> Bool {
        guard let composable = self.composable else { return true }
        if let closure = composable.shouldReturn {
            return closure(composable)
        }
        return true
    }

    func _pressedReturn() {
        guard let composable = self.composable else { return }
        if let closure = composable.pressedReturn {
            closure(composable)
        }
    }
    
    func _select(suggestion: String) {
        guard let composable = self.composable else { return }
        if let closure = composable.selectSuggestion {
            closure(composable, suggestion)
        }
    }

}
