//
//  Quickly
//

open class QLogicStringValidator : IQStringValidator {
    
    public enum Mode {
        case and
        case or
    }

    public private(set) var mode: Mode
    public private(set) var validators: [IQStringValidator]
    
    public init(
        mode: Mode,
        validators: [IQStringValidator]
    ) {
        self.mode = mode
        self.validators = validators
    }

    public func validate(_ string: String, complete: Bool) -> Bool {
        switch self.mode {
        case .and:
            for validator in self.validators {
                if validator.validate(string, complete: complete) == false {
                    return false
                }
            }
            return true
        case .or:
            for validator in self.validators {
                if validator.validate(string, complete: complete) == true {
                    return true
                }
            }
            return false
        }
    }

}
