//
//  Quickly
//

import Foundation

open class QNumberStringValidator: QLengthStringValidator {

    open var formatter: NumberFormatter {
        didSet { self.formatter.generatesDecimalNumbers = true }
    }
    open var maximumValue: Decimal?
    open var minimumValue: Decimal?

    public override init() {
        self.formatter = NumberFormatter()
        self.formatter.generatesDecimalNumbers = true
        super.init()
    }

    public init(formatter: NumberFormatter) {
        self.formatter = formatter
        self.formatter.generatesDecimalNumbers = true
        super.init()
    }

    open override func validate(_ string: String, complete: Bool) -> Bool {
        var valid: Bool = super.validate(string, complete: complete)
        if valid == true {
            if let number: Decimal = self.formatter.number(from: string) as? Decimal {
                if let maximumValue: Decimal = self.maximumValue {
                    valid = number <= maximumValue
                }
                if valid == true && complete == true {
                    if let minimumValue: Decimal = self.minimumValue {
                        valid = number >= minimumValue
                    }
                }
            }
        }
        return valid
    }

}
