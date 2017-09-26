//
//  Quickly
//

import Foundation

open class QPhoneStringFormatter: IQStringFormatter {

    public var prefix: String {
        didSet { self.fullMask = self.prepareFullMask() }
    }
    public var mask: String {
        didSet { self.fullMask = self.prepareFullMask() }
    }
    public var characterSet: CharacterSet
    private var fullMask: String!

    public init(prefix: String, mask: String) {
        self.prefix = prefix
        self.mask = mask
        self.characterSet = CharacterSet.decimalDigits.inverted
        self.fullMask = self.prepareFullMask()
    }

    public func format(_ unformat: String, caret: inout Int) -> String {
        let format: String = unformat.applyMask(mask: self.fullMask)
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
            let range: Range< String.Index > = startIndex..<endIndex
            unformat = format.replacingCharacters(in: range, with: "")
        } else {
            unformat = format
        }
        return unformat.components(separatedBy: self.characterSet).joined()
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

    private func prepareFullMask() -> String {
        return "\(self.prefix)\(self.mask)"
    }

}

