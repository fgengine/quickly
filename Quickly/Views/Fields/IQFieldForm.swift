//
//  Quickly
//

public protocol IQFieldForm : class {
    
    var fields: [IQField] { get }
    var isValid: Bool { get }
    
    func add(observer: IQFieldFormObserver)
    func remove(observer: IQFieldFormObserver)
    
    func add(field: IQField)
    func remove(field: IQField)
    
    func validation()
    
}

public protocol IQFieldFormObserver : class {

    func fieldForm(_ fieldForm: IQFieldForm, isValid: Bool)
    
}
