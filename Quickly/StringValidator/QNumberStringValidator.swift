//
//  Quickly
//

import Foundation

open class QNumberStringValidator : IQStringValidator {

    public var minimumValue: Decimal?
    public let minimumError: String?
    public var maximumValue: Decimal?
    public let maximumError: String?
    public let notNumberError: String

    public init(
        minimumValue: Decimal,
        minimumError: String,
        notNumberError: String
    ) {
        self.minimumValue = minimumValue
        self.minimumError = minimumError
        self.maximumValue = nil
        self.maximumError = nil
        self.notNumberError = notNumberError
    }

    public init(
        maximumValue: Decimal,
        maximumError: String,
        notNumberError: String
    ) {
        self.minimumValue = nil
        self.minimumError = nil
        self.maximumValue = maximumValue
        self.maximumError = maximumError
        self.notNumberError = notNumberError
    }

    public init(
        minimumValue: Decimal,
        minimumError: String,
        maximumValue: Decimal,
        maximumError: String,
        notNumberError: String
    ) {
        self.minimumValue = minimumValue
        self.minimumError = minimumError
        self.maximumValue = maximumValue
        self.maximumError = maximumError
        self.notNumberError = notNumberError
    }

    open func validate(_ string: String) -> QStringValidatorResult {
        var errors = Set< String >()
        if let number = NSDecimalNumber.decimalNumber(from: string) {
            let value = number as Decimal
            if let limit = self.minimumValue, let error = self.minimumError {
                if value < limit {
                    errors.insert(error)
                }
            }
            if let limit = self.maximumValue, let error = self.maximumError {
                if value > limit {
                    errors.insert(error)
                }
            }
        } else {
            errors.insert(self.notNumberError)
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }

}
