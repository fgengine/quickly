//
//  Quickly
//

import Foundation

public protocol IQListDataSource: IQDataSource {

    associatedtype DataType

    var canLoadMore: Bool { get }
    var isLoading: Bool { get }
    var data: [DataType] { get }

}
