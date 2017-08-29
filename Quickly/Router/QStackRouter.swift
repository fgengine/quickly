//
//  Quickly
//

import UIKit

open class QStackRouter: IQViewControllerRouter {

    public weak var router: IQRouter?
    public var container: IQContainer
    public var viewController: UIViewController {
        get { return self.stackViewController }
    }
    
    public private(set) lazy var stackViewController: QStackViewController = self.prepareStackViewController()

    public required init(container: IQContainer, router: IQRouter) {
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
