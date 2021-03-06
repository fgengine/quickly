//
//  Quickly
//

open class QCardExpirationDateStringFormatter : IQStringFormatter {

    public init() {
    }

    public func format(_ unformat: String) -> String {
        var format = String()
        var unformatOffset = 0
        while unformatOffset < unformat.count {
            let unformatIndex = unformat.index(unformat.startIndex, offsetBy: unformatOffset)
            let unformatCharacter = unformat[unformatIndex]
            format.append(unformatCharacter)
            if unformatOffset == 1 {
                format.append("/")
            }
            unformatOffset += 1
        }
        return format
    }

    public func format(_ unformat: String, caret: inout Int) -> String {
        let format = self.format(unformat)
        caret = self.formatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: 0,
            formatSuffix: 0,
            caret: caret
        )
        return format
    }

    public func unformat(_ format: String) -> String {
        return format.replacingOccurrences(of: "/", with: "")
    }

    public func unformat(_ format: String, caret: inout Int) -> String {
        let unformat = self.unformat(format)
        caret = self.unformatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: 0,
            formatSuffix: 0,
            caret: caret
        )
        return unformat
    }

}
