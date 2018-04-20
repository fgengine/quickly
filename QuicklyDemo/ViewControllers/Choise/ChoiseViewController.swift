//
//  Quickly
//

import Quickly

protocol IChoiseViewControllerRouter: IQRouter {

    func presentLabelViewController()
    func presentButtonViewController()
    func presentTextFieldViewController()
    func presentListFieldViewController()
    func presentDateFieldViewController()
    func presentImageViewController()
    func presentDialogViewController()
    func presentPushViewController()

}

class ChoiseViewController: QTableViewController, IQRouted {

    var router: IChoiseViewControllerRouter
    var container: AppContainer
    var choiseTableController: ChoiseTableController! {
        get { return self.tableController as! ChoiseTableController }
    }

    public init(router: IChoiseViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didLoad() {
        super.didLoad()

        self.tableController = ChoiseTableController(self)
        self.refreshControl = UIRefreshControl()
    }
    
}

extension ChoiseViewController : ChoiseTableControllerDelegate {

    public func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        switch row.mode {
        case .label: self.router.presentLabelViewController()
        case .button: self.router.presentButtonViewController()
        case .textField: self.router.presentTextFieldViewController()
        case .listField: self.router.presentListFieldViewController()
        case .dateField: self.router.presentDateFieldViewController()
        case .image: self.router.presentImageViewController()
        case .dialog: self.router.presentDialogViewController()
        case .push: self.router.presentPushViewController()
        }
    }
    
}
