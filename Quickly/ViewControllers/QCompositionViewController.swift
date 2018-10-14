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
        let composition = Composition(frame: self.view.bounds.inset(by: self.inheritedEdgeInsets), owner: self)
        self.view.addSubview(composition.contentView)
        return composition
    }()
    
    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self)
    }

    open override func layout(bounds: CGRect) {
        self.composition.contentView.frame = self.view.bounds.inset(by: self.inheritedEdgeInsets)
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

