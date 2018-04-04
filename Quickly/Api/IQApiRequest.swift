//
//  Quickly
//

public protocol IQApiRequest : class {

    var timeout: TimeInterval { get }
    var retries: TimeInterval { get }
    var delay: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var isLogging: Bool { get }

    func urlRequest(provider: IQApiProvider) -> URLRequest?
    
}
