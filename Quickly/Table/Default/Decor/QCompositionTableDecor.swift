//
//  Quickly
//

public enum QCompositionTableDataSizeBehaviour {
    case dynamic
    case fixed(height: CGFloat)
    case bound(minimum: CGFloat, maximum: CGFloat)
}

open class QCompositionTableData< Composable: IQComposable > : QBackgroundColorTableData {

    public var composable: Composable
    public var sizeBehaviour: QCompositionTableDataSizeBehaviour

    public init(
        composable: Composable,
        sizeBehaviour: QCompositionTableDataSizeBehaviour = .dynamic,
        backgroundColor: UIColor? = nil
    ) {
        self.composable = composable
        self.sizeBehaviour = sizeBehaviour
        super.init(
            backgroundColor: backgroundColor
        )
    }

}

open class QCompositionTableDecor< Composition: IQComposition > : QBackgroundColorTableDecor< QCompositionTableData< Composition.Composable > > {

    public private(set) var composition: Composition!
    
    open override class func height(data: DataType, spec: IQContainerSpec) -> CGFloat {
        switch data.sizeBehaviour {
        case .dynamic:
            return Composition.height(composable: data.composable, spec: spec)
        case .fixed(let height):
            return height
        case .bound(let minimum, let maximum):
            let height = Composition.height(composable: data.composable, spec: spec)
            return max(maximum, min(height, minimum))
        }
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView, owner: self)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }
    
    open override func prepare(data: DataType, spec: IQContainerSpec, animated: Bool) {
        super.prepare(data: data, spec: spec, animated: animated)
        self.composition.prepare(composable: data.composable, spec: spec, animated: animated)
    }

}
