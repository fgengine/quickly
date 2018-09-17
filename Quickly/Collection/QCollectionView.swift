//
//  Quickly
//

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
                self.collectionViewLayout = QCollectionFlowLayout()
            }
        }
    }
    open override var refreshControl: UIRefreshControl? {
        set(value) {
            if #available(iOS 10, *) {
                super.refreshControl = value
            } else {
                self.legacyRefreshControl = value
            }
        }
        get {
            if #available(iOS 10, *) {
                return super.refreshControl
            } else {
                return self.legacyRefreshControl
            }
        }
    }
    open var contentLeftInset: CGFloat = 0
    open var contentRightInset: CGFloat = 0

    private var legacyRefreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self.legacyRefreshControl else { return }
            self.addSubview(refreshControl)
        }
        didSet {
            guard let refreshControl = self.legacyRefreshControl else { return }
            refreshControl.removeFromSuperview()
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: QCollectionFlowLayout())
        self.setup()
    }

    public init(frame: CGRect, layout: CollectionLayoutType) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setup()
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, layout: QCollectionFlowLayout())
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
        self.backgroundColor = UIColor.clear

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }

}

extension QCollectionView : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return UIEdgeInsetsInsetRect(self.bounds, self.contentInset).size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.contentLeftInset }
    }
    open var containerRightInset: CGFloat {
        get { return self.contentRightInset }
    }
    
}
