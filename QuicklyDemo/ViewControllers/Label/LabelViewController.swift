//
//
//  Quickly
//

import Quickly

protocol ILabelViewControllerRouter : IQRouter {

    func dismiss(viewController: LabelViewController)
    
}

class LabelViewController : QNibViewController, IQRouterable, IQContextable {

    weak var router: ILabelViewControllerRouter!
    weak var context: AppContext!

    @IBOutlet private weak var label: QLabel!
    // @IBOutlet private weak var linkLabel: QLinkLabel!

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.label.text = QText("This is text, This is text\nThis is text", color: UIColor.black)
        self.label.numberOfLines = 2

        /*self.linkLabel.text = QText("Thorium is a weakly radioactive metallic chemical element with symbol Th and atomic number 90. Thorium metal is silvery and tarnishes black when it is exposed to air, forming the dioxide; it is moderately hard, malleable, and has a high melting point. Thorium is an electropositive actinide whose chemistry is dominated by the +4 oxidation state; it is quite reactive and can ignite in air when finely divided.", color: UIColor.black)
        self.linkLabel.numberOfLines = 0
        self.linkLabel.appendLink("Thorium", normal: TextStyle.link, highlight: nil) { [weak self] (label, link) in
            guard let strong = self else { return }
            strong.router.dismiss(viewController: strong)
        }*/
    }

}
