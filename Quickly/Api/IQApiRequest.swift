//
//  Quickly
//

public protocol IQApiRequest : class {

    var timeout: TimeInterval { get }
    var retries: TimeInterval { get }
    var delay: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var logging: QApiLogging { get }

    func urlRequest(provider: IQApiProvider) -> URLRequest?
    
}
