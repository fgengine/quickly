//
//  Quickly
//

import UIKit

public protocol IQFieldForm : AnyObject {
    
    var fields: [IQField] { get }
    var isValid: Bool { get }
    
    func add(observer: IQFieldFormObserver)
    func remove(observer: IQFieldFormObserver)
    
    func add(field: IQField)
    func remove(field: IQField)
    
    func validation()
    
}

public protocol IQFieldFormObserver : AnyObject {

    func fieldForm(_ fieldForm: IQFieldForm, isValid: Bool)
    
}
