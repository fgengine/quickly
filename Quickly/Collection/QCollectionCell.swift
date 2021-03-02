//
//  Quickly
//

open class QCollectionCell< Item: IQCollectionItem > : UICollectionViewCell, IQTypedCollectionCell {
    
    public weak var collectionDelegate: CollectionCellDelegate?
    public private(set) var item: Item?
    public private(set) var spec: IQContainerSpec?

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

    open class func size(item: Item, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
        return CGSize.zero
    }

    open func configure() {
    }

    open func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        self.item = item
        self.spec = spec
    }
    
    open func beginDisplay() {
    }
    
    open func endDisplay() {
    }

}
