//
//  Quickly
//

public protocol IQApiPagination {

    func next() -> Self

}

public protocol IQApiPagePagination {

    var page: UInt { get }
    var size: UInt { get }

    func next() -> Self

}

public protocol IQApiRangePagination {

    var offset: UInt { get }
    var limit: UInt { get }

    func next() -> Self

}
