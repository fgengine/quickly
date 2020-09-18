//
//  Quickly
//

open class QCollectionTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets
    public var height: CGFloat

    public var controller: IQCollectionController
    public var layout: UICollectionViewLayout

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        height: CGFloat,
        controller: IQCollectionController,
        layout: UICollectionViewLayout
    ) {
        self.edgeInsets = edgeInsets
        self.height = height
        self.controller = controller
        self.layout = layout
        super.init(
            canSelect: false
        )
    }

}

open class QCollectionTableCell< RowType: QCollectionTableRow > : QBackgroundColorTableCell< RowType >, IQCollectionControllerObserver {

    public private(set) lazy var collectionView: QCollectionView = {
        let view = QCollectionView(frame: self.contentView.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private weak var _collectionController: IQCollectionController? {
        set(value) {
            if let controller = self.collectionView.collectionController {
                controller.remove(observer: self)
            }
            if let controller = value {
                controller.add(observer: self, priority: 0)
            }
            self.collectionView.layoutIfNeeded()
            self.collectionView.collectionController = value
        }
        get { return self.collectionView.collectionController }
    }
    private var _collectionViewLayout: UICollectionViewLayout {
        set(value) { self.collectionView.collectionViewLayout = value }
        get { return self.collectionView.collectionViewLayout }
    }
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        return row.height
    }

    open override func setup() {
        super.setup()
        
        self._constraints = [
            self.collectionView.topLayout == self.contentView.topLayout,
            self.collectionView.leadingLayout == self.contentView.leadingLayout,
            self.collectionView.trailingLayout == self.contentView.trailingLayout,
            self.collectionView.bottomLayout == self.contentView.bottomLayout
        ]
    }
    
    deinit {
        self._collectionController = nil
    }
    
    open override func prepare(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.prepare(row: row, spec: spec, animated: animated)

        self.collectionView.contentInset = row.edgeInsets
        self.collectionView.scrollIndicatorInsets = row.edgeInsets
        self._collectionViewLayout = row.layout
        self._collectionController = row.controller
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self._collectionController = nil
    }

    // MARK: IQCollectionControllerObserver
    
    open func beginScroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func finishScroll(_ controller: IQCollectionController, collectionView: UICollectionView, velocity: CGPoint) -> CGPoint? {
        return nil
    }
    
    open func endScroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func beginZoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func endZoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }
    
    open func update(_ controller: IQCollectionController) {
    }
    
}
