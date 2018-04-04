//
//  Quickly
//

#if os(iOS)

    open class QTabBarRouter<
        ContainerType: IQContainer,
        RouterType: IQRouter
    >: IQViewControllerRouter {

        public var container: ContainerType
        public weak var router: RouterType?
        public var viewController: IQViewControllerRouter.ViewControllerType {
            get { return self.tabBarController }
        }
        public private(set) lazy var tabBarController: QTabBarController = self.prepareTabBarController()
        public var routers: [IQViewControllerRouter] = [] {
            didSet {
                self.tabBarController.viewControllers = self.routers.compactMap({ (router: IQViewControllerRouter) -> UIViewController? in
                    return router.viewController
                })
                if self.routers.count > 0 {
                    if let currentRouter = self.currentRouter {
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
        public var currentRouter: IQViewControllerRouter? {
            didSet {
                if let currentRouter = self.currentRouter {
                    self.tabBarController.currentViewController = currentRouter.viewController
                } else {
                    self.tabBarController.currentViewController = nil
                }
            }
        }

        public required init(container: ContainerType, router: RouterType) {
            self.container = container
            self.router = router
        }

        open func prepareTabBarController() -> QTabBarController {
            return QTabBarController()
        }

    }

#endif
