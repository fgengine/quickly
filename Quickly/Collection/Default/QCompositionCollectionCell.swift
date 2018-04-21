//
//  Quickly
//

open class QCompositionCollectionItem< CompositionDataType: IQCompositionData > : QBackgroundColorCollectionItem {

    public var data: CompositionDataType

    public init(data: CompositionDataType) {
        self.data = data
        super.init()
    }

}

open class QCompositionCollectionCell< CompositionType: IQComposition > : QBackgroundColorCollectionCell< QCompositionCollectionItem< CompositionType.DataType > > {

    public private(set) var composition: CompositionType!

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        return CompositionType.size(data: item.data, size: size)
    }

    open override func setup() {
        super.setup()
        self.composition = CompositionType(contentView: self.contentView)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)
        self.composition.prepare(data: item.data, animated: animated)
    }

}
