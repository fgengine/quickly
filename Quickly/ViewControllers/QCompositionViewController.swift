//
//  Quickly
//

open class QCompositionViewController< CompositionType: IQComposition > : QViewController, IQStackContentViewController {

    open var stackPageViewController: IQStackPageViewController?
    open var stackPageContentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    open var stackPageContentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }

    open lazy var composition: CompositionType = self._prepareComposition()

    private func _prepareComposition() -> CompositionType {
        return CompositionType(contentView: self.view)
    }

}

