//
//  Quickly
//

import Foundation

public protocol IQContextable {
    
    associatedtype ContextType

    var context: ContextType { get }

}
