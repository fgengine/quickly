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
        if unformat.characters.count > 0 {
            let formatCharacters: String.CharacterView = format.characters
            let unformatCharacters: String.CharacterView = unformat.characters
            var formatIndex: String.Index = formatCharacters.index(formatCharacters.startIndex, offsetBy: formatPrefix)
            let formatEndIndex: String.Index = formatCharacters.index(formatCharacters.endIndex, offsetBy: -formatSuffix)
            var unformatIndex: String.Index = unformatCharacters.startIndex
            let unformatEndIndex: String.Index = unformatCharacters.endIndex
            var formatOffset: Int = formatPrefix
            var unformatOffset: Int = 0
            while formatIndex < formatEndIndex {
                let formatCharacter: Character = formatCharacters[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter: Character = unformatCharacters[unformatIndex]
                    if formatCharacter == unformatCharacter {
                        unformatIndex = unformatCharacters.index(unformatIndex, offsetBy: 1)
                        unformatOffset += 1
                    } else {
                        formatOffset += 1
                    }
                } else {
                    formatOffset += 1
                }
                formatIndex = formatCharacters.index(formatIndex, offsetBy: 1)
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
        if unformat.characters.count > 0 {
            let formatCharacters: String.CharacterView = format.characters
            let unformatCharacters: String.CharacterView = unformat.characters
            var formatIndex: String.Index = formatCharacters.index(formatCharacters.startIndex, offsetBy: formatPrefix)
            let formatEndIndex: String.Index = formatCharacters.index(formatCharacters.endIndex, offsetBy: -formatSuffix)
            var unformatIndex: String.Index = unformatCharacters.startIndex
            let unformatEndIndex: String.Index = unformatCharacters.endIndex
            var formatOffset: Int = formatPrefix
            var unformatOffset: Int = 0
            while formatIndex < formatEndIndex {
                let formatCharacter: Character = formatCharacters[formatIndex]
                if unformatIndex < unformatEndIndex {
                    let unformatCharacter: Character = unformatCharacters[unformatIndex]
                    if formatCharacter == unformatCharacter {
                        unformatIndex = unformatCharacters.index(unformatIndex, offsetBy: 1)
                        unformatOffset += 1
                    } else {
                        formatOffset += 1
                    }
                } else {
                    formatOffset += 1
                }
                formatIndex = formatCharacters.index(formatIndex, offsetBy: 1)
                if unformatOffset >= caret {
                    break
                }
            }
            if formatOffset > 0 {
                result += formatOffset
            }
        } else {
            result = format.characters.count
        }
        return result
    }

}
