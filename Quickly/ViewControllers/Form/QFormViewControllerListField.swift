//
//  Quickly
//

import UIKit

open class QFormViewControllerListField : QFormViewControllerField {
    
    public private(set) var inputView: QDisplayView!
    public var inputEdgeInsets: UIEdgeInsets {
        set(inputEdgeInsets) { self.set(inputEdgeInsets: inputEdgeInsets, animated: false, completion: nil) }
        get { return self._inputEdgeInsets }
    }
    public private(set) var inputTitleView: QLabel!
    public private(set) var inputFieldView: QListField!
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
    open var selectedRow: QListFieldPickerRow? {
        set(value) { self.inputFieldView.selectedRow = value }
        get { return self.inputFieldView.selectedRow }
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
    
    public override init() {
        self._inputEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self._inputFieldHeight = 50
        self._inputFieldSpacing = 8
        self._hintEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }

    open override func didLoad() {
        super.didLoad()
        
        self.inputView = QDisplayView(frame: CGRect.zero)
        self.inputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.inputView)
        
        self.inputTitleView = QLabel(frame: CGRect.zero)
        self.inputTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.inputView.addSubview(self.inputTitleView)
        
        self.inputFieldView = QListField(frame: CGRect.zero)
        self.inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        self.inputFieldView.onSelect = { [weak self] _, row in self?.select(row: row) }
        self.inputView.addSubview(self.inputFieldView)
        
        self.hintView = QLabel(frame: CGRect.zero)
        self.hintView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.hintView)
        
        self._relayout()
    }
    
    open override func beginEditing() {
        self.inputFieldView.beginEditing()
    }
    
    open func select(row: QListFieldPickerRow) {
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
    
}

// MARK: Private

private extension QFormViewControllerListField {
    
    func _relayout(animated: Bool, completion: (() -> Swift.Void)?) {
        self._relayout()
        if animated == true {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                completion?()
            })
        } else {
            completion?()
        }
    }

    func _relayout() {
        self._constraints = [
            self.inputView.topLayout == self.view.topLayout,
            self.inputView.leadingLayout == self.view.leadingLayout,
            self.inputView.trailingLayout == self.view.trailingLayout,
            self.hintView.topLayout == self.inputView.bottomLayout.offset(self.hintEdgeInsets.top),
            self.hintView.leadingLayout == self.view.leadingLayout.offset(self.hintEdgeInsets.left),
            self.hintView.trailingLayout == self.view.trailingLayout.offset(-self.hintEdgeInsets.right),
            self.hintView.bottomLayout <= self.view.bottomLayout.offset(-self.hintEdgeInsets.bottom)
        ]
        self._inputConstraints = [
            self.inputTitleView.topLayout == self.inputView.topLayout.offset(self.inputEdgeInsets.top),
            self.inputTitleView.leadingLayout == self.inputView.leadingLayout.offset(self.inputEdgeInsets.left),
            self.inputTitleView.trailingLayout == self.inputView.trailingLayout.offset(-self.inputEdgeInsets.right),
            self.inputFieldView.topLayout == self.inputTitleView.bottomLayout.offset(self.inputFieldSpacing),
            self.inputFieldView.leadingLayout == self.inputView.leadingLayout.offset(self.inputEdgeInsets.left),
            self.inputFieldView.trailingLayout == self.inputView.trailingLayout.offset(-self.inputEdgeInsets.right),
            self.inputFieldView.bottomLayout == self.inputView.bottomLayout.offset(-self.inputEdgeInsets.bottom)
        ]
        self._inputFieldConstraints = [
            self.inputFieldView.heightLayout == self._inputFieldHeight
        ]
    }

}
