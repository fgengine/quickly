//
//  Quickly
//

open class QLengthStringValidator : IQStringValidator {

    public var minimumLength: Int
    public var maximumLength: Int?
    
    public init(
        minimumLength: Int,
        maximumLength: Int? = nil
    ) {
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }

    public func validate(_ string: String, complete: Bool) -> Bool {
        var valid = true
        if complete == true {
            valid = (string.count >= self.minimumLength)
        }
        if valid == true {
            if let maximumLength = self.maximumLength {
                valid = (string.count <= maximumLength)
            }
        }
        return valid
    }

}
