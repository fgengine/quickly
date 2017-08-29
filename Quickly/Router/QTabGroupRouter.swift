//
//  Quickly
//

import UIKit

open class QTabGroupRouter: IQLocalRouter {

    public weak var router: IQRouter?
    public var container: IQContainer
    public var viewController: UIViewController {
        get { return self.tabGroupViewController }
    }
    public private(set) lazy var tabGroupViewController: QTabGroupViewController = self.prepareTabGroupViewController()
    public var routers: [IQLocalRouter] = [] {
        didSet {
            self.tabGroupViewController.viewControllers = self.routers.flatMap({ (router: IQLocalRouter) -> UIViewController? in
                return router.viewController
            })
            if self.routers.count > 0 {
                if let currentRouter: IQLocalRouter = self.currentRouter {
                    if let index = self.routers.index(where: { (router: IQLocalRouter) -> Bool in
                        return router === currentRouter
                    }) {
                        self.currentRouter = self.routers[index]
                    } else {
                        self.currentRouter = self.routers.first
                    }
                } else {
                    self.currentRouter = self.routers.first
                }
            } else {
                self.currentRouter = nil
            }
        }
    }
    public var currentRouter: IQLocalRouter? = nil {
        didSet {
            if let currentRouter: IQLocalRouter = self.currentRouter {
                self.tabGroupViewController.currentViewController = currentRouter.viewController
            } else {
                self.tabGroupViewController.currentViewController = nil
            }
        }
    }

    public required init(container: IQContainer, router: IQRouter) {
        self.container = container
        self.router = router
    }

    open func prepareTabGroupViewController() -> QTabGroupViewController {
        return QTabGroupViewController()
    }

}
