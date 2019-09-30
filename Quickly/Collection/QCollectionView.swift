//
//  Quickly
//

open class QCollectionView : UICollectionView, IQView {

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
    open override var refreshControl: UIRefreshControl? {
        set(value) {
            if #available(iOS 10, *) {
                super.refreshControl = value
            } else {
                self._refreshControl = value
            }
        }
        get {
            if #available(iOS 10, *) {
                return super.refreshControl
            } else {
                return self._refreshControl
            }
        }
    }
    open var contentLeftInset: CGFloat = 0
    open var contentRightInset: CGFloat = 0

    private var _refreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self._refreshControl else { return }
            self.addSubview(refreshControl)
        }
        didSet {
            guard let refreshControl = self._refreshControl else { return }
            refreshControl.removeFromSuperview()
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        self.setup()
    }

    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.setup()
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    @available(iOS 11.0, *)
    open override func adjustedContentInsetDidChange() {
        super.adjustedContentInsetDidChange()
    }

}

extension QCollectionView : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.bounds.inset(by: self.contentInset).size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.contentLeftInset }
    }
    open var containerRightInset: CGFloat {
        get { return self.contentRightInset }
    }
    
}
