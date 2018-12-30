//
//  Quickly
//

open class QCompositionViewController< Composition: IQComposition > : QViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController {

    #if DEBUG
    open override var logging: Bool {
        get { return true }
    }
    #endif
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }
    public var screenLeftInset: CGFloat = 0
    public var screenRightInset: CGFloat = 0
    public private(set) lazy var composition: Composition = {
        let composition = Composition(frame: self.view.bounds, owner: self)
        composition.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(composition.contentView)
        self._updateConstraints(self.view, composition.contentView)
        return composition
    }()
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._constraints) }
        didSet { self.view.addConstraints(self._constraints) }
    }
    
    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self)
    }
    
    open override func didChangeAdditionalEdgeInsets() {
        if self.isLoaded == true {
            self._updateConstraints(self.view, self.composition.contentView)
        }
    }
    
}

extension QCompositionViewController {
    
    private func _updateConstraints(_ view: UIView, _ contentView: UIView) {
        let edgeInsets = self.inheritedEdgeInsets
        self._constraints = [
            contentView.topLayout == view.topLayout + edgeInsets.top,
            contentView.leadingLayout == view.leadingLayout + edgeInsets.left,
            contentView.trailingLayout == view.trailingLayout - edgeInsets.right,
            contentView.bottomLayout == view.bottomLayout - edgeInsets.bottom
        ]
    }

}

extension QCompositionViewController : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.view.bounds.size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.screenLeftInset }
    }
    open var containerRightInset: CGFloat {
        get { return self.screenRightInset }
    }
    
}

extension QCompositionViewController : IQTextFieldObserver {
    
    open func beginEditing(textField: QTextField) {
    }
    
    open func editing(textField: QTextField) {
    }
    
    open func endEditing(textField: QTextField) {
    }
    
    open func pressedClear(textField: QTextField) {
    }
    
    open func pressedReturn(textField: QTextField) {
    }
    
}

extension QCompositionViewController : IQListFieldObserver {
    
    open func beginEditing(listField: QListField) {
    }
    
    open func select(listField: QListField, row: QListFieldPickerRow) {
    }
    
    open func endEditing(listField: QListField) {
    }
    
}

extension QCompositionViewController : IQDateFieldObserver {
    
    open func beginEditing(dateField: QDateField) {
    }
    
    open func select(dateField: QDateField, date: Date) {
    }
    
    open func endEditing(dateField: QDateField) {
    }
    
}

