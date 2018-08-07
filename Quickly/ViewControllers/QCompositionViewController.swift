//
//  Quickly
//

open class QCompositionViewController< Composition: IQComposition > : QViewController, IQStackContentViewController, IQPageContentViewController {

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
    public private(set) lazy var composition: Composition = self._prepareComposition()

    open override func layout(bounds: CGRect) {
        self.composition.contentView.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.inheritedEdgeInsets)
    }

    private func _prepareComposition() -> Composition {
        let composition = Composition(frame: UIEdgeInsetsInsetRect(self.view.bounds, self.inheritedEdgeInsets), delegate: self)
        self.view.addSubview(composition.contentView)
        return composition
    }

}

extension QCompositionViewController : IQCompositionDelegate {
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

