//
//  Quickly
//

import Quickly

class ChoiseSectionTableRow: QTitleDetailShapeTableRow {

    // MARK: Enum

    public enum Mode {
        case label
        case button
        case textField
        case image
        case dialog
        case push

        public var name: String {
            get {
                switch self {
                case .label: return "Label"
                case .button: return "Button"
                case .textField: return "TextField"
                case .image: return "Image"
                case .dialog: return "Dialog"
                case .push: return "Push"
                }
            }
        }
        public var detail: String {
            get {
                switch self {
                case .label: return "Pressed to open the QLabel component demonstration screen"
                case .button: return "Pressed to open the QButton component demonstration screen"
                case .textField: return "Pressed to open the QTextField component demonstration screen"
                case .image: return "Pressed to open the QImageView component demonstration screen"
                case .dialog: return "Pressed to open the QDialogViewController component demonstration screen"
                case .push: return "Pressed to open the QPushViewController component demonstration screen"
                }
            }
        }
    }

    // MARK: Public property

    public private(set) var mode: Mode

    // MARK: Init

    public init(mode: Mode) {
        self.mode = mode

        super.init()

        self.selectedBackgroundColor = UIColor(white: 0, alpha: 0.1)
        self.edgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.titleText = QStyledText(mode.name, style: TextStyle.title)
        self.titleSpacing = 4
        self.detailText = QStyledText(mode.detail, style: TextStyle.subtitle)
        self.detailSpacing = 8
        self.shapeModel = DisclosureShape(color: UIColor.black)
    }

}
