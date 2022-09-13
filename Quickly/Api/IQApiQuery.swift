//
//  Quickly
//

import Foundation

public protocol IQApiQuery : AnyObject {

    var provider: IQApiProvider { get }
    var createAt: Date { get }

    func start()
    func redirect(request: URLRequest) -> URLRequest?
    func cancel()

}
