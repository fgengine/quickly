//
//  Quickly
//

public protocol IQCompositionData : class {

    var edgeInsets: UIEdgeInsets { set get }

}

public protocol IQComposition : class {

    associatedtype DataType: IQCompositionData

    var contentView: UIView { get }
    var data: DataType? { get }

    static func size(data: DataType?, size: CGSize) -> CGSize
    static func height(data: DataType?, width: CGFloat) -> CGFloat

    init(contentView: UIView)
    init(frame: CGRect)

    func setup()

    func prepare(data: DataType?, animated: Bool)
    func cleanup()

}

public extension IQComposition {

    static func height(data: DataType?, width: CGFloat) -> CGFloat {
        return self.size(data: data, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

}
