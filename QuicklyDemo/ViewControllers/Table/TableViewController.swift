//
//  Quickly
//

import Quickly

protocol ITableViewControllerRouter : IQRouter {
    
    func dismiss(viewController: TableViewController)
    
}

class TableViewController : QTableViewController, IQRouterable, IQContextable {

    weak var router: ITableViewControllerRouter!
    weak var context: AppContext!

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

        self.tableController = TableController(self)
    }
    
}

extension TableViewController : TableControllerDelegate {
}
