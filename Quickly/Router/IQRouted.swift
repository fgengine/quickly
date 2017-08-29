//
//  Quickly
//

import UIKit

public protocol IQRouted {

    associatedtype RouterType
    associatedtype ContainerType

    var router: RouterType? { get }
    var container: ContainerType { get }

}
