//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRoutePath : IQRoutePath {

    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController : QNibViewController, IQRoutable {

    var routePath: IImageViewControllerRoutePath
    var routeContext: AppRouteContext

    @IBOutlet private weak var imageView: QImageView!

    init(_ routePath: IImageViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
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
