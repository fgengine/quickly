//
//  Quickly
//

public enum QCollectionTableRowSizeBehaviour {
    case fixed(size: CGFloat)
    case dynamic
}

open class QCollectionTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var sizeBehaviour: QCollectionTableRowSizeBehaviour
    public var controller: IQCollectionController
    public var layout: UICollectionViewLayout

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        sizeBehaviour: QCollectionTableRowSizeBehaviour = .dynamic,
        controller: IQCollectionController,
        layout: UICollectionViewLayout
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

open class QCollectionTableCell< RowType: QCollectionTableRow > : QBackgroundColorTableCell< RowType >, IQCollectionControllerObserver {

    public private(set) var collectionView: QCollectionView!

    private weak var _collectionController: IQCollectionController? {
        set(value) {
            if self._collectionController !== value {
                if let collectionController = self.collectionView.collectionController {
                    collectionController.remove(observer: self)
                }
                if let collectionController = value {
                    collectionController.add(observer: self, priority: 0)
                }
                self.collectionView.collectionController = value
            }
        }
        get { return self.collectionView.collectionController }
    }
    private var _collectionViewLayout: UICollectionViewLayout {
        set(value) { self.collectionView.collectionViewLayout = value }
        get { return self.collectionView.collectionViewLayout }
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

        self.collectionView = QCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.contentView.addSubview(self.collectionView)
    }
    
    open override func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)

        self._collectionHeightConstraint = nil
        self.collectionView.contentInset = row.edgeInsets
        self.collectionView.scrollIndicatorInsets = row.edgeInsets
        self._collectionViewLayout = row.layout
        self._collectionController = row.controller
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    public func update(_ controller: IQCollectionController) {
        self._apply(contentSize: self.collectionView.collectionViewLayout.collectionViewContentSize)
    }

    private func _apply(contentSize: CGSize) {
        guard let row = self.row else { return }
        switch row.sizeBehaviour {
        case .dynamic: self._collectionHeightConstraint = (self.collectionView.heightLayout == contentSize.height)
        default: break
        }
    }

}
