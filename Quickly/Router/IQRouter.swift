//
//  Quickly
//

import UIKit

public protocol IQRouter: class {
}

public protocol IQViewControllerRouter: IQRouter {

    weak var router: IQRouter? { get }
    var container: IQContainer { get }

    var viewController: UIViewController { get }

}
