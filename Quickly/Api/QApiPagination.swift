//
//  Quickly
//

public struct QApiPagePagination : IQApiPagePagination {

    public var page: UInt
    public var size: UInt

    public init(page: UInt, size: UInt) {
        self.page = page
        self.size = size
    }

    public init(pagination: IQApiRangePagination) {
        self.page = pagination.offset / pagination.limit
        self.size = pagination.limit
    }

    public func next() -> QApiPagePagination {
        return QApiPagePagination(
            page: self.page + 1,
            size: self.size
        )
    }

}

public struct QApiRangePagination : IQApiRangePagination {

    public var offset: UInt
    public var limit: UInt

    public init(offset: UInt, limit: UInt) {
        self.offset = offset
        self.limit = limit
    }

    public init(pagination: QApiPagePagination) {
        self.offset = pagination.page * pagination.size
        self.limit = pagination.size
    }

    public func next() -> QApiRangePagination {
        return QApiRangePagination(
            offset: self.offset + self.limit,
            limit: self.limit
        )
    }

}

public struct QApiDatePagination : IQApiDatePagination {

    public var date: Date
    public var count: UInt

    public init(date: Date, count: UInt) {
        self.date = date
        self.count = count
    }

    public func next(date: Date) -> QApiDatePagination {
        return QApiDatePagination(
            date: date,
            count: self.count
        )
    }

}
