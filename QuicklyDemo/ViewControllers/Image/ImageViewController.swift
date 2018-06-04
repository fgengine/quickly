//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRouter : IQRouter {

    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController : QNibViewController, IQRouted {

    var router: IImageViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!

    init(router: IImageViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.imageView.source = QImageSource(
            URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!,
            size: CGSize(width: 100, height: 100),
            scale: .originOrAspectFit
        )
    }

}
