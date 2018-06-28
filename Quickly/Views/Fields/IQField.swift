//
//  Quickly
//

public protocol IQField : class {

    var isValid: Bool { get }
    var placeholder: IQText?  { set get }
    var isEnabled: Bool { set get }
    var isEditing: Bool { get }

    func beginEditing()

}

public typealias QFieldType = UIView & IQField
