//
//  Quickly
//

import Foundation

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
        var errors = Set< String >()
        switch self.mode {
        case .and:
            for validator in self.validators {
                let result = validator.validate(string)
                if result.isValid == false {
                    for error in result.errors {
                        errors.insert(error)
                    }
                }
            }
        case .or:
            for validator in self.validators {
                let result = validator.validate(string)
                if result.isValid == true {
                    break
                } else {
                    for error in result.errors {
                        errors.insert(error)
                    }
                }
            }
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }

}
