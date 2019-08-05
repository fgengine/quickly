//
//  Quickly
//

open class QListFieldStyleSheet : QDisplayStyleSheet {
    
    public var form: IQFieldForm?
    public var rows: [QListFieldPickerRow]
    public var rowHeight: CGFloat
    public var placeholder: IQText?
    public var isEnabled: Bool
    public var toolbarStyle: QToolbarStyleSheet?
    public var toolbarActions: QFieldAction
    
    public init(
        form: IQFieldForm? = nil,
        rows: [QListFieldPickerRow],
        rowHeight: CGFloat = 40,
        placeholder: IQText? = nil,
        isEnabled: Bool = true,
        toolbarStyle: QToolbarStyleSheet? = nil,
        toolbarActions: QFieldAction = [ .cancel, .done ],
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.form = form
        self.rows = rows
        self.rowHeight = rowHeight
        self.placeholder = placeholder
        self.isEnabled = isEnabled
        self.toolbarStyle = toolbarStyle
        self.toolbarActions = toolbarActions
        
        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }
    
    public init(_ styleSheet: QListFieldStyleSheet) {
        self.form = styleSheet.form
        self.rows = styleSheet.rows
        self.rowHeight = styleSheet.rowHeight
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled
        self.toolbarStyle = styleSheet.toolbarStyle
        self.toolbarActions = styleSheet.toolbarActions
        
        super.init(styleSheet)
    }
    
}
