//
//  Quickly
//

import Foundation

open class QAmountStringFormatter: IQStringFormatter {

    public let groupingSeparator: String
    public let numberOfGrouping: Int
    public let decimalSeparator: String
    public let decimalDigitsSet: CharacterSet

    public init(
        groupingSeparator: String,
        numberOfGrouping: Int,
        decimalSeparator: String
    ) {
        self.groupingSeparator = groupingSeparator
        self.numberOfGrouping = numberOfGrouping
        self.decimalSeparator = decimalSeparator
        self.decimalDigitsSet = CharacterSet.decimalDigits.inverted
    }

    public convenience init(locale: Locale) {
        self.init(
            groupingSeparator: locale.groupingSeparator ?? "",
            numberOfGrouping: 3,
            decimalSeparator: locale.decimalSeparator ?? ""
        )
    }

    public func format(_ unformat: String) -> String {
        var format: String = String()
        let parts: [String] = unformat.components(separatedBy: self.decimalSeparator)
        if parts.count == 2 {
            let firstPart: String = parts.first!
            let firstPartLength: Int = firstPart.characters.count
            if firstPartLength > self.numberOfGrouping {
                var firstPartIndex: String.Index = firstPart.startIndex
                let numberOfGroups = firstPartLength / self.numberOfGrouping
                let numberOfFirstGroups = firstPartLength - (numberOfGroups * self.numberOfGrouping)
                for _ in 0 ..< numberOfFirstGroups {
                    format.append(firstPart[firstPartIndex])
                    firstPartIndex = firstPart.index(firstPartIndex, offsetBy: 1)
                }
                if numberOfFirstGroups > 0 && numberOfGroups > 0 {
                    format.append(self.groupingSeparator)
                }
                for groupIndex: Int in 0 ..< numberOfGroups {
                    for _ in 0 ..< self.numberOfGrouping {
                        format.append(firstPart[firstPartIndex])
                        firstPartIndex = firstPart.index(firstPartIndex, offsetBy: 1)
                    }
                    if groupIndex != numberOfGroups - 1 {
                        format.append(self.groupingSeparator)
                    }
                }
            } else {
                format.append(firstPart)
            }
            format.append(self.decimalSeparator)
            format.append(parts.last!)
        } else {
            let unformatLength: Int = unformat.characters.count
            if unformatLength > self.numberOfGrouping {
                var unformatIndex: String.Index = unformat.startIndex
                let numberOfGroups = unformatLength / self.numberOfGrouping
                let numberOfFirstGroups = unformatLength - (numberOfGroups * self.numberOfGrouping)
                for _ in 0 ..< numberOfFirstGroups {
                    format.append(unformat[unformatIndex])
                    unformatIndex = unformat.index(unformatIndex, offsetBy: 1)
                }
                if numberOfFirstGroups > 0 && numberOfGroups > 0 {
                    format.append(self.groupingSeparator)
                }
                for groupIndex: Int in 0 ..< numberOfGroups {
                    for _ in 0 ..< self.numberOfGrouping {
                        format.append(unformat[unformatIndex])
                        unformatIndex = unformat.index(unformatIndex, offsetBy: 1)
                    }
                    if groupIndex != numberOfGroups - 1 {
                        format.append(self.groupingSeparator)
                    }
                }
            } else {
                format.append(unformat)
            }
        }
        return format
    }

    public func format(_ unformat: String, caret: inout Int) -> String {
        let format: String = self.format(unformat)
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
        var unformat: String
        let parts: [String] = format.components(separatedBy: self.decimalSeparator)
        if parts.count == 2 {
            let firstPart: String = parts.first!.remove(self.decimalDigitsSet)
            let lastPart: String = parts.last!.remove(self.decimalDigitsSet)
            unformat = "\(firstPart)\(decimalSeparator)\(lastPart)"
        } else {
            unformat = format.remove(self.decimalDigitsSet)
        }
        return unformat
    }

    public func unformat(_ format: String, caret: inout Int) -> String {
        let unformat: String = self.unformat(format)
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

