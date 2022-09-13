//
//  Quickly
//

import Foundation

public protocol IQAnalyticsProvider : AnyObject {
    
    func send(event: String, params: [String : String]?)
    
}
