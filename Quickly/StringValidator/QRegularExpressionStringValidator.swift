//
//  Quickly
//

open class QRegularExpressionStringValidator : IQStringValidator {

    public var expression: NSRegularExpression

    public init(
        expression: NSRegularExpression
    ) {
        self.expression = expression
    }

    public convenience init(
        pattern: String
    ) throws {
        self.init(
            expression: try NSRegularExpression(pattern: pattern, options: [ .caseInsensitive ])
        )
    }

    public func validate(_ string: String, complete: Bool) -> Bool {
        var valid = true
        if complete == true {
            let stringRange = NSRange(location: 0, length: string.count)
            let matchRange = self.expression.rangeOfFirstMatch(in: string, options: .reportProgress, range: stringRange)
            valid = matchRange.location == 0 && matchRange.length == string.count
        }
        return valid
    }
}
