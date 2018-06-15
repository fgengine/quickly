//
//  Quickly
//

import Quickly

protocol IPageViewControllerRoutePath : IPageContentViewControllerRoutePath {

    func dismiss(viewController: PageViewController)

}

class PageViewController : QPageContainerViewController, IQRoutable {

    var routePath: IPageViewControllerRoutePath
    var routeContext: AppRouteContext

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
        self.setPagebar(pagebar)

        self.setViewControllers([
            QPageViewController(
                pagebarItem: QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #1", color: .red))
                ),
                contentViewController: PageContentViewController(self.routePath, self.routeContext)
            ),
            QPageViewController(
                pagebarItem: QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #2", color: .green))
                ),
                contentViewController: PageContentViewController(self.routePath, self.routeContext)
            ),
            QPageViewController(
                pagebarItem: QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #3", color: .blue))
                ),
                contentViewController: PageContentViewController(self.routePath, self.routeContext)
            )
        ])
    }

}
