//
//  Quickly
//

public protocol IQGroupbarItem : IQCollectionItem {
}

open class QGroupbarCell< Type: IQGroupbarItem > : QCollectionCell< Type > {

    open class override func size(item: Type, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return spec.containerSize }
        switch flowLayout.scrollDirection {
        case .vertical: return CGSize(width: spec.containerSize.width, height: spec.containerSize.height / CGFloat(section.items.count))
        case .horizontal: return CGSize(width: spec.containerSize.width / CGFloat(section.items.count), height: spec.containerSize.height)
        }
    }

}

open class QGroupbar : QView {

    public typealias ItemType = IQCollectionController.Cell

    public weak var delegate: QGroupbarDelegate?

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
    public var items: [IQGroupbarItem] {
        set(value) { self.collectionSection.items = value }
        get { return self.collectionSection.items as! [IQGroupbarItem] }
    }
    public var selectedItem: IQGroupbarItem? {
        set(value) {
            if let item = value {
                self.collectionController.selectedItems = [ item ]
            } else {
                self.collectionController.selectedItems = []
            }
        }
        get { return self.collectionController.selectedItems.first as? IQGroupbarItem }
    }

    private lazy var collectionView: QCollectionView! = self.prepareCollectionView()
    private lazy var collectionLayout: QCollectionFlowLayout! = self.prepareCollectionLayout()
    private lazy var collectionController: CollectionController! = self.prepareCollectionController()
    private lazy var collectionSection: QCollectionSection! = self.prepareCollectionSection()

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addSubview(self.collectionView)
    }

    private func prepareCollectionView() -> QCollectionView {
        let collectionView = QCollectionView(frame: self.bounds, layout: self.collectionLayout)
        collectionView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        return collectionView
    }

    private func prepareCollectionLayout() -> QCollectionFlowLayout {
        let collectionLayout = QCollectionFlowLayout()
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

    private class CollectionController : QCollectionController {

        public private(set) weak var pagebar: QGroupbar?

        public init(_ pagebar: QGroupbar, cells: [ItemType.Type]) {
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

public protocol QGroupbarDelegate : class {

    func pagebar(_ pagebar: QGroupbar, didSelectItem: IQGroupbarItem)

}
