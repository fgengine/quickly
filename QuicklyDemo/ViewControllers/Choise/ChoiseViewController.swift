//
//  Quickly
//

import Quickly

protocol IChoiseViewControllerRoutePath : IQRoutePath {

    func presentLabelViewController()
    func presentButtonViewController()
    func presentTextFieldViewController()
    func presentListFieldViewController()
    func presentDateFieldViewController()
    func presentImageViewController()
    func presentPageViewController()
    func presentModalViewController()
    func presentDialogViewController()
    func presentPushViewController()

}

class ChoiseViewController : QTableViewController, IQRoutable {

    var routePath: IChoiseViewControllerRoutePath
    var routeContext: AppRouteContext
    var choiseTableController: ChoiseTableController! {
        get { return self.tableController as! ChoiseTableController }
    }

    init(_ routePath: IChoiseViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didLoad() {
        super.didLoad()

        self.tableController = ChoiseTableController(self)
        self.refreshControl = UIRefreshControl()
    }
    
}

extension ChoiseViewController : ChoiseTableControllerDelegate {

    func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        switch row.mode {
        case .label: self.routePath.presentLabelViewController()
        case .button: self.routePath.presentButtonViewController()
        case .textField: self.routePath.presentTextFieldViewController()
        case .listField: self.routePath.presentListFieldViewController()
        case .dateField: self.routePath.presentDateFieldViewController()
        case .image: self.routePath.presentImageViewController()
        case .page: self.routePath.presentPageViewController()
        case .modal: self.routePath.presentModalViewController()
        case .dialog: self.routePath.presentDialogViewController()
        case .push: self.routePath.presentPushViewController()
        }
    }
    
}
