//
//  Quickly
//

public protocol IQAnaliticsProvider : class {
    
    func send(event: String, params: [String : String]?)
    
}
