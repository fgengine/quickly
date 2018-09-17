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

    public private(set) weak var owner: AnyObject?
    public private(set) var contentView: UIView
    public private(set) var composable: Composable?
    public private(set) weak var spec: IQContainerSpec?

    open class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize.zero
    }

    public required init(contentView: UIView, owner: AnyObject) {
        self.contentView = contentView
        self.setup(owner: owner)
    }

    public required init(frame: CGRect, owner: AnyObject) {
        self.contentView = QTransparentView(frame: frame)
        self.setup(owner: owner)
    }
    
    deinit {
        self.owner = nil
    }

    open func setup(owner: AnyObject) {
        self.owner = owner
    }

    open func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        self.composable = composable
        self.spec = spec
        
        self.preLayout(composable: composable, spec: spec)
        self.apply(composable: composable, spec: spec)
        self.postLayout(composable: composable, spec: spec)
    }
    
    open func preLayout(composable: Composable, spec: IQContainerSpec) {
    }

    open func apply(composable: Composable, spec: IQContainerSpec) {
    }

    open func postLayout(composable: Composable, spec: IQContainerSpec) {
    }

    open func cleanup() {
        self.spec = nil
        self.composable = nil
    }

}
