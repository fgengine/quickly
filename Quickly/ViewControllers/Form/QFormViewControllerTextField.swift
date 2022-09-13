//
//  Quickly
//

import UIKit

open class QFormViewControllerTextField : QFormViewControllerField {
    
    public private(set) var inputView: QDisplayView!
    public var inputEdgeInsets: UIEdgeInsets {
        set(inputEdgeInsets) { self.set(inputEdgeInsets: inputEdgeInsets, animated: false, completion: nil) }
        get { return self._inputEdgeInsets }
    }
    public private(set) var inputTitleView: QLabel!
    public private(set) var inputFieldView: QTextField!
    public var inputFieldHeight: CGFloat {
        set(inputFieldHeight) { self.set(inputFieldHeight: inputFieldHeight, animated: false, completion: nil) }
        get { return self._inputFieldHeight }
    }
    public var inputFieldSpacing: CGFloat {
        set(inputFieldSpacing) { self.set(inputFieldSpacing: inputFieldSpacing, animated: false, completion: nil) }
        get { return self._inputFieldSpacing }
    }
    public private(set) var hintView: QLabel!
    public var hintEdgeInsets: UIEdgeInsets {
        set(hintEdgeInsets) { self.set(hintEdgeInsets: hintEdgeInsets, animated: false, completion: nil) }
        get { return self._hintEdgeInsets }
    }
    public private(set) var errorView: QLabel!
    public var errorEdgeInsets: UIEdgeInsets {
        set(errorEdgeInsets) { self.set(errorEdgeInsets: errorEdgeInsets, animated: false, completion: nil) }
        get { return self._errorEdgeInsets }
    }
    public var errorTextStyle: IQTextStyle
    public var text: String {
        set(value) { self.inputFieldView.unformatText = value }
        get { return self.inputFieldView.unformatText }
    }
    open override var isValid: Bool {
        get {
            self.loadViewIfNeeded()
            return self.inputFieldView.isValid
        }
    }
    
    private var _inputEdgeInsets: UIEdgeInsets
    private var _inputFieldHeight: CGFloat
    private var _inputFieldSpacing: CGFloat
    private var _hintEdgeInsets: UIEdgeInsets
    private var _errorEdgeInsets: UIEdgeInsets
    private var _errorShowed: Bool
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._constraints) }
        didSet { self.view.addConstraints(self._constraints) }
    }
    private var _inputConstraints: [NSLayoutConstraint] = [] {
        willSet { self.inputView.removeConstraints(self._inputConstraints) }
        didSet { self.inputView.addConstraints(self._inputConstraints) }
    }
    private var _inputFieldConstraints: [NSLayoutConstraint] = [] {
        willSet { self.inputFieldView.removeConstraints(self._inputFieldConstraints) }
        didSet { self.inputFieldView.addConstraints(self._inputFieldConstraints) }
    }
    
    public init(errorTextStyle: IQTextStyle) {
        self.errorTextStyle = errorTextStyle
        self._inputEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self._inputFieldHeight = 50
        self._inputFieldSpacing = 8
        self._hintEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self._errorEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self._errorShowed = false
        super.init()
    }

    open override func didLoad() {
        super.didLoad()
        
        self.inputView = QDisplayView(frame: CGRect.zero)
        self.inputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.inputView)
        
        self.inputTitleView = QLabel(frame: CGRect.zero)
        self.inputTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.inputView.addSubview(self.inputTitleView)
        
        self.inputFieldView = QTextField(frame: CGRect.zero)
        self.inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        self.inputFieldView.onEditing = { [weak self] _ in self?._editing() }
        self.inputFieldView.onPressedClear = { [weak self] _ in self?._pressedClear() }
        self.inputFieldView.onPressedReturn = { [weak self] _ in self?._pressedReturn() }
        self.inputView.addSubview(self.inputFieldView)
        
        self.hintView = QLabel(frame: CGRect.zero)
        self.hintView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.hintView)
        
        self.errorView = QLabel(frame: CGRect.zero)
        self.errorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.errorView)
        
        self._relayout()
    }
    
    open override func beginEditing() {
        self.inputFieldView.beginEditing()
    }
    
    open func editing(text: String) {
    }
    
    open override func showError() {
        guard let validator = self.inputFieldView.validator else { return }
        let errors = validator.validate(self.inputFieldView.unformatText).errors
        self._showError(text: errors.joined(separator: "\n"))
    }
    
    public func set(inputEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._inputEdgeInsets != inputEdgeInsets {
            self._inputEdgeInsets = inputEdgeInsets
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    public func set(inputFieldHeight: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._inputFieldHeight != inputFieldHeight {
            self._inputFieldHeight = inputFieldHeight
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    public func set(inputFieldSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._inputFieldSpacing != inputFieldSpacing {
            self._inputFieldSpacing = inputFieldSpacing
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    public func set(hintEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._hintEdgeInsets != hintEdgeInsets {
            self._hintEdgeInsets = hintEdgeInsets
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    public func set(errorEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._errorEdgeInsets != errorEdgeInsets {
            self._errorEdgeInsets = errorEdgeInsets
            self._relayout(animated: animated, completion: completion)
        }
    }
    
}

// MARK: Private

private extension QFormViewControllerTextField {
    
    func _relayout(animated: Bool, completion: (() -> Swift.Void)?) {
        self._relayout()
        if animated == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.hintView.alpha = self._errorShowed == true ? 0 : 1
                self.errorView.alpha = self._errorShowed == true ? 1 : 0
            }, completion: { _ in
                completion?()
            })
        } else {
            completion?()
        }
    }

    func _relayout() {
        if self._errorShowed == true {
            self._constraints = [
                self.inputView.topLayout == self.view.topLayout,
                self.inputView.leadingLayout == self.view.leadingLayout,
                self.inputView.trailingLayout == self.view.trailingLayout,
                self.errorView.topLayout == self.inputView.bottomLayout.offset(self._errorEdgeInsets.top),
                self.errorView.leadingLayout == self.view.leadingLayout.offset(self._errorEdgeInsets.left),
                self.errorView.trailingLayout == self.view.trailingLayout.offset(-self._errorEdgeInsets.right),
                self.errorView.bottomLayout <= self.view.bottomLayout.offset(-self._errorEdgeInsets.bottom),
                self.hintView.topLayout == self.errorView.bottomLayout.offset(self._hintEdgeInsets.top),
                self.hintView.leadingLayout == self.view.leadingLayout.offset(self._hintEdgeInsets.left),
                self.hintView.trailingLayout == self.view.trailingLayout.offset(-self._hintEdgeInsets.right)
            ]
        } else {
            self._constraints = [
                self.inputView.topLayout == self.view.topLayout,
                self.inputView.leadingLayout == self.view.leadingLayout,
                self.inputView.trailingLayout == self.view.trailingLayout,
                self.hintView.topLayout == self.inputView.bottomLayout.offset(self._hintEdgeInsets.top),
                self.hintView.leadingLayout == self.view.leadingLayout.offset(self._hintEdgeInsets.left),
                self.hintView.trailingLayout == self.view.trailingLayout.offset(-self._hintEdgeInsets.right),
                self.hintView.bottomLayout <= self.view.bottomLayout.offset(-self._hintEdgeInsets.bottom),
                self.errorView.topLayout == self.hintView.bottomLayout.offset(self._errorEdgeInsets.top),
                self.errorView.leadingLayout == self.view.leadingLayout.offset(self._errorEdgeInsets.left),
                self.errorView.trailingLayout == self.view.trailingLayout.offset(-self._errorEdgeInsets.right)
            ]
        }
        self._inputConstraints = [
            self.inputTitleView.topLayout == self.inputView.topLayout.offset(self._inputEdgeInsets.top),
            self.inputTitleView.leadingLayout == self.inputView.leadingLayout.offset(self._inputEdgeInsets.left),
            self.inputTitleView.trailingLayout == self.inputView.trailingLayout.offset(-self._inputEdgeInsets.right),
            self.inputFieldView.topLayout == self.inputTitleView.bottomLayout.offset(self._inputFieldSpacing),
            self.inputFieldView.leadingLayout == self.inputView.leadingLayout.offset(self._inputEdgeInsets.left),
            self.inputFieldView.trailingLayout == self.inputView.trailingLayout.offset(-self._inputEdgeInsets.right),
            self.inputFieldView.bottomLayout == self.inputView.bottomLayout.offset(-self._inputEdgeInsets.bottom)
        ]
        self._inputFieldConstraints = [
            self.inputFieldView.heightLayout == self._inputFieldHeight
        ]
    }
    
    func _editing() {
        self.editing(text: self.inputFieldView.unformatText)
        self._hideError()
    }
    
    func _pressedClear() {
    }

    func _pressedReturn() {
        self.delegate?.continue(field: self)
    }
    
    func _showError(text: String) {
        self.errorView.text = QAttributedText(text: text, style: self.errorTextStyle)
        if self._errorShowed == false {
            self._errorShowed = true
            self._relayout(animated: true, completion: nil)
        }
    }
    
    func _hideError() {
        if self._errorShowed == true {
            self._errorShowed = false
            self._relayout(animated: true, completion: nil)
        }
    }

}
