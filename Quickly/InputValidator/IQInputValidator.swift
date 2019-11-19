//
//  Quickly
//

public protocol IQInputValidator {

    func validate(_ string: String) -> Bool
    func messages(_ string: String) -> [String]

}
