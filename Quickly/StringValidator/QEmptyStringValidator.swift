//
//  Quickly
//

open class QEmptyStringValidator : IQStringValidator {
    
    public init() {
    }

    public func validate(_ string: String, complete: Bool) -> Bool {
        return string.count == 0
    }

}
