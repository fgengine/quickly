//
//  Quickly
//

import UIKit

public protocol IQLocalRouter: IQRouter {

    weak var router: IQRouter? { get }

    var viewController: UIViewController { get }

}
