//
//  Quickly
//

import Quickly

protocol IPageContentViewControllerRouter : IQRouter {
}

class PageContentViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IPageContentViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
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
