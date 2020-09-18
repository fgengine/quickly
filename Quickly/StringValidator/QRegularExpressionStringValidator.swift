//
//  Quickly
//

open class QRegularExpressionStringValidator : IQStringValidator {

    public let expression: NSRegularExpression
    public let error: String

    public init(
        expression: NSRegularExpression,
        error: String
    ) {
        self.expression = expression
        self.error = error
    }

    public convenience init(
        pattern: String,
        error: String
    ) throws {
        self.init(
            expression: try NSRegularExpression(pattern: pattern, options: [ .caseInsensitive ]),
            error: error
        )
    }

    public func validate(_ string: String) -> QStringValidatorResult {
        var errors = Set< String >()
        let range = NSRange(location: 0, length: string.count)
        let match = self.expression.rangeOfFirstMatch(in: string, options: .reportProgress, range: range)
        if match.location == NSNotFound && match.length == 0 {
            errors.insert(self.error)
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }
}
