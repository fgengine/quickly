//
//  Quickly
//

import Quickly

protocol IPageViewControllerRoutePath : IPageContentViewControllerRoutePath {

    func dismiss(viewController: PageViewController)

}

class PageViewController : QPageContainerViewController, IQRoutable {

    weak var routePath: IPageViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    init(_ routePath: IPageViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func setup() {
        super.setup()

        let pagebar = QPagebar(cellTypes: [
            QPagebarTitleCell< QPagebarTitleItem >.self
        ])
        pagebar.backgroundColor = UIColor.white
        self.setPagebar(pagebar)

        self.setViewControllers([
            QPageViewController(
                QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #1", color: .red))
                ),
                PageContentViewController(self.routePath, self.routeContext)
            ),
            QPageViewController(
                QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #2", color: .green))
                ),
                PageContentViewController(self.routePath, self.routeContext)
            ),
            QPageViewController(
                QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #3", color: .blue))
                ),
                PageContentViewController(self.routePath, self.routeContext)
            )
        ])
    }

}
