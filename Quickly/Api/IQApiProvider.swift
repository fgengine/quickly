//
//  Quickly
//

public protocol IQApiProvider: class {

    var baseUrl: URL? { get }
    var urlParams: [String: Any] { get }
    var headers: [String: String] { get }
    var bodyParams: [String: Any]? { get }
    var isLogging: Bool { get }

    func send(query: IQApiQuery)

    func cancel(query: IQApiQuery)

}
