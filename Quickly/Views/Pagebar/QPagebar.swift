//
//  Quickly
//

open class QPagebarItem : QCollectionItem {
}

open class QPagebarCell< Type: QPagebarItem > : QCollectionCell< Type > {
}

open class QPagebar : QView {

    public typealias ItemType = IQCollectionController.Cell

    public weak var delegate: QPagebarDelegate?
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { self.setNeedsLayout() }
    }
    public var direction: QViewDirection = .horizontal {
        didSet {
            switch self.direction {
            case .vertical: self.collectionLayout.scrollDirection = .horizontal
            case .horizontal: self.collectionLayout.scrollDirection = .vertical
            }
        }
    }
    public private(set) var cellTypes: [ItemType.Type]
    public var itemsSpacing: CGFloat {
        set(value) { self.collectionLayout.minimumInteritemSpacing = value }
        get { return self.collectionLayout.minimumInteritemSpacing }
    }
    public var items: [QPagebarItem] {
        set(value) { self.collectionSection.setItems(value) }
        get { return self.collectionSection.items as! [QPagebarItem] }
    }
    public var selectedItem: QPagebarItem? {
        get { return self.collectionController.selectedItems.first as? QPagebarItem }
    }
    private lazy var collectionView: QCollectionView! = self.prepareCollectionView()
    private lazy var collectionLayout: CollectionLayout! = self.prepareCollectionLayout()
    private lazy var collectionController: CollectionController! = self.prepareCollectionController()
    private lazy var collectionSection: QCollectionSection! = self.prepareCollectionSection()
    
    public required init() {
        fatalError("init(coder:) has not been implemented")
    }

    public init(cellTypes: [ItemType.Type]) {
        self.cellTypes = cellTypes
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addSubview(self.collectionView)
    }

    public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        self.collectionController.performBatchUpdates(updates, completion: completion)
    }

    public func prependItem(_ item: QPagebarItem) {
        self.collectionSection.prependItem(item)
    }

    public func prependItem(_ items: [QPagebarItem]) {
        self.collectionSection.prependItem(items)
    }

    public func appendItem(_ item: QPagebarItem) {
        self.collectionSection.appendItem(item)
    }

    public func appendItem(_ items: [QPagebarItem]) {
        self.collectionSection.appendItem(items)
    }

    public func insertItem(_ item: QPagebarItem, index: Int) {
        self.collectionSection.insertItem(item, index: index)
    }

    public func insertItem(_ items: [QPagebarItem], index: Int) {
        self.collectionSection.insertItem(items, index: index)
    }

    public func deleteItem(_ item: QPagebarItem) {
        self.collectionSection.deleteItem(item)
    }

    public func deleteItem(_ items: [QPagebarItem]) {
        self.collectionSection.deleteItem(items)
    }

    public func replaceItem(_ item: QPagebarItem, index: Int) {
        self.collectionSection.replaceItem(item, index: index)
    }

    public func reloadItem(_ item: QPagebarItem) {
        self.collectionSection.reloadItem(item)
    }

    public func reloadItem(_ items: [QPagebarItem]) {
        self.collectionSection.reloadItem(items)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.collectionView.frame = self.bounds.inset(by: self.edgeInsets)
    }

    public func setSelectedItem(_ selectedItem: QPagebarItem?, animated: Bool) {
        if let item = selectedItem {
            if self.collectionController.isSelected(item: item) == false {
                self.collectionController.select(item: item, scroll: [ .centeredHorizontally, .centeredVertically ], animated: animated)
            }
        } else {
            self.collectionController.selectedItems = []
        }
    }

    private func prepareCollectionView() -> QCollectionView {
        let collectionView = QCollectionView(frame: self.bounds.inset(by: self.edgeInsets), layout: self.collectionLayout)
        collectionView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.collectionController = self.collectionController
        return collectionView
    }

    private func prepareCollectionLayout() -> CollectionLayout {
        let collectionLayout = CollectionLayout()
        switch self.direction {
        case .vertical: collectionLayout.scrollDirection = .horizontal
        case .horizontal: collectionLayout.scrollDirection = .vertical
        }
        return collectionLayout
    }

    private func prepareCollectionController() -> CollectionController? {
        let collectionController = CollectionController(self, cells: self.cellTypes)
        collectionController.sections = [ self.collectionSection ]
        return collectionController
    }

    private func prepareCollectionSection() -> QCollectionSection {
        let collectionSection = QCollectionSection(items: [])
        return collectionSection
    }

    private class CollectionLayout : QCollectionFlowLayout {

        public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
            if superAttributes.count < 1 { return [] }
            guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
            var boundsMin, boundsMax: CGPoint?
            attributes.forEach { layoutAttribute in
                let layoutFrame = layoutAttribute.frame
                if boundsMin == nil {
                    boundsMin = CGPoint(x: layoutFrame.minX, y: layoutFrame.minY)
                } else {
                    boundsMin = CGPoint(x: min(boundsMin!.x, layoutFrame.minX), y: min(boundsMin!.y, layoutFrame.minY))
                }
                if boundsMax == nil {
                    boundsMax = CGPoint(x: layoutFrame.maxX, y: layoutFrame.maxY)
                } else {
                    boundsMax = CGPoint(x: max(boundsMax!.x, layoutFrame.maxX), y: max(boundsMax!.y, layoutFrame.maxY))
                }
            }
            if let boundsMin = boundsMin, let boundsMax = boundsMax {
                let contentSize = self.collectionViewContentSize
                let boundsSize = CGSize(width: boundsMax.x - boundsMin.x, height: boundsMax.y - boundsMin.y)
                if (boundsSize.width < contentSize.width) || (boundsSize.height < contentSize.height) {
                    let offset = CGPoint(
                        x: (contentSize.width - boundsSize.width) / 2,
                        y: (contentSize.height - boundsSize.height) / 2
                    )
                    attributes.forEach { layoutAttribute in
                        layoutAttribute.frame = layoutAttribute.frame.offsetBy(dx: offset.x, dy: offset.y)
                    }
                }
            }
            return attributes
        }

    }

    private class CollectionController : QCollectionController {

        public private(set) weak var pagebar: QPagebar?

        public init(_ pagebar: QPagebar, cells: [ItemType.Type]) {
            self.pagebar = pagebar
            super.init(cells: cells)
        }

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let pagebar = self.pagebar, let delegate = pagebar.delegate else { return }
            delegate.pagebar(pagebar, didSelectItem: pagebar.selectedItem!)
        }

    }

}

public protocol QPagebarDelegate : class {

    func pagebar(_ pagebar: QPagebar, didSelectItem: QPagebarItem)

}
