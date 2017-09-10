//
//  Quickly
//

import Foundation

open class QRegularExpressionStringValidator: QLengthStringValidator {

    public var expression: NSRegularExpression

    public init(expression: NSRegularExpression) {
        self.expression = expression

        super.init()
    }

    public convenience init(pattern: String) throws {
        self.init(expression: try NSRegularExpression(pattern: pattern, options: [ .caseInsensitive ]))
    }

    public override func validate(_ string: String, complete: Bool) -> Bool {
        var valid: Bool = super.validate(string, complete: complete)
        if valid == true && complete == true {
            let stringRange: NSRange = NSRange(location: 0, length: string.characters.count)
            let matchRange: NSRange = self.expression.rangeOfFirstMatch(in: string, options: .reportProgress, range: stringRange)
            valid = matchRange.location == 0 && matchRange.length == string.characters.count
        }
        return valid
    }
}
