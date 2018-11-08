//
//  Quickly
//

open class QCharacterSetStringValidator : QLengthStringValidator {

    public var characterSet: CharacterSet

    public init(
        characterSet: CharacterSet,
        minimumLength: Int,
        maximumLength: Int? = nil
    ) {
        self.characterSet = characterSet
        super.init(
            minimumLength: minimumLength,
            maximumLength: maximumLength
        )
    }

    public override func validate(_ string: String, complete: Bool) -> Bool {
        var valid = super.validate(string, complete: complete)
        if valid == true {
            valid = self.characterSet.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return valid
    }
}
