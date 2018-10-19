//
//  Quickly
//

open class QProxy : IQProxy {
    
    public var host: String
    public var port: Int
    public var username: String?
    public var password: String?
    
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
