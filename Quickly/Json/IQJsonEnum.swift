//
//  Quickly
//

public protocol IQJsonEnum : RawRepresentable {

    associatedtype RealValue

    var realValue: Self.RealValue { get }

    init(realValue: Self.RealValue)

}
