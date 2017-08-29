//
//  Quickly
//

import UIKit

open class QTabGroupRouter<
    ContainerType: IQContainer,
    RouterType: IQRouter
>: IQViewControllerRouter {

    public var container: ContainerType
    public weak var router: RouterType?
    public var viewController: UIViewController {
        get { return self.tabGroupViewController }
    }
    public private(set) lazy var tabGroupViewController: QTabGroupViewController = self.prepareTabGroupViewController()
    public var routers: [IQViewControllerRouter] = [] {
        didSet {
            self.tabGroupViewController.viewControllers = self.routers.flatMap({ (router: IQViewControllerRouter) -> UIViewController? in
                return router.viewController
            })
            if self.routers.count > 0 {
                if let currentRouter: IQViewControllerRouter = self.currentRouter {
                    if let index = self.routers.index(where: { (router: IQViewControllerRouter) -> Bool in
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
    public var currentRouter: IQViewControllerRouter? = nil {
        didSet {
            if let currentRouter: IQViewControllerRouter = self.currentRouter {
                self.tabGroupViewController.currentViewController = currentRouter.viewController
            } else {
                self.tabGroupViewController.currentViewController = nil
            }
        }
    }

    public required init(container: ContainerType, router: RouterType) {
        self.container = container
        self.router = router
    }

    open func prepareTabGroupViewController() -> QTabGroupViewController {
        return QTabGroupViewController()
    }

}
