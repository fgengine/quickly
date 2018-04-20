//
//  Quickly
//

public enum QCollectionTableRowSizeBehaviour {
    case fixed(size: CGFloat)
    case dynamic
}

open class QCollectionTableRow : QBackgroundColorTableRow {

    public typealias LayoutType = UICollectionViewLayout & IQCollectionLayout

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    public var sizeBehaviour: QCollectionTableRowSizeBehaviour = .dynamic
    public var controller: IQCollectionController
    public var layout: LayoutType

    public init(_ controller: IQCollectionController, layout: LayoutType) {
        self.controller = controller
        self.layout = layout
        super.init()
    }


}

open class QCollectionTableCell< RowType: QCollectionTableRow > : QBackgroundColorTableCell< RowType >, IQCollectionControllerObserver, IQCollectionLayoutObserver {

    private var _collectionView: QCollectionView!

    private weak var currentController: IQCollectionController? {
        set(value) {
            if let controller = self._collectionView.collectionController {
                controller.removeObserver(self)
            }
            self._collectionView.collectionController = value
            if let controller = self._collectionView.collectionController {
                controller.addObserver(self)
            }
        }
        get { return self._collectionView.collectionController }
    }
    private weak var currentLayout: RowType.LayoutType? {
        set(value) {
            if let layout = self._collectionView.collectionLayout {
                layout.removeObserver(self)
            }
            self._collectionView.collectionLayout = value
            if let layout = self._collectionView.collectionLayout {
                layout.addObserver(self)
            }
        }
        get { return self._collectionView.collectionLayout }
    }
    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet {self.contentView.addConstraints(self.selfConstraints) }
    }
    private var collectionHeightConstraint: NSLayoutConstraint! {
        willSet { self._collectionView.removeConstraint(self.collectionHeightConstraint) }
        didSet { self._collectionView.addConstraint(self.collectionHeightConstraint) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        switch row.sizeBehaviour {
        case .fixed(let size): return row.edgeInsets.top + size + row.edgeInsets.bottom
        case .dynamic: return UITableViewAutomaticDimension
        }
    }

    open override func setup() {
        super.setup()

        self._collectionView = QCollectionView(frame: self.bounds, layout: QCollectionFlowLayout())
        self._collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._collectionView)
    }

    open override func prepareForReuse() {
        self.currentLayout = nil
        self.currentController = nil

        super.prepareForReuse()
    }

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)

        if self.currentEdgeInsets != row.edgeInsets {
            self.currentEdgeInsets = row.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._collectionView.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._collectionView.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._collectionView.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._collectionView.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }

        self.collectionHeightConstraint = nil

        self.currentLayout = row.layout
        self.currentController = row.controller
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
    }

    public func update(_ controller: IQCollectionController) {
        self.apply(contentSize: self._collectionView.collectionViewLayout.collectionViewContentSize)
    }

    public func update(_ layout: IQCollectionLayout, contentSize: CGSize) {
        self.apply(contentSize: contentSize)
    }

    private func apply(contentSize: CGSize) {
        guard let row = self.row else { return }
        switch row.sizeBehaviour {
        case .dynamic: self.collectionHeightConstraint = (self._collectionView.heightLayout == contentSize.height)
        default: break
        }
    }

}
