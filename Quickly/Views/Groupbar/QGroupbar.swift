//
//  Quickly
//

open class QGroupbarItem : QCollectionItem {
}

open class QGroupbarCell< Type: QGroupbarItem > : QCollectionCell< Type > {
}

open class QGroupbar : QView {
    
    public typealias ItemType = IQCollectionController.Cell
    
    public weak var delegate: QGroupbarDelegate?
    public var edgeInsets: UIEdgeInsets {
        set(value) { self.collectionView.contentInset = value }
        get { return self.collectionView.contentInset }
    }
    public private(set) var cellTypes: [ItemType.Type]
    public var itemsSpacing: CGFloat {
        set(value) { self.collectionLayout.minimumInteritemSpacing = value }
        get { return self.collectionLayout.minimumInteritemSpacing }
    }
    public var items: [QGroupbarItem] {
        set(value) { self.collectionSection.setItems(value) }
        get { return self.collectionSection.items as! [QGroupbarItem] }
    }
    public var selectedItem: QGroupbarItem? {
        get { return self.collectionController.selectedItems.first as? QGroupbarItem }
    }
    private lazy var collectionView: QCollectionView = {
        let view = QCollectionView(frame: self.bounds, layout: self.collectionLayout)
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = false
        view.collectionController = self.collectionController
        return view
    }()
    private lazy var collectionLayout: CollectionLayout = {
        let layout = CollectionLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    private lazy var collectionController: CollectionController = {
        let controller = CollectionController(self, cells: self.cellTypes)
        controller.sections = [ self.collectionSection ]
        return controller
    }()
    private lazy var collectionSection: QCollectionSection = {
        return QCollectionSection(items: [])
    }()
    
    public required init() {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(
        cellTypes: [ItemType.Type],
        itemsSpacing: CGFloat = 0,
        backgroundColor: UIColor? = nil
    ) {
        self.cellTypes = cellTypes
        super.init(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        )
        self.itemsSpacing = itemsSpacing
        self.backgroundColor = backgroundColor
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
    
    public func prependItem(_ item: QGroupbarItem) {
        self.collectionSection.prependItem(item)
    }
    
    public func prependItem(_ items: [QGroupbarItem]) {
        self.collectionSection.prependItem(items)
    }
    
    public func appendItem(_ item: QGroupbarItem) {
        self.collectionSection.appendItem(item)
    }
    
    public func appendItem(_ items: [QGroupbarItem]) {
        self.collectionSection.appendItem(items)
    }
    
    public func insertItem(_ item: QGroupbarItem, index: Int) {
        self.collectionSection.insertItem(item, index: index)
    }
    
    public func insertItem(_ items: [QGroupbarItem], index: Int) {
        self.collectionSection.insertItem(items, index: index)
    }
    
    public func deleteItem(_ item: QGroupbarItem) {
        self.collectionSection.deleteItem(item)
    }
    
    public func deleteItem(_ items: [QGroupbarItem]) {
        self.collectionSection.deleteItem(items)
    }
    
    public func replaceItem(_ item: QGroupbarItem, index: Int) {
        self.collectionSection.replaceItem(item, index: index)
    }
    
    public func reloadItem(_ item: QGroupbarItem) {
        self.collectionSection.reloadItem(item)
    }
    
    public func reloadItem(_ items: [QGroupbarItem]) {
        self.collectionSection.reloadItem(items)
    }
    
    public func setSelectedItem(_ selectedItem: QGroupbarItem?, animated: Bool) {
        if let item = selectedItem {
            if self.collectionController.isSelected(item: item) == false {
                self.collectionController.select(item: item, scroll: [ .centeredHorizontally, .centeredVertically ], animated: animated)
            }
        } else {
            self.collectionController.selectedItems = []
        }
    }
    
    private class CollectionLayout : QCollectionFlowLayout {
        
        public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard
                let collectionView = self.collectionView,
                let superAttributes = super.layoutAttributesForElements(in: rect),
                let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
                else { return nil }
            let contentSize = self.collectionViewContentSize
            let boundsSize = collectionView.bounds.inset(by: collectionView.contentInset).size
            if (contentSize.width < boundsSize.width) || (contentSize.height < boundsSize.height) {
                let offset = CGPoint(
                    x: (boundsSize.width - contentSize.width) / 2,
                    y: (boundsSize.height - contentSize.height) / 2
                )
                attributes.forEach { layoutAttribute in
                    layoutAttribute.frame = layoutAttribute.frame.offsetBy(dx: offset.x, dy: offset.y)
                }
            }
            return attributes
        }
        
    }
    
    private class CollectionController : QCollectionController {
        
        public private(set) weak var groupbar: QGroupbar?
        
        public init(_ groupbar: QGroupbar, cells: [ItemType.Type]) {
            self.groupbar = groupbar
            super.init(cells: cells)
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let groupbar = self.groupbar, let delegate = groupbar.delegate else { return }
            delegate.groupbar(groupbar, didSelectItem: groupbar.selectedItem!)
        }
        
    }
    
}

public protocol QGroupbarDelegate : class {
    
    func groupbar(_ groupbar: QGroupbar, didSelectItem: QGroupbarItem)
    
}
