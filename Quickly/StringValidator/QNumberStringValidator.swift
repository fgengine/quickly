//
//  Quickly
//

open class QNumberStringValidator : IQStringValidator {

    open var minimumValue: Decimal?
    open var maximumValue: Decimal?

    public init(
        minimumValue: Decimal? = nil,
        maximumValue: Decimal? = nil
    ) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    open func validate(_ string: String, complete: Bool) -> Bool {
        var valid = true
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
        return valid
    }

}
