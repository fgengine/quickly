//
//  Quickly
//

import UIKit

public protocol IQRouted {

    associatedtype RouterType

    var router: RouterType? { get }

}
