//
//  Quickly
//

public protocol IQRouterable {

    associatedtype RouterType

    var router: RouterType { get }

}

public protocol IQWeakRouterable {

    associatedtype RouterType

    var router: RouterType? { get }

}
