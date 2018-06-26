//
//  Quickly
//

open class QCompositionTableRow< Composable: IQComposable > : QBackgroundColorTableRow {

    public var composable: Composable

    public init(composable: Composable, backgroundColor: UIColor? = nil, selectedBackgroundColor: UIColor? = nil) {
        self.composable = composable
        super.init(backgroundColor: backgroundColor, selectedBackgroundColor: selectedBackgroundColor)
    }

}

open class QCompositionTableCell< Composition: IQComposition > : QBackgroundColorTableCell< QCompositionTableRow< Composition.Composable > > {

    public private(set) var composition: Composition!

    open override class func height(row: Row, width: CGFloat) -> CGFloat {
        return Composition.height(composable: row.composable, width: width)
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }

    open override func set(row: Row, animated: Bool) {
        super.set(row: row, animated: animated)
        self.composition.prepare(composable: row.composable, animated: animated)
    }

}
