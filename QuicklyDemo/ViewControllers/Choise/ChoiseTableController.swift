//
//  Quickly
//

import Quickly

protocol ChoiseTableControllerDelegate: class {

    func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow)

}

class ChoiseTableController: QTableController {

    public weak var delegate: ChoiseTableControllerDelegate?

    public init(_ delegate: ChoiseTableControllerDelegate) {
        self.delegate = delegate

        super.init(cells: [
            QLabelTableCell.self
        ])
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate: ChoiseTableControllerDelegate = self.delegate {
            let row: IQTableRow = self.row(indexPath: indexPath)
            if let row: ChoiseSectionTableRow = row as? ChoiseSectionTableRow {
                delegate.pressedChoiseSectionRow(row)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
