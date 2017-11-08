//
//  Quickly
//

public protocol IQStringFormatter {

    func format(_ unformat: String) -> String
    func format(_ unformat: String, caret: inout Int) -> String
    func unformat(_ format: String) -> String
    func unformat(_ format: String, caret: inout Int) -> String

}

public extension IQStringFormatter {

    public func unformatDifferenceCaret(
        unformat: String,
        format: String,
        formatPrefix: Int,
        formatSuffix: Int,
        caret: Int
    ) -> Int {
        var result: Int = caret
        if unformat.count > 0 {
            var formatIndex: String.Index = format.index(format.startIndex, offsetBy: formatPrefix)
            let formatEndIndex: String.Index = format.index(format.endIndex, offsetBy: -formatSuffix)
            var unformatIndex: String.Index = unformat.startIndex
            let unformatEndIndex: String.Index = unformat.endIndex
            var formatOffset: Int = formatPrefix
            var unformatOffset: Int = 0
            while formatIndex < formatEndIndex {
                let formatCharacter: Character = format[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter: Character = unformat[unformatIndex]
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

    public func formatDifferenceCaret(
        unformat: String,
        format: String,
        formatPrefix: Int,
        formatSuffix: Int,
        caret: Int
    ) -> Int {
        var result: Int = caret
        if unformat.count > 0 {
            var formatIndex: String.Index = format.index(format.startIndex, offsetBy: formatPrefix)
            let formatEndIndex: String.Index = format.index(format.endIndex, offsetBy: -formatSuffix)
            var unformatIndex: String.Index = unformat.startIndex
            let unformatEndIndex: String.Index = unformat.endIndex
            var formatOffset: Int = formatPrefix
            var unformatOffset: Int = 0
            while formatIndex < formatEndIndex {
                let formatCharacter: Character = format[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter: Character = unformat[unformatIndex]
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
