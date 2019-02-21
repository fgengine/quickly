//
//  Quickly
//

public protocol IQApiRequest : class {

    var timeout: TimeInterval { get }
    var retries: TimeInterval { get }
    var delay: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    #if DEBUG
    var logging: QApiLogging { get }
    #endif

    func urlRequest(provider: IQApiProvider) -> URLRequest?
    
}
