//
//  Quickly
//

open class QLogicStringValidator : IQStringValidator {
    
    public enum Mode {
        case and
        case or
    }

    public let mode: Mode
    public let validators: [IQStringValidator]
    
    public init(
        mode: Mode,
        validators: [IQStringValidator]
    ) {
        self.mode = mode
        self.validators = validators
    }

    public func validate(_ string: String) -> QStringValidatorResult {
        var errors: [String] = []
        switch self.mode {
        case .and:
            for validator in self.validators {
                let result = validator.validate(string)
                if result.isValid == false {
                    errors.append(contentsOf: result.errors)
                }
            }
        case .or:
            for validator in self.validators {
                let result = validator.validate(string)
                if result.isValid == true {
                    break
                } else {
                    errors.append(contentsOf: result.errors)
                }
            }
        }
        return QStringValidatorResult(
            errors: errors
        )
    }

}
