//
//  Quickly
//

open class QCompositionData: IQCompositionData {

    public var edgeInsets: UIEdgeInsets

    public init() {
        self.edgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

}

open class QComposition< DataType: IQCompositionData >: IQComposition {

    public var contentView: UIView
    public private(set) var data: DataType!

    public class func size(data: DataType, size: CGSize) -> CGSize {
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

    open func prepare(data: DataType, animated: Bool) {
        self.data = data
    }

    open func cleanup() {
        self.data = nil
    }

}
