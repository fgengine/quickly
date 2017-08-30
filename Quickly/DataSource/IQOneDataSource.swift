//
//  Quickly
//

import Foundation

public protocol IQOneDataSource: IQDataSource {

    associatedtype DataType

    var canLoad: Bool { get }
    var data: DataType? { get }

}
