//
//  Quickly
//

open class QEmptyStringValidator : IQStringValidator {
    
    public let error: String
    
    public init(
        error: String
    ) {
        self.error = error
    }

    public func validate(_ string: String) -> QStringValidatorResult {
        var errors: [String] = []
        if string.count == 0 {
            errors.append(self.error)
        }
        return QStringValidatorResult(errors: errors)
    }

}
