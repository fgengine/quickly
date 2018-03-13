//
//  Quickly
//

#if os(iOS)

    open class QNavigationRouter<
        ContainerType: IQContainer,
        RouterType: IQRouter
    >: IQViewControllerRouter {

        public var container: ContainerType
        public weak var router: RouterType?
        public var viewController: IQViewControllerRouter.ViewControllerType {
            get { return self.navigationController }
        }

        public private(set) lazy var navigationController: QNavigationController = self.prepareNavigationController()

        public required init(container: ContainerType, router: RouterType) {
            self.container = container
            self.router = router
        }

        private func prepareNavigationController() -> QNavigationController {
            return QNavigationController(rootViewController: self.prepareRootViewController())
        }

        open func prepareRootViewController() -> UIViewController {
            fatalError("Please override prepareRootViewController()")
        }

    }

#endif
