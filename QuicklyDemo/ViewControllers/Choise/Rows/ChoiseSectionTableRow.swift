//
//  Quickly
//

import Quickly

class ChoiseSectionTableRow : QCompositionTableRow< QTitleDetailShapeComposable > {

    // MARK: Enum

    enum Mode {
        case label
        case button
        case textField
        case listField
        case dateField
        case image
        case table
        case page
        case modal
        case dialog
        case push

        var name: String {
            get {
                switch self {
                case .label: return "Label"
                case .button: return "Button"
                case .textField: return "TextField"
                case .listField: return "ListField"
                case .dateField: return "DateField"
                case .image: return "Image"
                case .table: return "Table"
                case .page: return "Page"
                case .modal: return "Modal"
                case .dialog: return "Dialog"
                case .push: return "Push"
                }
            }
        }
        var detail: String {
            get {
                switch self {
                case .label: return "Pressed to open the QLabel component demonstration screen"
                case .button: return "Pressed to open the QButton component demonstration screen"
                case .textField: return "Pressed to open the QTextField component demonstration screen"
                case .listField: return "Pressed to open the QListField component demonstration screen"
                case .dateField: return "Pressed to open the QDateField component demonstration screen"
                case .image: return "Pressed to open the QImageView component demonstration screen"
                case .table: return "Pressed to open the QTable component demonstration screen"
                case .page: return "Pressed to open the QPageViewController component demonstration screen"
                case .modal: return "Pressed to open the QModalViewController component demonstration screen"
                case .dialog: return "Pressed to open the QDialogViewController component demonstration screen"
                case .push: return "Pressed to open the QPushViewController component demonstration screen"
                }
            }
        }
    }

    // MARK: property

    private(set) var mode: Mode

    // MARK: Init

    init(mode: Mode) {
        self.mode = mode

        super.init(
            composable: QTitleDetailShapeComposable(
                title: QLabelStyleSheet(text: QStyledText(mode.name, style: TextStyle.title)),
                detail: QLabelStyleSheet(text: QStyledText(mode.detail, style: TextStyle.subtitle)),
                shape: DisclosureShape(color: UIColor.black)
            ),
            backgroundColor: UIColor(white: 1, alpha: 1),
            selectedBackgroundColor: UIColor(white: 0, alpha: 0.1)
        )
    }

}
