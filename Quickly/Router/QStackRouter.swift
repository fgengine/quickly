//
//  Quickly
//

import UIKit

open class QStackRouter<
    RouterType: IQRouter,
    ContainerType: IQContainer
>: IQLocalViewControllerRouter {

    public weak var router: RouterType?
    public var container: ContainerType
    public var viewController: UIViewController {
        get { return self.stackViewController }
    }
    public private(set) lazy var stackViewController: QStackViewController = self.prepareStackViewController()

    public required init(container: ContainerType, router: RouterType) {
        self.container = container
        self.router = router
    }

    private func prepareStackViewController() -> QStackViewController {
        return QStackViewController(rootViewController: self.prepareRootViewController())
    }

    open func prepareRootViewController() -> UIViewController {
        fatalError("Please override prepareRootViewController()")
    }

}
