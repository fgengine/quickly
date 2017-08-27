//
//  Quickly
//

import Foundation

public protocol IQDataSource {

    associatedtype ContainerType
    associatedtype ErrorType

    var container: ContainerType { get }
    var isLoading: Bool { get }
    var error: ErrorType? { get }

    func load()
    func reset()
    func cancel()

}
