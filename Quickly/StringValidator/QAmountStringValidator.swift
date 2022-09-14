//
//  Quickly
//

import Foundation

open class QAmountStringValidator : QRegularExpressionStringValidator {

    public init(
        maximumSimbol: Int,
        decimalSeparator: String,
        maximumDecimalSimbol: Int,
        error: String
    ) throws {
        var patterns: [String] = []
        patterns.append("^0$")
        patterns.append("^[1-9][0-9]{0,\(maximumSimbol - 1)}$")
        if decimalSeparator.count > 0 && maximumDecimalSimbol > 0 {
            patterns.append("^0\\\(decimalSeparator)$")
            patterns.append("^0\\\(decimalSeparator)[0-9]{0,\(maximumDecimalSimbol)}$")
            patterns.append("^[1-9][0-9]{0,\(maximumSimbol - 1)}\\\(decimalSeparator)$")
            patterns.append("^[1-9][0-9]{0,\(maximumSimbol - 1)}\\\(decimalSeparator)[0-9]{0,\(maximumDecimalSimbol)}$")
        }
        super.init(
            expression: try NSRegularExpression(pattern: patterns.joined(separator: "|"), options: [ .caseInsensitive ]),
            error: error
        )
    }

    public convenience init(
        maximumSimbol: Int,
        locale: Locale,
        maximumDecimalSimbol: Int,
        error: String
    ) throws {
        try self.init(
            maximumSimbol: maximumSimbol,
            decimalSeparator: locale.decimalSeparator ?? ".",
            maximumDecimalSimbol: maximumDecimalSimbol,
            error: error
        )
    }

    public override func validate(_ string: String) -> QStringValidatorResult {
        return super.validate(string)
    }

}
