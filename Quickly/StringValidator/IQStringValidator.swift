//
//  Quickly
//

public protocol IQStringValidator {

    func validate(_ string: String) -> QStringValidatorResult
    
}

public struct QStringValidatorResult {

    public var isValid: Bool {
        get { return self.errors.count == 0 }
    }
    public let errors: [String]
    
    public init(errors: [String]) {
        self.errors = errors
    }
    
}
