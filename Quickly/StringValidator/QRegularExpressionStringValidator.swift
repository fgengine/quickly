//
//  Quickly
//

open class QRegularExpressionStringValidator : QLengthStringValidator {

    public var expression: NSRegularExpression

    public init(
        expression: NSRegularExpression,
        minimumLength: Int,
        maximumLength: Int? = nil
    ) {
        self.expression = expression
        super.init(
            minimumLength: minimumLength,
            maximumLength: maximumLength
        )
    }

    public convenience init(
        pattern: String,
        minimumLength: Int,
        maximumLength: Int? = nil
    ) throws {
        self.init(
            expression: try NSRegularExpression(pattern: pattern, options: [ .caseInsensitive ]),
            minimumLength: minimumLength,
            maximumLength: maximumLength
        )
    }

    public override func validate(_ string: String, complete: Bool) -> Bool {
        var valid = super.validate(string, complete: complete)
        if valid == true && complete == true {
            let stringRange = NSRange(location: 0, length: string.count)
            let matchRange = self.expression.rangeOfFirstMatch(in: string, options: .reportProgress, range: stringRange)
            valid = matchRange.location == 0 && matchRange.length == string.count
        }
        return valid
    }
}
