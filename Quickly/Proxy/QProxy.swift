//
//  Quickly
//

public final class QProxy : IQProxy {
    
    public private(set) var host: String
    public private(set) var port: Int
    public private(set) var username: String?
    public private(set) var password: String?
    
    public var dictionary: [AnyHashable : Any] {
        get {
            var dictionary: [AnyHashable : Any] = [:]
            dictionary[kCFNetworkProxiesHTTPEnable] = true
            dictionary[kCFNetworkProxiesHTTPProxy] = self.host
            dictionary[kCFNetworkProxiesHTTPPort] = self.port
            if let username = self.username, let password = self.password {
                dictionary[kCFProxyUsernameKey] = username
                dictionary[kCFProxyPasswordKey] = password
            }
            return dictionary
        }
    }
    
    public init(
        host: String,
        port: Int,
        username: String? = nil,
        password: String? = nil
    ) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
    
}
