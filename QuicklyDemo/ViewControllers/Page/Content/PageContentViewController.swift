//
//  Quickly
//

import Quickly

protocol IPageContentViewControllerRoutePath : IQRoutePath {
}

class PageContentViewController : QNibViewController, IQRoutable {

    weak var routePath: IPageContentViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    init(_ routePath: IPageContentViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.rootView.backgroundColor = UIColor.random(alpha: 1.0)
    }

    override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }

}
