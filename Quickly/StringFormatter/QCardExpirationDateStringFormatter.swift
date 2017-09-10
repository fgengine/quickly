//
//  Quickly
//

import Foundation

public class QCardExpirationDateStringFormatter: IQStringFormatter {

    public init() {
    }

    public func format(_ string: String) -> String {
        var result: String = String()
        var index: Int = 0
        while index < string.characters.count {
            let stringIndex: String.Index = string.characters.index(string.startIndex, offsetBy: index)
            let character: Character = string[stringIndex]
            result.append(character)
            if index == 1 {
                result.append("/")
            }
            index += 1
        }
        return result
    }

    public func unformat(_ string: String) -> String {
        return string.replacingOccurrences(of: "/", with: "")
    }

}
