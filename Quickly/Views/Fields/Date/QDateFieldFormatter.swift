//
//  Quickly
//

import UIKit

public class QDateFieldFormatter : IQDateFieldFormatter {

    public private(set) var formatter: DateFormatter
    public private(set) var textStyle: IQTextStyle
    
    public init(formatter: DateFormatter, textStyle: IQTextStyle) {
        self.formatter = formatter
        self.textStyle = textStyle
    }
    
    public convenience init(textStyle: IQTextStyle) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        
        self.init(formatter: formatter, textStyle: textStyle)
    }

    public convenience init(dateFormat: String, textStyle: IQTextStyle) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        self.init(formatter: formatter, textStyle: textStyle)
    }

    public func from(_ date: Date) -> IQText {
        let string = self.formatter.string(from: date)
        return QAttributedText(text: string, style: self.textStyle)
    }

}
