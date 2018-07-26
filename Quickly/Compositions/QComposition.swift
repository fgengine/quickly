//
//  Quickly
//

open class QComposable : IQComposable {

    public var edgeInsets: UIEdgeInsets
    public class var defaultEdgeInsets: UIEdgeInsets {
        get { return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) }
    }

    public init(edgeInsets: UIEdgeInsets = defaultEdgeInsets) {
        self.edgeInsets = edgeInsets
    }

}

open class QComposition< Composable: IQComposable > : IQComposition {

    public private(set) var contentView: UIView
    public private(set) var composable: Composable!

    open class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
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

    open func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        self.composable = composable
    }

    open func cleanup() {
        self.composable = nil
    }

}
