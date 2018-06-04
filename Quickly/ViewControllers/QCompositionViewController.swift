//
//  Quickly
//

open class QCompositionViewController< CompositionType: IQComposition > : QViewController, IQStackContentViewController, IQPageContentViewController {

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
    public private(set) lazy var composition: CompositionType = self._prepareComposition()

    open override func layout(bounds: CGRect) {
        self.composition.contentView.frame = bounds
    }

    private func _prepareComposition() -> CompositionType {
        return CompositionType(contentView: self.view)
    }

}

