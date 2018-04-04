//
//  Quickly
//

open class QPhoneStringFormatter : IQStringFormatter {

    public let prefix: String
    public let mask: String
    public let decimalDigitsSet: CharacterSet
    private let fullMask: String!

    public init(prefix: String, mask: String) {
        self.prefix = prefix
        self.mask = mask
        self.fullMask = "\(self.prefix)\(self.mask)"
        self.decimalDigitsSet = CharacterSet.decimalDigits.inverted
    }

    public func format(_ unformat: String) -> String {
        return unformat.applyMask(mask: self.fullMask)
    }

    public func format(_ unformat: String, caret: inout Int) -> String {
        let format = self.format(unformat)
        caret = self.formatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: self.prefix.count,
            formatSuffix: 0,
            caret: caret
        )
        return format
    }

    public func unformat(_ format: String) -> String {
        var unformat: String
        if self.prefix.count > 0 {
            let startIndex = format.startIndex
            let endIndex = format.index(startIndex, offsetBy: self.prefix.count)
            let range = startIndex ..< endIndex
            unformat = format.replacingCharacters(in: range, with: "")
        } else {
            unformat = format
        }
        return unformat.remove(self.decimalDigitsSet)
    }

    public func unformat(_ format: String, caret: inout Int) -> String {
        let unformat = self.unformat(format)
        caret = self.unformatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: self.prefix.count,
            formatSuffix: 0,
            caret: caret
        )
        return unformat
    }

}

