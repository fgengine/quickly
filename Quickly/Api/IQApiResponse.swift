//
//  Quickly
//

public protocol IQApiResponse : class {

    var error: Error? { get }

    func parse(response: URLResponse, data: Data?)
    func parse(error: Error)

    func reset()
    
}
