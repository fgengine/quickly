//
//  Quickly
//

import Quickly

class ChoiseSectionTableRow: QLabelTableRow {

    // MARK: Enum

    public enum Mode {
        case label
        case button

        public var name: String {
            get {
                switch self {
                case .label: return "Label"
                case .button: return "Button"
                }
            }
        }
    }

    // MARK: Public property

    public private(set) var mode: Mode

    // MARK: Init

    public init(mode: Mode) {
        self.mode = mode

        super.init(
            text: QStyledText(mode.name, style: TextStyle.base),
            edgeInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        )
    }

}
