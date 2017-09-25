//
//  Quickly
//

import Foundation

public class QPhoneStringFormatter: IQStringFormatter {

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

    public func unformat(_ format: String, caret: inout Int) -> String {
        var unformat: String = format
        if unformat.hasPrefix(self.prefix) == true {
            let startIndex: String.Index = unformat.startIndex
            let endIndex: String.Index = unformat.index(startIndex, offsetBy: self.prefix.characters.count)
            let range: Range< String.Index > = startIndex..<endIndex
            unformat = unformat.replacingCharacters(in: range, with: "")
        }
        unformat = unformat.components(separatedBy: self.characterSet).joined()
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
