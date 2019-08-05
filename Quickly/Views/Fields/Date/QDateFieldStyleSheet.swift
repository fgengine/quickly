//
//  Quickly
//

open class QDateFieldStyleSheet : QDisplayStyleSheet {
    
    public var form: IQFieldForm?
    public var formatter: IQDateFieldFormatter
    public var mode: QDateFieldMode
    public var calendar: Calendar?
    public var locale: Locale?
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var placeholder: IQText?
    public var isEnabled: Bool
    public var toolbarStyle: QToolbarStyleSheet?
    public var toolbarActions: QFieldAction
    
    public init(
        form: IQFieldForm? = nil,
        formatter: IQDateFieldFormatter,
        mode: QDateFieldMode = .date,
        calendar: Calendar? = nil,
        locale: Locale? = nil,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
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
        self.formatter = formatter
        self.mode = mode
        self.calendar = calendar
        self.locale = locale
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
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
    
    public init(_ styleSheet: QDateFieldStyleSheet) {
        self.form = styleSheet.form
        self.formatter = styleSheet.formatter
        self.mode = styleSheet.mode
        self.calendar = styleSheet.calendar
        self.locale = styleSheet.locale
        self.minimumDate = styleSheet.minimumDate
        self.maximumDate = styleSheet.maximumDate
        self.placeholder = styleSheet.placeholder
        self.isEnabled = styleSheet.isEnabled
        self.toolbarStyle = styleSheet.toolbarStyle
        self.toolbarActions = styleSheet.toolbarActions
        
        super.init(styleSheet)
    }
    
}
