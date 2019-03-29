//
//  Quickly
//

public protocol IQAnaliticsProvider : class {
    
    func launch()
    
    func send(event: String, params: [String : String]?)
    
}
