//
//  Quickly
//

public protocol IQStyleSheet : class {

    associatedtype TargetType

    func apply(target: TargetType)

}
