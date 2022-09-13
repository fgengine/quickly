//
//  Quickly
//

import Foundation

public protocol IQApiResponse : AnyObject {

    var error: Error? { get }

    func parse(response: URLResponse, data: Data?)
    func parse(error: Error)

    func reset()
    
}
