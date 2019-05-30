//
//  Quickly
//

open class QCollectionCell< Type: IQCollectionItem > : UICollectionViewCell, IQTypedCollectionCell {
    
    public weak var collectionDelegate: CollectionCellDelegate?
    public var item: Type?
    public var spec: IQContainerSpec?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    open class func size(item: Type, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
        return CGSize.zero
    }

    open func configure() {
    }

    open func set(item: Type, spec: IQContainerSpec, animated: Bool) {
        self.item = item
        self.spec = spec
    }

}
