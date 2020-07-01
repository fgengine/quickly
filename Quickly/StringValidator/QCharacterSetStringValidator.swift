//
//  Quickly
//

open class QCharacterSetStringValidator : IQStringValidator {

    public let characterSet: CharacterSet
    public let error: String

    public init(
        characterSet: CharacterSet,
        error: String
    ) {
        self.characterSet = characterSet
        self.error = error
    }

    public func validate(_ string: String) -> QStringValidatorResult {
        var errors = Set< String >()
        if self.characterSet.isSuperset(of: CharacterSet(charactersIn: string)) == false {
            errors.insert(self.error)
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }
}
