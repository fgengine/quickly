//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRouter: IQRouter {

    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController: QStaticViewController, IQRouted {

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
            URL(string: "http://globus-ltd.ru/images/testing.jpg")!,
            size: CGSize(width: 100, height: 100),
            scale: .originOrAspectFit
        )
    }

}
