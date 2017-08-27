//
//  Quickly
//

import UIKit

open class QStackRouter<
    RouterType: IQRouter,
    ContainerType: IQContainer,
    ViewControllerType: UIViewController
>: IQLocalViewControllerRouter {

    public weak var router: RouterType?
    public var container: ContainerType
    public var viewController: UIViewController {
        get { return self.stackViewController }
    }
    public private(set) lazy var stackViewController: QStackViewController = self.prepareStackViewController()
    public private(set) lazy var rootViewController: ViewControllerType = self.prepareRootViewController()

    public required init(container: ContainerType, router: RouterType) {
        self.container = container
        self.router = router
    }

    internal func prepareStackViewController() -> QStackViewController {
        return QStackViewController(rootViewController: self.rootViewController)
    }

    internal func prepareRootViewController() -> ViewControllerType {
        return ViewControllerType()
    }

}
