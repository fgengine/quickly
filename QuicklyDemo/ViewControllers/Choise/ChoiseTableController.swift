//
//  Quickly
//

import Quickly

protocol ChoiseTableControllerDelegate: class {

    func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow)

}

class ChoiseTableController: QTableController {

    public weak var delegate: ChoiseTableControllerDelegate?
    public var section: IQTableSection?

    public init(_ delegate: ChoiseTableControllerDelegate) {
        self.delegate = delegate

        super.init(cells: [
            QCompositionTableCell< QTitleDetailShapeComposition >.self
        ])
        self.sections = [
            QTableSection(rows: [
                ChoiseSectionTableRow(mode: .label),
                ChoiseSectionTableRow(mode: .button),
                ChoiseSectionTableRow(mode: .textField),
                ChoiseSectionTableRow(mode: .listField),
                ChoiseSectionTableRow(mode: .dateField),
                ChoiseSectionTableRow(mode: .image),
                ChoiseSectionTableRow(mode: .dialog),
                ChoiseSectionTableRow(mode: .push)
            ])
        ]
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let row = self.row(indexPath: indexPath)
            if let row = row as? ChoiseSectionTableRow {
                delegate.pressedChoiseSectionRow(row)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
