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

    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self, backgroundColor: .clear)
    }

    open override func layout(bounds: CGRect) {
        self.composition.contentView.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.inheritedEdgeInsets)
    }

    private func _prepareComposition() -> Composition {
        let composition = Composition(frame: UIEdgeInsetsInsetRect(self.view.bounds, self.inheritedEdgeInsets))
        self.view.addSubview(composition.contentView)
        return composition
    }

}

