//
//  Quickly
//

open class QCompositionTableRow< CompositionDataType: IQCompositionData > : QBackgroundColorTableRow {

    public var data: CompositionDataType

    public init(data: CompositionDataType) {
        self.data = data
        super.init()
    }

}

open class QCompositionTableCell< CompositionType: IQComposition > : QBackgroundColorTableCell< QCompositionTableRow< CompositionType.DataType > > {

    public private(set) var composition: CompositionType!

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        return CompositionType.height(data: row.data, width: width)
    }

    open override func setup() {
        super.setup()
        self.composition = CompositionType(contentView: self.contentView)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)
        self.composition.prepare(data: row.data, animated: animated)
    }

}
