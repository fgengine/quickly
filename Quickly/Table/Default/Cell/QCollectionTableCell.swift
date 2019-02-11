//
//  Quickly
//

public enum QCollectionTableRowSizeBehaviour {
    case fixed(size: CGFloat)
    case dynamic
}

open class QCollectionTableRow : QBackgroundColorTableRow {

    public typealias LayoutType = UICollectionViewLayout & IQCollectionLayout

    public var edgeInsets: UIEdgeInsets

    public var sizeBehaviour: QCollectionTableRowSizeBehaviour
    public var controller: IQCollectionController
    public var layout: LayoutType

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        sizeBehaviour: QCollectionTableRowSizeBehaviour = .dynamic,
        controller: IQCollectionController,
        layout: LayoutType
    ) {
        self.edgeInsets = edgeInsets
        self.sizeBehaviour = sizeBehaviour
        self.controller = controller
        self.layout = layout
        super.init(
            canSelect: false
        )
    }

}

open class QCollectionTableCell< RowType: QCollectionTableRow > : QBackgroundColorTableCell< RowType >, IQCollectionControllerObserver, IQCollectionLayoutObserver {

    public private(set) var collectionView: QCollectionView!

    private weak var _collectionController: IQCollectionController? {
        set(value) {
            if self._collectionController !== value {
                if let collectionController = self.collectionView.collectionController {
                    collectionController.removeObserver(self)
                }
                self.collectionView.collectionController = value
                if let collectionController = self.collectionView.collectionController {
                    collectionController.addObserver(self, priority: 0)
                }
            }
        }
        get { return self.collectionView.collectionController }
    }
    private weak var _collectionLayout: RowType.LayoutType? {
        set(value) {
            if self.collectionView.collectionLayout !== value {
                if let collectionLayout = self.collectionView.collectionLayout {
                    collectionLayout.removeObserver(self)
                }
                self.collectionView.collectionLayout = value
                if let collectionLayout = self.collectionView.collectionLayout {
                    collectionLayout.addObserver(self, priority: 0)
                }
            }
        }
        get { return self.collectionView.collectionLayout }
    }

    private var _collectionHeightConstraint: NSLayoutConstraint! {
        willSet {
            if let constraint = self._collectionHeightConstraint {
                self.collectionView.removeConstraint(constraint)
            }
        }
        didSet {
            if let constraint = self._collectionHeightConstraint {
                self.collectionView.addConstraint(constraint)
            }
        }
    }

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        switch row.sizeBehaviour {
        case .fixed(let size): return size
        case .dynamic: return UITableView.automaticDimension
        }
    }

    open override func setup() {
        super.setup()

        self.collectionView = QCollectionView(frame: self.bounds, layout: QCollectionFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.collectionView)
        
        self.contentView.addConstraints([
            self.collectionView.topLayout == self.contentView.topLayout,
            self.collectionView.leadingLayout == self.contentView.leadingLayout,
            self.collectionView.trailingLayout == self.contentView.trailingLayout,
            self.collectionView.bottomLayout == self.contentView.bottomLayout
        ])
    }
    
    open override func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)

        self._collectionHeightConstraint = nil
        self._collectionLayout = row.layout
        self._collectionController = row.controller
        self.collectionView.contentInset = row.edgeInsets
        self.collectionView.scrollIndicatorInsets = row.edgeInsets
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    public func update(_ controller: IQCollectionController) {
        self._apply(contentSize: self.collectionView.collectionViewLayout.collectionViewContentSize)
    }

    public func update(_ layout: IQCollectionLayout, contentSize: CGSize) {
        self._apply(contentSize: contentSize)
    }

    private func _apply(contentSize: CGSize) {
        guard let row = self.row else { return }
        switch row.sizeBehaviour {
        case .dynamic: self._collectionHeightConstraint = (self.collectionView.heightLayout == contentSize.height)
        default: break
        }
    }

}
