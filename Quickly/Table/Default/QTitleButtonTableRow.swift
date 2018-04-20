//
//  Quickly
//

open class QTitleButtonTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonIsSpinnerAnimating: Bool

    public init(title: QLabelStyleSheet, button: QButtonStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.title = title
        self.titleSpacing = 0
        self.button = button
        self.buttonHeight = 44
        self.buttonIsSpinnerAnimating = false

        super.init()
    }

}
