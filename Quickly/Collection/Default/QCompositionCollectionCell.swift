//
//  Quickly
//

open class QCompositionCollectionItem< Composable: IQComposable > : QBackgroundColorCollectionItem {

    public var composable: Composable

    public init(composable: Composable) {
        self.composable = composable
        super.init()
    }

}

open class QCompositionCollectionCell< Composition: IQComposition > : QBackgroundColorCollectionCell< QCompositionCollectionItem< Composition.Composable > > {

    public private(set) var composition: Composition!

    open override class func size(
        item: Item,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        return Composition.size(composable: item.composable, size: size)
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }

    open override func set(item: Item, animated: Bool) {
        super.set(item: item, animated: animated)
        self.composition.prepare(composable: item.composable, animated: animated)
    }

}
