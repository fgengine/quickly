//
//  Quickly
//

open class QCharacterSetStringValidator : IQStringValidator {

    public var characterSet: CharacterSet

    public init(
        characterSet: CharacterSet
    ) {
        self.characterSet = characterSet
    }

    public func validate(_ string: String, complete: Bool) -> Bool {
        return self.characterSet.isSuperset(of: CharacterSet(charactersIn: string))
    }
}
