//
//  Quickly
//

import UIKit

public struct QFieldAction : OptionSet {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let cancel = QFieldAction(rawValue: 1 << 0)
    public static let done = QFieldAction(rawValue: 1 << 1)
    
}

public protocol IQField : AnyObject {

    var isValid: Bool { get }
    var placeholder: IQText?  { set get }
    var isEnabled: Bool { set get }
    var isEditing: Bool { get }
    var toolbar: QToolbar { set get }
    var toolbarActions: QFieldAction { set get }

    func beginEditing()

}

public typealias QFieldType = UIView & IQField
