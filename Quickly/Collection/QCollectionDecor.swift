//
//  Quickly
//

open class QCollectionDecor< Type: IQCollectionData > : UICollectionReusableView, IQTypedCollectionDecor {

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

    public weak var collectionDelegate: IQCollectionDecorDelegate? = nil
    public var data: Type? = nil

    open class func size(data: Type, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
        return CGSize.zero
    }

    open func configure() {
    }

    open func set(data: Type, animated: Bool) {
        self.data = data
    }

}
