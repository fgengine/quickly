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
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets() {
           didSet(oldValue) { if self.edgeInsets != oldValue { self.setNeedsUpdateConstraints() } }
       }
    public private(set) var cellTypes: [ItemType.Type]
    public var itemsSpacing: CGFloat {
        set(value) { self._collectionLayout.minimumInteritemSpacing = value }
        get { return self._collectionLayout.minimumInteritemSpacing }
    }
    public var items: [QPagebarItem] {
        set(value) {
            self._collectionSection.setItems(value)
            self._collectionController.reload()
        }
        get { return self._collectionSection.items as! [QPagebarItem] }
    }
    public var selectedItem: QPagebarItem? {
        get { return self._collectionController.selectedItems.first as? QPagebarItem }
    }
    
    private lazy var _collectionView: QCollectionView = {
        let view = QCollectionView(frame: self.bounds.inset(by: self.edgeInsets), collectionViewLayout: self._collectionLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = false
        view.collectionController = self._collectionController
        return view
    }()
    private lazy var _collectionLayout: CollectionLayout = {
        let layout = CollectionLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    private lazy var _collectionController: CollectionController = {
        let controller = CollectionController(self, cells: self.cellTypes)
        controller.sections = [ self._collectionSection ]
        return controller
    }()
    private lazy var _collectionSection: QCollectionSection = {
        return QCollectionSection(items: [])
    }()
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }
    
    public required init() {
        fatalError("init(coder:) has not been implemented")
    }

    public init(
        cellTypes: [ItemType.Type]
    ) {
        self.cellTypes = cellTypes
        super.init(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addSubview(self._collectionView)
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        self._constraints = [
            self._collectionView.topLayout == self.topLayout.offset(self.edgeInsets.top),
            self._collectionView.leadingLayout == self.leadingLayout.offset(self.edgeInsets.left),
            self._collectionView.trailingLayout == self.trailingLayout.offset(-self.edgeInsets.right),
            self._collectionView.bottomLayout == self.bottomLayout.offset(-self.edgeInsets.bottom)
        ]
    }

    public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        self._collectionController.performBatchUpdates(updates, completion: completion)
    }

    public func prependItem(_ item: QPagebarItem) {
        self._collectionSection.prependItem(item)
    }

    public func prependItem(_ items: [QPagebarItem]) {
        self._collectionSection.prependItem(items)
    }

    public func appendItem(_ item: QPagebarItem) {
        self._collectionSection.appendItem(item)
    }

    public func appendItem(_ items: [QPagebarItem]) {
        self._collectionSection.appendItem(items)
    }

    public func insertItem(_ item: QPagebarItem, index: Int) {
        self._collectionSection.insertItem(item, index: index)
    }

    public func insertItem(_ items: [QPagebarItem], index: Int) {
        self._collectionSection.insertItem(items, index: index)
    }

    public func deleteItem(_ item: QPagebarItem) {
        self._collectionSection.deleteItem(item)
    }

    public func deleteItem(_ items: [QPagebarItem]) {
        self._collectionSection.deleteItem(items)
    }

    public func replaceItem(_ item: QPagebarItem, index: Int) {
        self._collectionSection.replaceItem(item, index: index)
    }

    public func reloadItem(_ item: QPagebarItem) {
        self._collectionSection.reloadItem(item)
    }

    public func reloadItem(_ items: [QPagebarItem]) {
        self._collectionSection.reloadItem(items)
    }

    public func setSelectedItem(_ selectedItem: QPagebarItem?, animated: Bool) {
        if let item = selectedItem {
            if self._collectionController.isSelected(item: item) == false {
                self._collectionController.select(item: item, scroll: [ .centeredHorizontally, .centeredVertically ], animated: animated)
            }
        } else {
            self._collectionController.selectedItems = []
        }
    }

    private class CollectionLayout : UICollectionViewFlowLayout {

        public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard
                let collectionView = self.collectionView,
                let superAttributes = super.layoutAttributesForElements(in: rect),
                let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
                else { return nil }
            let contentSize = self.collectionViewContentSize
            let boundsSize = collectionView.bounds.size
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

        public private(set) weak var pagebar: QPagebar?

        public init(_ pagebar: QPagebar, cells: [ItemType.Type]) {
            self.pagebar = pagebar
            super.init(cells: cells)
        }

        @objc
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let pagebar = self.pagebar, let delegate = pagebar.delegate else { return }
            collectionView.scrollToItem(at: indexPath, at: [ .centeredHorizontally, .centeredVertically ], animated: true)
            delegate.pagebar(pagebar, didSelectItem: pagebar.selectedItem!)
        }

    }

}

public protocol QPagebarDelegate : class {

    func pagebar(_ pagebar: QPagebar, didSelectItem: QPagebarItem)

}
