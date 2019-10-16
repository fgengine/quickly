//
//  Quickly
//

public final class QInputValidator : IQInputValidator {

    public private(set) var validator: IQStringValidator

    public init(validator: IQStringValidator) {
        self.validator = validator
    }

    public func validate(_ string: String) -> Bool {
        return self.validator.validate(string, complete: true)
    }

}
