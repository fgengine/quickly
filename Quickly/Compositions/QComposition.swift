//
//  Quickly
//

open class QComposable : IQComposable {

    public var edgeInsets: UIEdgeInsets

    public init(edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) {
        self.edgeInsets = edgeInsets
    }

}

open class QComposition< Composable: IQComposable > : IQComposition {

    public var contentView: UIView
    public private(set) var composable: Composable!

    open class func size(composable: Composable, size: CGSize) -> CGSize {
        return CGSize.zero
    }

    public required init(contentView: UIView) {
        self.contentView = contentView
        self.setup()
    }

    public required init(frame: CGRect) {
        self.contentView = QTransparentView(frame: frame)
        self.setup()
    }

    open func setup() {
    }

    open func prepare(composable: Composable, animated: Bool) {
        self.composable = composable
    }

    open func cleanup() {
        self.composable = nil
    }

}
