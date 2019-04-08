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
        set(value) { self._collectionView.contentInset = value }
        get { return self._collectionView.contentInset }
    }
    public private(set) var cellTypes: [ItemType.Type]
    public var items: [QGroupbarItem] {
        set(value) {
            self._collectionSection.setItems(value)
            self._collectionController.reload()
        }
        get { return self._collectionSection.items as! [QGroupbarItem] }
    }
    public var selectedItem: QGroupbarItem? {
        get { return self._collectionController.selectedItems.first as? QGroupbarItem }
    }
    public var backgroundView: UIView? {
        willSet {
            guard let view = self.backgroundView else { return }
            view.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let view = self.backgroundView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.insertSubview(view, belowSubview: self._collectionView)
            self.setNeedsUpdateConstraints()
        }
    }
    public var separatorView: UIView? {
        willSet {
            guard let view = self.separatorView else { return }
            self._separatorConstraint = nil
            view.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let view = self.separatorView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            self._separatorConstraint = NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: self.separatorHeight
            )
            self.setNeedsUpdateConstraints()
        }
    }
    public var separatorHeight: CGFloat = 1 {
        didSet(oldValue) {
            if self.separatorHeight != oldValue {
                if let constraint = self._separatorConstraint {
                    constraint.constant = self.separatorHeight
                }
            }
        }
    }
    
    private lazy var _collectionView: QCollectionView = {
        let view = QCollectionView(frame: self.bounds, collectionViewLayout: self._collectionLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = false
        view.collectionController = self._collectionController
        return view
    }()
    private lazy var _collectionLayout: CollectionLayout = {
        return CollectionLayout()
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
    private var _separatorConstraint: NSLayoutConstraint? {
        willSet {
            guard let view = self.separatorView, let constraint = self._separatorConstraint else { return }
            view.removeConstraint(constraint)
        }
        didSet {
            guard let view = self.separatorView, let constraint = self._separatorConstraint else { return }
            view.addConstraint(constraint)
        }
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
        
        var constraints: [NSLayoutConstraint] = [
            self._collectionView.leadingLayout == self.leadingLayout,
            self._collectionView.trailingLayout == self.trailingLayout,
            self._collectionView.bottomLayout == self.bottomLayout
        ]
        if let backgroundView = self.backgroundView {
            constraints.append(contentsOf: [
                backgroundView.leadingLayout == self.leadingLayout,
                backgroundView.trailingLayout == self.trailingLayout,
                backgroundView.bottomLayout == self.bottomLayout
            ])
        }
        if let separatorView = self.separatorView {
            constraints.append(contentsOf: [
                separatorView.topLayout == self.topLayout,
                separatorView.leadingLayout == self.leadingLayout,
                separatorView.trailingLayout == self.trailingLayout,
                self._collectionView.topLayout == separatorView.bottomLayout
            ])
            if let backgroundView = self.backgroundView {
                constraints.append(backgroundView.topLayout == separatorView.bottomLayout)
            }
        } else {
            constraints.append(self._collectionView.topLayout == self.topLayout)
        }
        self._constraints = constraints
    }
    
    public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        self._collectionController.performBatchUpdates(updates, completion: completion)
    }
    
    public func prependItem(_ item: QGroupbarItem) {
        self._collectionSection.prependItem(item)
    }
    
    public func prependItem(_ items: [QGroupbarItem]) {
        self._collectionSection.prependItem(items)
    }
    
    public func appendItem(_ item: QGroupbarItem) {
        self._collectionSection.appendItem(item)
    }
    
    public func appendItem(_ items: [QGroupbarItem]) {
        self._collectionSection.appendItem(items)
    }
    
    public func insertItem(_ item: QGroupbarItem, index: Int) {
        self._collectionSection.insertItem(item, index: index)
    }
    
    public func insertItem(_ items: [QGroupbarItem], index: Int) {
        self._collectionSection.insertItem(items, index: index)
    }
    
    public func deleteItem(_ item: QGroupbarItem) {
        self._collectionSection.deleteItem(item)
    }
    
    public func deleteItem(_ items: [QGroupbarItem]) {
        self._collectionSection.deleteItem(items)
    }
    
    public func replaceItem(_ item: QGroupbarItem, index: Int) {
        self._collectionSection.replaceItem(item, index: index)
    }
    
    public func reloadItem(_ item: QGroupbarItem) {
        self._collectionSection.reloadItem(item)
    }
    
    public func reloadItem(_ items: [QGroupbarItem]) {
        self._collectionSection.reloadItem(items)
    }
    
    public func setSelectedItem(_ selectedItem: QGroupbarItem?, animated: Bool) {
        if let item = selectedItem {
            if self._collectionController.isSelected(item: item) == false {
                self._collectionController.select(item: item, scroll: [ .centeredHorizontally, .centeredVertically ], animated: animated)
            }
        } else {
            self._collectionController.selectedItems = []
        }
    }
    
    private class CollectionLayout : UICollectionViewFlowLayout {
        
        public override var collectionViewContentSize: CGSize {
            get {
                var contentSize = CGSize.zero
                self._cache.forEach({
                    let frameSize = $0.value.frame.size
                    contentSize = CGSize(
                        width: contentSize.width + frameSize.width,
                        height: max(contentSize.height, frameSize.height)
                    )
                })
                return contentSize
            }
        }
        private var _bounds = CGRect.zero
        private var _cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        
        public override func prepare() {
            guard let collectionView = self.collectionView, self._cache.isEmpty == true else { return }
            self._cache = [:]
            self._bounds = collectionView.bounds
            
            var numberOfCells: Int = 0
            for sectionIndex in 0..<collectionView.numberOfSections {
                numberOfCells += collectionView.numberOfItems(inSection: sectionIndex)
            }
            let contentInset = collectionView.contentInset
            let cellSize = CGSize(
                width: (self._bounds.width - (contentInset.left + contentInset.right)) / CGFloat(numberOfCells),
                height: (self._bounds.height - (contentInset.top + contentInset.bottom))
            )
            var offset: CGFloat = contentInset.left
            for sectionIndex in 0..<collectionView.numberOfSections {
                for itemIndex in 0..<collectionView.numberOfItems(inSection: sectionIndex) {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attribute.frame = CGRect(x: offset, y: contentInset.top, width: cellSize.width, height: cellSize.height)
                    self._cache[indexPath] = attribute
                    offset += cellSize.width
                }
            }
        }
        
        override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            if self._bounds.size != newBounds.size {
                self._cache.removeAll(keepingCapacity: true)
            }
            return true
        }
        
        public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return self._cache[indexPath]
        }
        
        public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var attributes: [UICollectionViewLayoutAttributes] = []
            for attribute in self._cache {
                if attribute.value.frame.intersects(rect) == true {
                    attributes.append(attribute.value)
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
