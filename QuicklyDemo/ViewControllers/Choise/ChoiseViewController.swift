//
//  Quickly
//

import Quickly

protocol IChoiseViewControllerRouter : IQRouter {

    func presentLabelViewController()
    func presentButtonViewController()
    func presentTextFieldViewController()
    func presentListFieldViewController()
    func presentDateFieldViewController()
    func presentImageViewController()
    func presentTableViewController()
    func presentPageViewController()
    func presentModalViewController()
    func presentDialogViewController()
    func presentPushViewController()

}

class ChoiseViewController : QTableViewController, IQRouterable, IQContextable {

    weak var router: IChoiseViewControllerRouter!
    weak var context: AppContext!
    var choiseTableController: ChoiseTableController! {
        didSet { self.tableController = self.choiseTableController }
    }

    init(router: RouterType, context: ContextType) {
        self.router = router
        self.context = context
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didLoad() {
        super.didLoad()

        self.choiseTableController = ChoiseTableController(self)
        self.refreshControl = UIRefreshControl()
    }
    
}

extension ChoiseViewController : ChoiseTableControllerDelegate {

    func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        switch row.mode {
        case .label: self.router.presentLabelViewController()
        case .button: self.router.presentButtonViewController()
        case .textField: self.router.presentTextFieldViewController()
        case .listField: self.router.presentListFieldViewController()
        case .dateField: self.router.presentDateFieldViewController()
        case .image: self.router.presentImageViewController()
        case .table: self.router.presentTableViewController()
        case .page: self.router.presentPageViewController()
        case .modal: self.router.presentModalViewController()
        case .dialog: self.router.presentDialogViewController()
        case .push: self.router.presentPushViewController()
        }
    }
    
}
