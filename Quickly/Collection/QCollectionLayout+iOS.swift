//
//  Quickly
//

#if os(iOS)

    open class QCollectionLayout : UICollectionViewLayout, IQCollectionLayout {

        private var observer: QObserver< IQCollectionLayoutObserver >

        public override init() {
            self.observer = QObserver< IQCollectionLayoutObserver >()
            super.init()
        }

        public required init?(coder: NSCoder) {
            self.observer = QObserver< IQCollectionLayoutObserver >()
            super.init(coder: coder)
        }

        public func addObserver(_ observer: IQCollectionLayoutObserver) {
            self.observer.add(observer)
        }

        public func removeObserver(_ observer: IQCollectionLayoutObserver) {
            self.observer.remove(observer)
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
            self.observer.notify({ $0.update(self, contentSize: contentSize) })
        }

    }

    open class QCollectionFlowLayout : UICollectionViewFlowLayout, IQCollectionLayout {

        private var observer: QObserver< IQCollectionLayoutObserver >

        public override init() {
            self.observer = QObserver< IQCollectionLayoutObserver >()
            super.init()
        }

        public required init?(coder: NSCoder) {
            self.observer = QObserver< IQCollectionLayoutObserver >()
            super.init(coder: coder)
        }

        public func addObserver(_ observer: IQCollectionLayoutObserver) {
            self.observer.add(observer)
        }

        public func removeObserver(_ observer: IQCollectionLayoutObserver) {
            self.observer.remove(observer)
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
            self.observer.notify({ $0.update(self, contentSize: contentSize) })
        }

    }

#endif

