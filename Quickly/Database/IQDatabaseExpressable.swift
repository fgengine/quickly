//
//  Quickly
//

import Foundation

// MARK: IQDatabaseExpressable

public protocol IQDatabaseExpressable {
    
    func inputValues() -> [IQDatabaseInputValue]
    func queryExpression() -> String
    
}
