//
//  Quickly
//

import Foundation

public protocol IQStringFormatter {

    func format(_ unformat: String) -> String
    func format(_ unformat: String, caret: inout Int) -> String
    func unformat(_ format: String) -> String
    func unformat(_ format: String, caret: inout Int) -> String

}

public extension IQStringFormatter {

    func unformatDifferenceCaret(
        unformat: String,
        format: String,
        formatPrefix: Int,
        formatSuffix: Int,
        caret: Int
    ) -> Int {
        var result = caret
        if unformat.count > 0 {
            var formatIndex = format.index(format.startIndex, offsetBy: formatPrefix)
            let formatEndIndex = format.index(format.endIndex, offsetBy: -formatSuffix)
            var unformatIndex = unformat.startIndex
            let unformatEndIndex = unformat.endIndex
            var formatOffset = formatPrefix
            var unformatOffset = 0
            while formatIndex < formatEndIndex {
                let formatCharacter = format[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter = unformat[unformatIndex]
                    if formatCharacter == unformatCharacter {
                        unformatIndex = unformat.index(unformatIndex, offsetBy: 1)
                        unformatOffset += 1
                    } else {
                        formatOffset += 1
                    }
                } else {
                    formatOffset += 1
                }
                formatIndex = format.index(formatIndex, offsetBy: 1)
                if formatOffset + unformatOffset >= caret {
                    break
                }
            }
            if formatOffset > 0 {
                result -= formatOffset
            }
        } else {
            result = formatPrefix
        }
        return result
    }

    func formatDifferenceCaret(
        unformat: String,
        format: String,
        formatPrefix: Int,
        formatSuffix: Int,
        caret: Int
    ) -> Int {
        var result = caret
        if unformat.count > 0 {
            var formatIndex = format.index(format.startIndex, offsetBy: formatPrefix)
            let formatEndIndex = format.index(format.endIndex, offsetBy: -formatSuffix)
            var unformatIndex = unformat.startIndex
            let unformatEndIndex = unformat.endIndex
            var formatOffset = formatPrefix
            var unformatOffset = 0
            while formatIndex < formatEndIndex {
                let formatCharacter = format[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter = unformat[unformatIndex]
                    if formatCharacter == unformatCharacter {
                        unformatIndex = unformat.index(unformatIndex, offsetBy: 1)
                        unformatOffset += 1
                    } else {
                        formatOffset += 1
                    }
                } else {
                    formatOffset += 1
                }
                formatIndex = format.index(formatIndex, offsetBy: 1)
                if unformatOffset >= caret {
                    break
                }
            }
            if formatOffset > 0 {
                result += formatOffset
            }
        } else {
            result = format.count
        }
        return result
    }

}
