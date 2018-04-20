//
//  Quickly
//

open class QButtonTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonIsSpinnerAnimating: Bool

    public init(button: QButtonStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.button = button
        self.buttonHeight = 44
        self.buttonIsSpinnerAnimating = false

        super.init()
    }

}
