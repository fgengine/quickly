//
//  Quickly
//

import Foundation

public class QCardNumberStringFormatter: IQStringFormatter {

    public init() {
    }

    public func format(_ string: String) -> String {
        var result: String = String()
        var index: Int = 0
        while index < string.characters.count {
            let stringIndex: String.Index = string.characters.index(string.startIndex, offsetBy: index)
            let character: Character = string[stringIndex]
            if index != 0 && index % 4 == 0 {
                result.append(" ")
            }
            result.append(character)
            index += 1
        }
        return result
    }

    public func unformat(_ string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }

}
