//
//  Quickly
//

import Quickly

protocol IPageViewControllerRouter : IPageContentViewControllerRouter {

    func dismiss(viewController: PageViewController)

}

class PageViewController : QPageContainerViewController, IQRouted {

    var router: IPageViewControllerRouter
    var container: AppContainer

    init(router: IPageViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
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
                contentViewController: PageContentViewController(router: self.router, container: self.container)
            ),
            QPageViewController(
                pagebarItem: QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #2", color: .green))
                ),
                contentViewController: PageContentViewController(router: self.router, container: self.container)
            ),
            QPageViewController(
                pagebarItem: QPagebarTitleItem(
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray,
                    title: QLabelStyleSheet(text: QText("Page #3", color: .blue))
                ),
                contentViewController: PageContentViewController(router: self.router, container: self.container)
            )
        ])
    }

}
