//
//  Quickly
//

#if os(iOS)

    open class QCollectionView : UICollectionView, IQView {

        public typealias CollectionLayoutType = UICollectionViewLayout & IQCollectionLayout

        public var collectionController: IQCollectionController? {
            willSet {
                self.delegate = nil
                self.dataSource = nil
                if let collectionController = self.collectionController {
                    collectionController.collectionView = nil
                }
            }
            didSet {
                self.delegate = self.collectionController
                self.dataSource = self.collectionController
                if let collectionController = self.collectionController {
                    collectionController.collectionView = self
                }
            }
        }
        public var collectionLayout: CollectionLayoutType? {
            didSet {
                if let collectionLayout = self.collectionLayout {
                    self.collectionViewLayout = collectionLayout
                } else {
                    self.collectionViewLayout = UICollectionViewLayout()
                }
            }
        }

        public init(frame: CGRect) {
            super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
            self.setup()
        }

        public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
            super.init(frame: frame, collectionViewLayout: collectionViewLayout)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        open func setup() {
            self.backgroundColor = UIColor.clear
        }

    }

#endif
