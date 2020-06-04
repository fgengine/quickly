//
//  Quickly
//

open class QFormViewControllerMultiTextField : QFormViewControllerField {
    
    public private(set) lazy var inputView: QDisplayView = {
        let view = QDisplayView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    public var inputEdgeInsets: UIEdgeInsets {
        set(inputEdgeInsets) { self.set(inputEdgeInsets: inputEdgeInsets, animated: false, completion: nil) }
        get { return self._inputEdgeInsets }
    }
    public private(set) lazy var inputTitleView: QLabel = {
        let view = QLabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.inputView.addSubview(view)
        return view
    }()
    public private(set) lazy var inputFieldView: QMultiTextField = {
        let view = QMultiTextField(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onShouldBeginEditing = { [weak self] textField -> Bool in return self?.fieldShouldBeginEditing() ?? true }
        view.onBeginEditing = { [weak self] textField in self?.fieldBeginEditing() }
        view.onEditing = { [weak self] textField in self?.fieldEditing() }
        view.onShouldEndEditing = { [weak self] textField -> Bool in return self?.fieldShouldEndEditing() ?? true }
        view.onEndEditing = { [weak self] textField in self?.fieldEndEditing() }
        view.onChangedHeight = { [weak self] textField in self?._fieldChangedHeight() }
        self.inputView.addSubview(view)
        return view
    }()
    public var inputFieldSpacing: CGFloat {
        set(inputFieldSpacing) { self.set(inputFieldSpacing: inputFieldSpacing, animated: false, completion: nil) }
        get { return self._inputFieldSpacing }
    }
    public private(set) lazy var hintView: QLabel = {
        let view = QLabel(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    public var hintEdgeInsets: UIEdgeInsets {
        set(hintEdgeInsets) { self.set(hintEdgeInsets: hintEdgeInsets, animated: false, completion: nil) }
        get { return self._hintEdgeInsets }
    }
    open var text: String {
        set(value) { self.inputFieldView.unformatText = value }
        get { return self.inputFieldView.unformatText }
    }
    open override var isValid: Bool {
        get { return self.inputFieldView.isValid }
    }
    
    private var _inputEdgeInsets: UIEdgeInsets
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
    private var _inputFieldHeightConstraint: NSLayoutConstraint? {
        willSet {
            guard let constraint = self._inputFieldHeightConstraint else { return }
            self.inputFieldView.removeConstraint(constraint)
        }
        didSet {
            guard let constraint = self._inputFieldHeightConstraint else { return }
            self.inputFieldView.addConstraint(constraint)
        }
    }
    
    public override init() {
        self._inputEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self._inputFieldSpacing = 8
        self._hintEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }

    open override func didLoad() {
        super.didLoad()
        
        self._relayout()
    }
    
    open override func beginEditing() {
        self.inputFieldView.beginEditing()
    }
    
    open override func endEditing() {
        self.inputFieldView.endEditing(false)
    }
    
    open func fieldShouldBeginEditing() -> Bool {
        return true
    }
    
    open func fieldBeginEditing() {
    }
    
    open func fieldEditing() {
    }
    
    open func fieldShouldEndEditing() -> Bool {
        return true
    }
    
    open func fieldEndEditing() {
    }
    
    public func set(inputEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._inputEdgeInsets != inputEdgeInsets {
            self._inputEdgeInsets = inputEdgeInsets
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

private extension QFormViewControllerMultiTextField {
    
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
        self._inputFieldHeightConstraint = self.inputFieldView.heightLayout == self.inputFieldView.textHeight
    }
    
    func _fieldChangedHeight() {
        self._inputFieldHeightConstraint?.constant = self.inputFieldView.textHeight
    }

}
