//
//  Quickly
//

public protocol IQProxy {

    var host: String { get }
    var port: Int { get }
    var username: String? { get }
    var password: String? { get }
    
    var dictionary: [AnyHashable : Any] { get }

}
