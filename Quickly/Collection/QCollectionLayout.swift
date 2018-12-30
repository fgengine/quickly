//
//  Quickly
//

open class QCollectionLayout : UICollectionViewLayout, IQCollectionLayout {

    private var _observer: QObserver< IQCollectionLayoutObserver >

    public override init() {
        self._observer = QObserver< IQCollectionLayoutObserver >()
        super.init()
    }

    public required init?(coder: NSCoder) {
        self._observer = QObserver< IQCollectionLayoutObserver >()
        super.init(coder: coder)
    }

    public func addObserver(_ observer: IQCollectionLayoutObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    public func removeObserver(_ observer: IQCollectionLayoutObserver) {
        self._observer.remove(observer)
    }

    open override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    open override func finalizeAnimatedBoundsChange() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    open override func finalizeLayoutTransition() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    internal func notifyUpdate(contentSize: CGSize) {
        self._observer.notify({ $0.update(self, contentSize: contentSize) })
    }

}

open class QCollectionFlowLayout : UICollectionViewFlowLayout, IQCollectionLayout {

    private var _observer: QObserver< IQCollectionLayoutObserver >

    public override init() {
        self._observer = QObserver< IQCollectionLayoutObserver >()
        super.init()
    }

    public required init?(coder: NSCoder) {
        self._observer = QObserver< IQCollectionLayoutObserver >()
        super.init(coder: coder)
    }

    public func addObserver(_ observer: IQCollectionLayoutObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    public func removeObserver(_ observer: IQCollectionLayoutObserver) {
        self._observer.remove(observer)
    }

    open override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    open override func finalizeAnimatedBoundsChange() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    open override func finalizeLayoutTransition() {
        super.finalizeCollectionViewUpdates()
        self.notifyUpdate(contentSize: self.collectionViewContentSize)
    }

    internal func notifyUpdate(contentSize: CGSize) {
        self._observer.notify({ $0.update(self, contentSize: contentSize) })
    }

}
