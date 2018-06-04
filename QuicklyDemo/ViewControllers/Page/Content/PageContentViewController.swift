//
//  Quickly
//

import Quickly

protocol IPageContentViewControllerRouter : IQRouter {

}

class PageContentViewController : QNibViewController, IQRouted {

    var router: IPageContentViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!
    @IBOutlet private weak var closeButton: QButton!

    init(router: IPageContentViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
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
