//
//  Quickly
//

import Quickly

class ChoiseViewController: QTableViewController, IQRouted {

    public var router: ChoiseRouter?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tc: ChoiseTableController = ChoiseTableController()
        tc.sections = [
            QTableSection(rows: [
                QLabelTableRow(text: QText("A")),
                QLabelTableRow(text: QText("B")),
                QLabelTableRow(text: QText("C")),
                QLabelTableRow(text: QText("D")),
                QLabelTableRow(text: QText("E")),
                QLabelTableRow(text: QText("F"))
            ])
        ]
        self.tableController = tc
    }

}
