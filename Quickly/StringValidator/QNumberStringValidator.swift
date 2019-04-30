//
//  Quickly
//

open class QNumberStringValidator : QLengthStringValidator {

    open var minimumValue: Decimal?
    open var maximumValue: Decimal?

    public init(
        minimumValue: Decimal? = nil,
        maximumValue: Decimal? = nil,
        minimumLength: Int,
        maximumLength: Int? = nil
    ) {
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
            if let number = NSDecimalNumber.decimalNumber(from: string) {
                let value = number as Decimal
                if let maximumValue = self.maximumValue {
                    valid = value <= maximumValue
                }
                if valid == true && complete == true {
                    if let minimumValue = self.minimumValue {
                        valid = value >= minimumValue
                    }
                }
            }
        }
        return valid
    }

}
