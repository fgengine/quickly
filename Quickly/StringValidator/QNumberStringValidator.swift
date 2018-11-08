//
//  Quickly
//

open class QNumberStringValidator : QLengthStringValidator {

    open var formatter: NumberFormatter {
        didSet { self.formatter.generatesDecimalNumbers = true }
    }
    open var minimumValue: Decimal?
    open var maximumValue: Decimal?

    public init(
        formatter: NumberFormatter,
        minimumValue: Decimal? = nil,
        maximumValue: Decimal? = nil,
        minimumLength: Int,
        maximumLength: Int? = nil
    ) {
        self.formatter = formatter
        self.formatter.generatesDecimalNumbers = true
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        super.init(
            minimumLength: minimumLength,
            maximumLength: maximumLength
        )
    }

    open override func validate(_ string: String, complete: Bool) -> Bool {
        var valid = super.validate(string, complete: complete)
        if valid == true {
            if let number = self.formatter.number(from: string) as? Decimal {
                if let maximumValue = self.maximumValue {
                    valid = number <= maximumValue
                }
                if valid == true && complete == true {
                    if let minimumValue = self.minimumValue {
                        valid = number >= minimumValue
                    }
                }
            }
        }
        return valid
    }

}
