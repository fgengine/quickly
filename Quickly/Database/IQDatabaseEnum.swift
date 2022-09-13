//
//  Quickly
//

import Foundation

public protocol IQDatabaseEnum {
    
    associatedtype RealValue
    
    var realValue: Self.RealValue { get }
    
    init(realValue: Self.RealValue)
    
}
