//
//
//  Quickly
//

import Quickly

protocol IImageViewControllerRouter : IQRouter {

    func dismiss(viewController: ImageViewController)
    
}

class ImageViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: IImageViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var imageView: QImageView!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
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
