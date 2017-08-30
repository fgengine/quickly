//
//  Quickly
//

import Foundation

public protocol IQDataSource {

    associatedtype ErrorType

    var isLoading: Bool { get }
    var error: ErrorType? { get }

    func load()
    func reset()
    func cancel()

}
