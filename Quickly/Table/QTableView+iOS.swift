//
//  Quickly
//

#if os(iOS)

    open class QTableView: UITableView {

        public var tableController: IQTableController? {
            willSet {
                self.delegate = nil
                self.dataSource = nil
                if let tableController = self.tableController {
                    tableController.tableView = nil
                }
            }
            didSet {
                self.delegate = self.tableController
                self.dataSource = self.tableController
                if let tableController = self.tableController {
                    tableController.tableView = self
                }
            }
        }

    }

#endif
