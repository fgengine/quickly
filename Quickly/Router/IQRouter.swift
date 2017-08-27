//
//  Quickly
//

import UIKit

public protocol IQRouter: class {
}

public protocol IQViewControllerRouter: IQRouter {

    var viewController: UIViewController { get }

}

public protocol IQLocalViewControllerRouter: IQViewControllerRouter {

    associatedtype RouterType: IQRouter
    associatedtype ContainerType: IQContainer

    weak var router: RouterType? { get }
    var container: ContainerType { get }

}
