//
//  Quickly
//

open class QFormViewController : QViewController, IQFormViewController, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController, IQJalousieContentViewController {
    
    public var fields: [IQFormViewControllerField] {
        set(fields) {
            if fields.contains(where: { return $0 === self._currentField }) == true {
                self.set(fields: fields, currentField: self._currentField, animated: false, completion: nil)
            } else {
                self.set(fields: fields, currentField: fields.first, animated: false, completion: nil)
            }
        }
        get { return self._fields }
    }
    public var currentField: IQFormViewControllerField? {
        set(currentField) { self.set(currentField: currentField, animated: false, completion: nil) }
        get { return self._currentField }
    }
    public private(set) lazy var toolbarView: QDisplayView = {
        let view = QDisplayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    public var toolbarEdgeInsets: UIEdgeInsets {
        set(toolbarEdgeInsets) { self.set(toolbarEdgeInsets: toolbarEdgeInsets, animated: false, completion: nil) }
        get { return self._toolbarEdgeInsets }
    }
    public private(set) lazy var toolbarProgressTitleView: QLabel = {
        let view = QLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.toolbarView.addSubview(view)
        return view
    }()
    public private(set) lazy var toolbarProgressView: QProgressViewType = {
        let view = QProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.toolbarView.addSubview(view)
        return view
    }()
    public var toolbarProgressHeight: CGFloat {
        set(toolbarProgressHeight) { self.set(toolbarProgressHeight: toolbarProgressHeight, animated: false, completion: nil) }
        get { return self._toolbarProgressHeight }
    }
    public var toolbarProgressSpacing: CGFloat {
        set(toolbarProgressSpacing) { self.set(toolbarProgressSpacing: toolbarProgressSpacing, animated: false, completion: nil) }
        get { return self._toolbarProgressSpacing }
    }
    public private(set) lazy var toolbarPrevView: QButton = {
        let view = QButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(horizontal: .required, vertical: .defaultHigh)
        view.onPressed = { [weak self] _ in self?._pressedPrev() }
        self.toolbarView.addSubview(view)
        return view
    }()
    public var toolbarPrevSpacing: CGFloat {
        set(toolbarPrevSpacing) { self.set(toolbarPrevSpacing: toolbarPrevSpacing, animated: false, completion: nil) }
        get { return self._toolbarPrevSpacing }
    }
    public private(set) lazy var toolbarNextView: QButton = {
        let view = QButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(horizontal: .required, vertical: .defaultHigh)
        view.onPressed = { [weak self] _ in self?._pressedNext() }
        self.toolbarView.addSubview(view)
        return view
    }()
    public var toolbarNextSpacing: CGFloat {
        set(toolbarNextSpacing) { self.set(toolbarNextSpacing: toolbarNextSpacing, animated: false, completion: nil) }
        get { return self._toolbarNextSpacing }
    }
    public private(set) lazy var toolbarDoneView: QButton = {
        let view = QButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(horizontal: .required, vertical: .defaultHigh)
        view.onPressed = { [weak self] _ in self?._pressedDone() }
        self.toolbarView.addSubview(view)
        return view
    }()
    public var toolbarDoneSpacing: CGFloat {
        set(toolbarDoneSpacing) { self.set(toolbarDoneSpacing: toolbarDoneSpacing, animated: false, completion: nil) }
        get { return self._toolbarDoneSpacing }
    }
    
    private var _viewConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._viewConstraints) }
        didSet { self.view.addConstraints(self._viewConstraints) }
    }
    private var _fields: [IQFormViewControllerField]
    private var _currentField: IQFormViewControllerField?
    private var _toolbarEdgeInsets: UIEdgeInsets
    private var _toolbarProgressHeight: CGFloat
    private var _toolbarProgressSpacing: CGFloat
    private var _toolbarPrevSpacing: CGFloat
    private var _toolbarNextSpacing: CGFloat
    private var _toolbarDoneSpacing: CGFloat
    private var _toolbarConstraints: [NSLayoutConstraint] = [] {
        willSet { self.toolbarView.removeConstraints(self._toolbarConstraints) }
        didSet { self.toolbarView.addConstraints(self._toolbarConstraints) }
    }
    private var _toolbarProgressConstraints: [NSLayoutConstraint] = [] {
        willSet { self.toolbarProgressView.removeConstraints(self._toolbarProgressConstraints) }
        didSet { self.toolbarProgressView.addConstraints(self._toolbarProgressConstraints) }
    }
    private lazy var _keyboard: QKeyboard = QKeyboard()
    private var _keyboardHeight: CGFloat
    
    @available(iOS 10.0, *)
    private lazy var _notificationFeedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    @available(iOS 10.0, *)
    private lazy var _selectionFeedbackGenerator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    public init(
        fields: [IQFormViewControllerField] = [],
        currentField: IQFormViewControllerField? = nil
    ) {
        self._fields = fields
        self._currentField = currentField ?? fields.first
        self._toolbarEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self._keyboardHeight = 0
        self._toolbarProgressHeight = 4
        self._toolbarProgressSpacing = 8
        self._toolbarPrevSpacing = 8
        self._toolbarNextSpacing = 8
        self._toolbarDoneSpacing = 8
        super.init()
    }

    open override func didLoad() {
        super.didLoad()
        if let field = self.currentField {
            self.view.addSubview(field.view)
        }
        self._relayout(animated: false, completion: nil)
        self._updateToolbarProgress(animated: false)
        self._updateToolbarButtonsState()
    }

    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        self._relayout(animated: false, completion: nil)
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._subscribeToKeyboardEvents()
    }
    
    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self._subscribeToKeyboardEvents()
        self.currentField?.beginEditing()
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.currentField?.beginEditing()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.currentField?.endEditing()
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.currentField?.endEditing()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.currentField?.beginEditing()
    }
    
    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self._unsubscribeToKeyboardEvents()
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._unsubscribeToKeyboardEvents()
    }
    
    open func toolbarProgressTitleStyleSheet(current: Int, total: Int) -> QLabelStyleSheet {
        return QLabelStyleSheet(text: QText(
            text: "\(current) / \(total)"
        ))
    }
    
    open func didPressedDone() {
    }
    
    open func set(fields: [IQFormViewControllerField], currentField: IQFormViewControllerField?, animated: Bool, completion: (() -> Swift.Void)?) {
        for field in self._fields {
            field.delegate = nil
        }
        self._fields = fields
        for field in self._fields {
            field.delegate = self
        }
        if fields.contains(where: { return $0 === currentField }) == true {
            self.set(currentField: currentField, animated: animated, completion: completion)
        } else {
            self.set(currentField: fields.first, animated: animated, completion: completion)
        }
    }
    
    open func set(currentField: IQFormViewControllerField?, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._currentField !== currentField {
            let oldField = self._currentField
            self._currentField = currentField
            if self.isLoaded == true {
                self._set(oldField: oldField, newField: currentField, animated: animated, completion: completion)
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    open func set(toolbarEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarEdgeInsets != toolbarEdgeInsets {
            self._toolbarEdgeInsets = toolbarEdgeInsets
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    open func set(toolbarProgressHeight: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarProgressHeight != toolbarProgressHeight {
            self._toolbarProgressHeight = toolbarProgressHeight
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    open func set(toolbarProgressSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarProgressSpacing != toolbarProgressSpacing {
            self._toolbarProgressSpacing = toolbarProgressSpacing
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    open func set(toolbarPrevSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarPrevSpacing != toolbarPrevSpacing {
            self._toolbarPrevSpacing = toolbarPrevSpacing
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    open func set(toolbarNextSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarNextSpacing != toolbarNextSpacing {
            self._toolbarNextSpacing = toolbarNextSpacing
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    open func set(toolbarDoneSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?) {
        if self._toolbarDoneSpacing != toolbarDoneSpacing {
            self._toolbarDoneSpacing = toolbarDoneSpacing
            self._relayout(animated: animated, completion: completion)
        }
    }
    
    // MARK: IQContentViewController
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }
    
    open func notifyBeginUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.beginUpdateContent()
        }
    }
    
    open func notifyUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if let viewController = self.contentOwnerViewController {
            return viewController.finishUpdateContent(velocity: velocity)
        }
        return nil
    }
    
    open func notifyEndUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.endUpdateContent()
        }
    }
    
    // MARK: IQModalContentViewController
    
    open func modalShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQDialogContentViewController
    
    open func dialogDidPressedOutside() {
    }
    
    // MARK: IQHamburgerContentViewController
    
    open func hamburgerShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQJalousieContentViewController
    
    open func jalousieShouldInteractive() -> Bool {
        return true
    }
    
}

// MARK: Private

private extension QFormViewController {
    
    func _subscribeToKeyboardEvents() {
        self._keyboard.add(observer: self, priority: 0)
    }
    
    func _unsubscribeToKeyboardEvents() {
        self._keyboard.remove(observer: self)
    }
    
    func _progress() -> (current: Int, total: Int) {
        if let index = self._fields.firstIndex(where: { return $0 === self._currentField }) {
            return (current: index + 1, total: self._fields.count)
        }
        return (current: 0, total: self._fields.count)
    }
    
    func _index(field: IQFormViewControllerField) -> Int? {
        return self._fields.firstIndex(where: { return $0 === field })
    }
    
    func _prevField() -> IQFormViewControllerField? {
        guard let field = self._currentField, let index = self._index(field: field) else { return nil }
        if index != self._fields.startIndex {
            return self._fields[index - 1]
        }
        return nil
    }

    func _nextField() -> IQFormViewControllerField? {
        guard let field = self._currentField, let index = self._index(field: field) else { return nil }
        if index != self._fields.endIndex - 1 {
            return self._fields[index + 1]
        }
        return nil
    }

    func _isFirstField() -> Bool {
        guard let field = self._currentField, let index = self._index(field: field) else { return false }
        return index == self._fields.startIndex
    }

    func _isLastField() -> Bool {
        guard let field = self._currentField, let index = self._index(field: field) else { return false }
        return index == self._fields.endIndex - 1
    }
    
    func _pressedPrev() {
        if let field = self._prevField() {
            self.set(currentField: field, animated: true, completion: nil)
            if #available(iOS 10.0, *) {
                self._selectionFeedbackGenerator.selectionChanged()
            }
        }
    }
    
    func _pressedNext() {
        if let field = self._currentField {
            if field.isValid == false {
                field.showError()
                if #available(iOS 10.0, *) {
                    self._notificationFeedbackGenerator.notificationOccurred(.error)
                }
                return
            }
        }
        if let field = self._nextField() {
            self.set(currentField: field, animated: true, completion: nil)
            if #available(iOS 10.0, *) {
                self._selectionFeedbackGenerator.selectionChanged()
            }
        }
    }
    
    func _pressedDone() {
        for field in self._fields {
            if field.isValid == false {
                self.set(currentField: field, animated: true, completion: { field.showError() })
                if #available(iOS 10.0, *) {
                    self._notificationFeedbackGenerator.notificationOccurred(.error)
                }
                return
            }
        }
        if #available(iOS 10.0, *) {
            self._notificationFeedbackGenerator.notificationOccurred(.success)
        }
        self.didPressedDone()
    }
    
    func _set(keyboardHeight: CGFloat, animationInfo: QKeyboardAnimationInfo) {
        if self._keyboardHeight != keyboardHeight {
            self._keyboardHeight = keyboardHeight
            
            let edgeInsets = self.inheritedEdgeInsets
            if let currentField = self._currentField {
                self._relayoutContent(edgeInsets: edgeInsets, currentField: currentField)
            } else {
                self._relayoutContent(edgeInsets: edgeInsets)
            }
            self._relayoutToolbar(edgeInsets: edgeInsets)
            UIView.animate(withDuration: animationInfo.duration, delay: 0, options: animationInfo.animationOptions([]), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func _set(oldField: IQFormViewControllerField?, newField: IQFormViewControllerField?, animated: Bool, completion: (() -> Swift.Void)?) {
        let edgeInsets = self.inheritedEdgeInsets
        if self.isPresented == true && animated == true {
            if let oldField = oldField, let newField = newField {
                newField.view.alpha = 0
                self.view.insertSubview(newField.view, belowSubview: oldField.view)
                if let oldIndex = self._index(field: oldField), let newIndex = self._index(field: newField) {
                    if newIndex > oldIndex {
                        self._relayoutContent(edgeInsets: edgeInsets, currentField: oldField, newField: newField)
                        self.layoutIfNeeded()
                        self._relayoutContent(edgeInsets: edgeInsets, currentField: newField, oldField: oldField)
                    } else {
                        self._relayoutContent(edgeInsets: edgeInsets, currentField: oldField, oldField: newField)
                        self.layoutIfNeeded()
                        self._relayoutContent(edgeInsets: edgeInsets, currentField: newField, newField: oldField)
                    }
                } else {
                    self._relayoutContent(edgeInsets: edgeInsets, currentField: oldField, newField: newField)
                    self.layoutIfNeeded()
                    self._relayoutContent(edgeInsets: edgeInsets, currentField: newField, oldField: oldField)
                }
                self._relayoutToolbar(edgeInsets: edgeInsets)
                UIView.animate(withDuration: 0.2, animations: {
                    oldField.view.alpha = 0
                    newField.view.alpha = 1
                    self._updateToolbarButtonsState()
                    self._updateToolbarProgress(animated: animated)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    newField.beginEditing()
                    oldField.endEditing()
                    oldField.view.removeFromSuperview()
                    completion?()
                })
            } else if let newField = newField {
                newField.view.alpha = 0
                self.view.addSubview(newField.view)
                self._relayoutContent(edgeInsets: edgeInsets, currentField: newField)
                self.layoutIfNeeded()
                self._relayoutToolbar(edgeInsets: edgeInsets)
                UIView.animate(withDuration: 0.2, animations: {
                    newField.view.alpha = 1
                    self._updateToolbarButtonsState()
                    self._updateToolbarProgress(animated: animated)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    newField.beginEditing()
                    completion?()
                })
            } else if let oldField = oldField {
                self._relayoutToolbar(edgeInsets: edgeInsets)
                oldField.endEditing()
                UIView.animate(withDuration: 0.2, animations: {
                    oldField.view.alpha = 0
                    self._updateToolbarButtonsState()
                    self._updateToolbarProgress(animated: animated)
                }, completion: { [weak self] _ in
                    oldField.endEditing()
                    oldField.view.removeFromSuperview()
                    if let self = self {
                        self._relayoutContent(edgeInsets: edgeInsets)
                    }
                    completion?()
                })
            }
        } else {
            if let field = newField {
                self.view.addSubview(field.view)
                self._relayoutContent(edgeInsets: edgeInsets, currentField: field)
                self._relayoutToolbar(edgeInsets: edgeInsets)
                self._updateToolbarProgress(animated: animated)
                self._updateToolbarButtonsState()
                if self.isPresented == true {
                    field.beginEditing()
                }
            } else {
                self._relayoutContent(edgeInsets: edgeInsets)
                self._relayoutToolbar(edgeInsets: edgeInsets)
                self._updateToolbarProgress(animated: animated)
                self._updateToolbarButtonsState()
            }
            if let field = oldField {
                field.view.removeFromSuperview()
                if self.isPresented == true {
                    field.endEditing()
                }
            }
            completion?()
        }
    }
    
    func _relayout(animated: Bool, completion: (() -> Swift.Void)?) {
        let edgeInsets = self.inheritedEdgeInsets
        if let currentField = self._currentField {
            self._relayoutContent(edgeInsets: edgeInsets, currentField: currentField)
        } else {
            self._relayoutContent(edgeInsets: edgeInsets)
        }
        self._relayoutToolbar(edgeInsets: edgeInsets)
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
    
    func _relayoutContent(edgeInsets: UIEdgeInsets) {
        self._viewConstraints = [
            self.toolbarView.leadingLayout == self.view.leadingLayout,
            self.toolbarView.trailingLayout == self.view.trailingLayout,
            self.toolbarView.bottomLayout == self.view.bottomLayout
        ]
    }
    
    func _relayoutContent(edgeInsets: UIEdgeInsets, currentField: IQFormViewControllerField) {
        self._viewConstraints = [
            currentField.view.topLayout == self.view.topLayout.offset(edgeInsets.top),
            currentField.view.leadingLayout == self.view.leadingLayout.offset(edgeInsets.left),
            currentField.view.trailingLayout == self.view.trailingLayout.offset(-edgeInsets.right),
            currentField.view.bottomLayout == self.toolbarView.topLayout,
            self.toolbarView.leadingLayout == self.view.leadingLayout,
            self.toolbarView.trailingLayout == self.view.trailingLayout,
            self.toolbarView.bottomLayout == self.view.bottomLayout
        ]
    }
    
    func _relayoutContent(edgeInsets: UIEdgeInsets, currentField: IQFormViewControllerField, newField: IQFormViewControllerField) {
        self._viewConstraints = [
            currentField.view.topLayout == self.view.topLayout.offset(edgeInsets.top),
            currentField.view.leadingLayout == self.view.leadingLayout.offset(edgeInsets.left),
            currentField.view.trailingLayout == self.view.trailingLayout.offset(-edgeInsets.right),
            currentField.view.bottomLayout == self.toolbarView.topLayout,
            newField.view.topLayout == currentField.view.bottomLayout,
            newField.view.leadingLayout == self.view.leadingLayout.offset(edgeInsets.left),
            newField.view.trailingLayout == self.view.trailingLayout.offset(-edgeInsets.right),
            newField.view.heightLayout == currentField.view.heightLayout,
            self.toolbarView.leadingLayout == self.view.leadingLayout,
            self.toolbarView.trailingLayout == self.view.trailingLayout,
            self.toolbarView.bottomLayout == self.view.bottomLayout
        ]
    }
    
    func _relayoutContent(edgeInsets: UIEdgeInsets, currentField: IQFormViewControllerField, oldField: IQFormViewControllerField) {
        self._viewConstraints = [
            currentField.view.topLayout == self.view.topLayout.offset(edgeInsets.top),
            currentField.view.leadingLayout == self.view.leadingLayout.offset(edgeInsets.left),
            currentField.view.trailingLayout == self.view.trailingLayout.offset(-edgeInsets.right),
            currentField.view.bottomLayout == self.toolbarView.topLayout,
            oldField.view.leadingLayout == self.view.leadingLayout.offset(edgeInsets.left),
            oldField.view.trailingLayout == self.view.trailingLayout.offset(-edgeInsets.right),
            oldField.view.bottomLayout == currentField.view.topLayout,
            oldField.view.heightLayout == currentField.view.heightLayout,
            self.toolbarView.leadingLayout == self.view.leadingLayout,
            self.toolbarView.trailingLayout == self.view.trailingLayout,
            self.toolbarView.bottomLayout == self.view.bottomLayout
        ]
    }
    
    func _updateToolbarProgress(animated: Bool) {
        let progress = self._progress()
        self.toolbarProgressTitleView.apply(self.toolbarProgressTitleStyleSheet(current: progress.current, total: progress.total))
        self.toolbarProgressView.setProgress(CGFloat(progress.current) / CGFloat(progress.total), animated: animated)
    }
    
    func _updateToolbarButtonsState() {
        let isFirst = self._isFirstField()
        let isLast = self._isLastField()
        let isMany = self._fields.count > 1
        self.toolbarDoneView.alpha = isLast == true ? 1 : 0
        self.toolbarPrevView.alpha = isFirst == false && isMany == true ? 1 : 0
        self.toolbarNextView.alpha = isLast == false && isMany == true ? 1 : 0
    }
    
    func _relayoutToolbar(edgeInsets: UIEdgeInsets) {
        let normalizedEdgeInsets = UIEdgeInsets(
            top: self._toolbarEdgeInsets.top,
            left: edgeInsets.left + self._toolbarEdgeInsets.left + edgeInsets.left,
            bottom: max(edgeInsets.bottom, self._keyboardHeight) + self._toolbarEdgeInsets.bottom,
            right: edgeInsets.right + self._toolbarEdgeInsets.right + edgeInsets.right
        )
        let isFirst = self._isFirstField()
        let isLast = self._isLastField()
        let isMany = self._fields.count > 1
        var constraints: [NSLayoutConstraint] = [
            self.toolbarProgressTitleView.topLayout == self.toolbarView.topLayout.offset(normalizedEdgeInsets.top),
            self.toolbarProgressTitleView.leadingLayout == self.toolbarView.leadingLayout.offset(normalizedEdgeInsets.left),
            self.toolbarProgressView.topLayout == self.toolbarProgressTitleView.bottomLayout.offset(self._toolbarProgressSpacing),
            self.toolbarProgressView.leadingLayout == self.toolbarView.leadingLayout.offset(normalizedEdgeInsets.left),
            self.toolbarProgressView.trailingLayout == self.toolbarProgressTitleView.trailingLayout,
            self.toolbarProgressView.bottomLayout == self.toolbarView.bottomLayout.offset(-normalizedEdgeInsets.bottom),
            self.toolbarPrevView.topLayout == self.toolbarView.topLayout.offset(normalizedEdgeInsets.top),
            self.toolbarPrevView.bottomLayout == self.toolbarView.bottomLayout.offset(-normalizedEdgeInsets.bottom),
            self.toolbarNextView.topLayout == self.toolbarView.topLayout.offset(normalizedEdgeInsets.top),
            self.toolbarNextView.trailingLayout == self.toolbarView.trailingLayout.offset(-normalizedEdgeInsets.right),
            self.toolbarNextView.bottomLayout == self.toolbarView.bottomLayout.offset(-normalizedEdgeInsets.bottom),
            self.toolbarDoneView.topLayout == self.toolbarView.topLayout.offset(normalizedEdgeInsets.top),
            self.toolbarDoneView.bottomLayout == self.toolbarView.bottomLayout.offset(-normalizedEdgeInsets.bottom),
            self.toolbarDoneView.trailingLayout == self.toolbarView.trailingLayout.offset(-normalizedEdgeInsets.right)
        ]
        if isLast == true && isMany == false {
            constraints.append(contentsOf: [
                self.toolbarProgressTitleView.trailingLayout == self.toolbarDoneView.leadingLayout.offset(-self._toolbarDoneSpacing),
                self.toolbarPrevView.trailingLayout == self.toolbarNextView.leadingLayout.offset(-self._toolbarNextSpacing)
            ])
        } else if isLast == true && isMany == true {
            constraints.append(contentsOf: [
                self.toolbarProgressTitleView.trailingLayout == self.toolbarPrevView.leadingLayout.offset(-self._toolbarPrevSpacing),
                self.toolbarPrevView.trailingLayout == self.toolbarDoneView.leadingLayout.offset(-self._toolbarDoneSpacing),
            ])
        } else if isFirst == true && isMany == true {
            constraints.append(contentsOf: [
                self.toolbarProgressTitleView.trailingLayout == self.toolbarNextView.leadingLayout.offset(-self._toolbarNextSpacing),
                self.toolbarPrevView.trailingLayout == self.toolbarNextView.leadingLayout.offset(-self._toolbarNextSpacing)
            ])
        } else {
            constraints.append(contentsOf: [
                self.toolbarProgressTitleView.trailingLayout == self.toolbarPrevView.leadingLayout.offset(-self._toolbarPrevSpacing),
                self.toolbarPrevView.trailingLayout == self.toolbarNextView.leadingLayout.offset(-self._toolbarNextSpacing)
            ])
        }
        self._toolbarConstraints = constraints
        self._toolbarProgressConstraints = [
            self.toolbarProgressView.heightLayout == self._toolbarProgressHeight
        ]
    }

}

// MARK: IQKeyboardObserver

extension QFormViewController : IQKeyboardObserver {

    public func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        let keyboardFrame = self.view.convert(animationInfo.endFrame, from: nil).intersection(self.view.bounds)
        self._set(keyboardHeight: keyboardFrame.height, animationInfo: animationInfo)
    }

    public func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

    public func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        let keyboardFrame = self.view.convert(animationInfo.endFrame, from: nil).intersection(self.view.bounds)
        self._set(keyboardHeight: keyboardFrame.height, animationInfo: animationInfo)
    }

    public func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }

}

// MARK: IQFormViewControllerFieldDelegate

extension QFormViewController : IQFormViewControllerFieldDelegate {
    
    public func `continue`(field: IQFormViewControllerField) {
        self._pressedNext()
    }
    
}
