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
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
                QLabelTableRow(text: QText("Text text text text text text\nText text text text text text text text text text text text text text text text text text text text text text text text text text"), edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            ])
        ]
        self.tableController = tc
    }

}
