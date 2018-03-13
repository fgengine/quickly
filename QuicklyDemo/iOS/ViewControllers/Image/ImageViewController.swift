//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRouter: IQRouter {

    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController: QStaticViewController, IQRouted {

    public var router: IImageViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var imageView: QImageView!

    public init(router: IImageViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.source = QImageSource(
            URL(string: "http://globus-ltd.ru/images/testing.jpg")!,
            size: CGSize(width: 100, height: 100),
            scale: .originOrAspectFit
        )
    }

}
