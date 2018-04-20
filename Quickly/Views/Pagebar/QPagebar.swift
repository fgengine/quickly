//
//  Quickly
//

public protocol IQPagebarItem : IQCollectionItem {
}

open class QPagebarCell< Type: IQPagebarItem > : QCollectionCell< Type > {
}

public class QPagebar : QView {

    public typealias ItemType = IQCollectionController.CellType

    public weak var delegate: QPagebarDelegate?

    public var direction: QViewDirection = .horizontal {
        didSet {
            switch self.direction {
            case .vertical: self.collectionLayout.scrollDirection = .vertical
            case .horizontal: self.collectionLayout.scrollDirection = .horizontal
            }
        }
    }
    public var itemViewTypes: [ItemType.Type] = [] {
        didSet {
            self.collectionController = nil
            self.collectionController.reload()
        }
    }

    public var itemsSpacing: CGFloat {
        set(value) { self.collectionLayout.minimumInteritemSpacing = value }
        get { return self.collectionLayout.minimumInteritemSpacing }
    }
    public var items: [IQPagebarItem] {
        set(value) { self.collectionSection.items = value }
        get { return self.collectionSection.items as! [IQPagebarItem] }
    }
    public var selectedItem: IQPagebarItem? {
        set(value) {
            if let item = value {
                self.collectionController.selectedItems = [ item ]
            } else {
                self.collectionController.selectedItems = []
            }
        }
        get { return self.collectionController.selectedItems.first as? IQPagebarItem }
    }

    private lazy var collectionView: QCollectionView! = self.prepareCollectionView()
    private lazy var collectionLayout: CollectionLayout! = self.prepareCollectionLayout()
    private lazy var collectionController: CollectionController! = self.prepareCollectionController()
    private lazy var collectionSection: QCollectionSection! = self.prepareCollectionSection()

    public override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addSubview(self.collectionView)
    }

    private func prepareCollectionView() -> QCollectionView {
        let collectionView = QCollectionView(frame: self.bounds, layout: self.collectionLayout)
        collectionView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        return collectionView
    }

    private func prepareCollectionLayout() -> CollectionLayout {
        let collectionLayout = CollectionLayout()
        switch self.direction {
        case .vertical: collectionLayout.scrollDirection = .vertical
        case .horizontal: collectionLayout.scrollDirection = .horizontal
        }
        return collectionLayout
    }

    private func prepareCollectionController() -> CollectionController? {
        let collectionController = CollectionController(self, cells: self.itemViewTypes)
        collectionController.sections = [ self.collectionSection ]
        self.collectionView.collectionController = self.collectionController
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
                    boundsMin = CGPoint(
                        x: layoutFrame.minX,
                        y: layoutFrame.minY
                    )
                } else {
                    boundsMin = CGPoint(
                        x: min(boundsMin!.x, layoutFrame.minX),
                        y: min(boundsMin!.y, layoutFrame.minY)
                    )
                }
                if boundsMax == nil {
                    boundsMax = CGPoint(
                        x: layoutFrame.maxX,
                        y: layoutFrame.maxY
                    )
                } else {
                    boundsMax = CGPoint(
                        x: max(boundsMax!.x, layoutFrame.maxX),
                        y: max(boundsMax!.y, layoutFrame.maxY)
                    )
                }
            }
            if let boundsMin = boundsMin, let boundsMax = boundsMax {
                if (rect.minX < boundsMin.x && rect.maxX > boundsMax.x) || (rect.minY < boundsMin.y && rect.maxY > boundsMax.y) {
                    let offset = CGPoint(
                        x: rect.width - (boundsMax.x - boundsMin.x),
                        y: rect.height - (boundsMax.y - boundsMin.y)
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

        public func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            guard
                let pagebar = self.pagebar,
                let delegate = pagebar.delegate
                else { return }
            delegate.pagebar(pagebar, didSelectItem: pagebar.selectedItem!)
        }

    }

}

public protocol QPagebarDelegate : class {

    func pagebar(_ pagebar: QPagebar, didSelectItem: IQPagebarItem)

}
