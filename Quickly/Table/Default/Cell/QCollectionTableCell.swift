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

    private weak var currentController: IQCollectionController? {
        set(value) {
            if self.currentController !== value {
                if let controller = self.collectionView.collectionController {
                    controller.removeObserver(self)
                }
                self.collectionView.collectionController = value
                if let controller = self.collectionView.collectionController {
                    controller.addObserver(self, priority: 0)
                }
            }
        }
        get { return self.collectionView.collectionController }
    }
    private weak var currentLayout: RowType.LayoutType? {
        set(value) {
            if self.currentLayout !== value {
                if let layout = self.collectionView.collectionLayout {
                    layout.removeObserver(self)
                }
                self.collectionView.collectionLayout = value
                if let layout = self.collectionView.collectionLayout {
                    layout.addObserver(self, priority: 0)
                }
            }
        }
        get { return self.collectionView.collectionLayout }
    }

    private var collectionHeightConstraint: NSLayoutConstraint! {
        willSet {
            if let constraint = self.collectionHeightConstraint {
                self.collectionView.removeConstraint(constraint)
            }
        }
        didSet {
            if let constraint = self.collectionHeightConstraint {
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

        self.collectionHeightConstraint = nil
        self.currentLayout = row.layout
        self.currentController = row.controller
        self.collectionView.contentInset = row.edgeInsets
        self.collectionView.scrollIndicatorInsets = row.edgeInsets
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    public func update(_ controller: IQCollectionController) {
        self.apply(contentSize: self.collectionView.collectionViewLayout.collectionViewContentSize)
    }

    public func update(_ layout: IQCollectionLayout, contentSize: CGSize) {
        self.apply(contentSize: contentSize)
    }

    private func apply(contentSize: CGSize) {
        guard let row = self.row else { return }
        switch row.sizeBehaviour {
        case .dynamic: self.collectionHeightConstraint = (self.collectionView.heightLayout == contentSize.height)
        default: break
        }
    }

}
