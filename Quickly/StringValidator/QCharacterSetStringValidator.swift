//
//  Quickly
//

import Foundation

open class QCharacterSetStringValidator: QLengthStringValidator {

    public var characterSet: CharacterSet

    public init(characterSet: CharacterSet) {
        self.characterSet = characterSet

        super.init()
    }

    public override func validate(_ string: String, complete: Bool) -> Bool {
        var valid: Bool = super.validate(string, complete: complete)
        if valid == true {
            valid = self.characterSet.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return valid
    }
}
