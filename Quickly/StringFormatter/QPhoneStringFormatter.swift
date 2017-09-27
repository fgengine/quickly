//
//  Quickly
//

import Foundation

open class QPhoneStringFormatter: IQStringFormatter {

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
        let format: String = self.format(unformat)
        caret = self.formatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: self.prefix.characters.count,
            formatSuffix: 0,
            caret: caret
        )
        return format
    }

    public func unformat(_ format: String) -> String {
        var unformat: String
        if self.prefix.characters.count > 0 {
            let startIndex: String.Index = format.startIndex
            let endIndex: String.Index = format.index(startIndex, offsetBy: self.prefix.characters.count)
            let range: Range< String.Index > = startIndex ..< endIndex
            unformat = format.replacingCharacters(in: range, with: "")
        } else {
            unformat = format
        }
        return unformat.remove(self.decimalDigitsSet)
    }

    public func unformat(_ format: String, caret: inout Int) -> String {
        let unformat: String = self.unformat(format)
        caret = self.unformatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: self.prefix.characters.count,
            formatSuffix: 0,
            caret: caret
        )
        return unformat
    }

}

