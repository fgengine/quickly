//
//  Quickly
//

public struct QApiRequestRedirectOption : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var enabled = QApiRequestRedirectOption(rawValue: 1 << 0)
    public static var method = QApiRequestRedirectOption(rawValue: 1 << 1)
    public static var authorization = QApiRequestRedirectOption(rawValue: 1 << 2)
    
}

public protocol IQApiRequest : class {

    var timeout: TimeInterval { get }
    var retries: TimeInterval { get }
    var delay: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var redirect: QApiRequestRedirectOption { get }
    #if DEBUG
    var logging: QApiLogging { get }
    #endif

    func urlRequest(provider: IQApiProvider) -> URLRequest?
    
}
