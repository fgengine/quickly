//
//  Quickly
//

open class QMaskStringFormatter : IQStringFormatter {

    public let mask: String
    public let characterSet: CharacterSet

    public init(mask: String, characterSet: CharacterSet = CharacterSet.decimalDigits.inverted) {
        self.mask = mask
        self.characterSet = characterSet
    }

    public func format(_ unformat: String) -> String {
        return unformat.format(mask: self.mask)
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
        return format.remove(self.characterSet)
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

