//
//  Quickly
//

import Quickly

protocol IPageViewControllerRouter : IPageContentViewControllerRouter {

    func dismiss(viewController: PageViewController)

}

class PageViewController : QPageContainerViewController, IQRouterable, IQContextable {

    weak var router: IPageViewControllerRouter!
    weak var context: AppContext!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
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
                    title: QLabelStyleSheet(text: QText("Page #1", color: .red)),
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray
                ),
                PageContentViewController(
                    router: self.router,
                    context: self.context
                )
            ),
            QPageViewController(
                QPagebarTitleItem(
                    title: QLabelStyleSheet(text: QText("Page #2", color: .green)),
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray
                ),
                PageContentViewController(
                    router: self.router,
                    context: self.context
                )
            ),
            QPageViewController(
                QPagebarTitleItem(
                    title: QLabelStyleSheet(text: QText("Page #3", color: .blue)),
                    backgroundColor: UIColor.gray,
                    selectedBackgroundColor: UIColor.darkGray
                ),
                PageContentViewController(
                    router: self.router,
                    context: self.context
                )
            )
        ])
    }

}
