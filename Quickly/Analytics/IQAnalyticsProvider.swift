//
//  Quickly
//

public protocol IQAnalyticsProvider : class {
    
    func send(event: String, params: [String : String]?)
    
}
