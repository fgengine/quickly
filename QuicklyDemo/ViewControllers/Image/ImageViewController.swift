//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRouter: IQRouter {

    func presentImageViewController()
    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController: QStaticViewController, IQRouted {

    public var router: IImageViewControllerRouter?
    public var container: AppContainer?

    @IBOutlet private weak var imageView: QImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.source = QImageSource(
            URL(string: "http://globus-ltd.ru/images/testing.jpg")!,
            size: CGSize(width: 100, height: 100),
            scale: .originOrAspectFit
        )
    }

}
