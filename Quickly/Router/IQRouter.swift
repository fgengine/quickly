//
//  Quickly
//

public protocol IQContainer : class {
}

public protocol IQRouter : class {

    var viewController: IQViewController { get }

}

public protocol IQRouted {

    associatedtype RouterType
    associatedtype ContainerType

    var router: RouterType { get }
    var container: ContainerType { get }

}
