//
//  Quickly
//

import Foundation

open class QCardNumberStringFormatter: IQStringFormatter {

    public init() {
    }

    public func format(_ unformat: String, caret: inout Int) -> String {
        var format: String = String()
        var unformatOffset: Int = 0
        while unformatOffset < unformat.characters.count {
            let unformatIndex: String.Index = unformat.characters.index(unformat.startIndex, offsetBy: unformatOffset)
            let unformatCharacter: Character = unformat[unformatIndex]
            if unformatOffset != 0 && unformatOffset % 4 == 0 {
                format.append(" ")
            }
            format.append(unformatCharacter)
            unformatOffset += 1
        }
        caret = self.formatDifferenceCaret(
            unformat: unformat,
            format: format,
            formatPrefix: 0,
            formatSuffix: 0,
            caret: caret
        )
        return format
    }

    public func unformat(_ format: String, caret: inout Int) -> String {
        let unformat: String = format.replacingOccurrences(of: " ", with: "")
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
