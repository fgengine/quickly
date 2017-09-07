//
//  Quickly
//

import UIKit

open class QCollectionCell<
    Type: IQCollectionItem
>: UICollectionViewCell, IQView, IQTypedCollectionCell {

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

    public weak var collectionDelegate: CollectionCellDelegate? = nil
    public var item: Type? = nil

    open class func size(item: Type, layout: UICollectionViewLayout, size: CGSize) -> CGSize {
        return CGSize.zero
    }

    open func configure() {
    }

    open func set(item: Type) {
        self.item = item
    }

    open func update(item: Type) {
        self.item = item
    }

}

