//
//  Quickly
//

public class QDateFieldFormatter : IQDateFieldFormatter {

    public var formatter: DateFormatter
    public var textStyle: QTextStyle?
    
    public init() {
        self.formatter = DateFormatter()
        self.formatter.dateStyle = .full
        self.formatter.timeStyle = .full
    }

    public init(_ formatter: DateFormatter) {
        self.formatter = formatter
    }

    public convenience init(dateFormat: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        self.init(formatter)
    }

    public func from(_ date: Date) -> IQText {
        let string = self.formatter.string(from: date)
        guard let textStyle = self.textStyle else {
            return QText(string)
        }
        return QStyledText(string, style: textStyle)
    }

}
