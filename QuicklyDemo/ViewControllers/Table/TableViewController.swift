//
//  Quickly
//

import Quickly

protocol ITableViewControllerRoutePath : IQRoutePath {
    
    func dismiss(viewController: TableViewController)
    
}

class TableViewController : QTableViewController, IQRoutable {

    weak var routePath: ITableViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    init(_ routePath: ITableViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
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
