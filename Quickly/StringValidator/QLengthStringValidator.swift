//
//  Quickly
//

open class QLengthStringValidator : IQStringValidator {

    public let minimumLength: Int
    public let minimumError: String
    public let maximumLength: Int?
    public let maximumError: String?
    
    public init(
        length: Int,
        error: String
    ) {
        self.minimumLength = length
        self.minimumError = error
        self.maximumLength = length
        self.maximumError = error
    }
    
    public init(
        minimumLength: Int,
        minimumError: String
    ) {
        self.minimumLength = minimumLength
        self.minimumError = minimumError
        self.maximumLength = nil
        self.maximumError = nil
    }
    
    public init(
        minimumLength: Int,
        minimumError: String,
        maximumLength: Int,
        maximumError: String
    ) {
        self.minimumLength = minimumLength
        self.minimumError = minimumError
        self.maximumLength = maximumLength
        self.maximumError = maximumError
    }

    public func validate(_ string: String) -> QStringValidatorResult {
        var errors = Set< String >()
        if let maximumLength = self.maximumLength, let maximumError = self.maximumError {
            if self.minimumLength == maximumLength {
                if string.count != maximumLength {
                    errors.insert(maximumError)
                }
            } else {
                if string.count < self.minimumLength {
                    errors.insert(self.minimumError)
                }
                if string.count > maximumLength {
                    errors.insert(maximumError)
                }
            }
        } else {
            if string.count < self.minimumLength {
                errors.insert(self.minimumError)
            }
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }

}
