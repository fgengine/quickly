//
//  Quickly
//

import Foundation

open class QListDataSource<
    ContainerType: IQContainer,
    DataType,
    ErrorType
> : IQListDataSource {
    
    public var container: ContainerType
    public internal(set) var canLoadMore: Bool = true
    public internal(set) var isLoading: Bool = false
    public private(set) var data: [DataType] = []
    public private(set) var error: ErrorType? = nil

    public init(container: ContainerType) {
        self.container = container
    }
    
    public final func load() {
        if self.isLoading == false {
            self.isLoading = true
            self.onLoad()
        }
    }

    public final func reset() {
        self.cancel()
        self.onReset()
    }
    
    public final func cancel() {
        if self.isLoading == true {
            self.isLoading = false
            self.onCancel()
        }
    }
    
    open func onLoad() {
    }

    open func onFinish(data: [DataType], append: Bool) {
        self.isLoading = false
        if append == true {
            self.data.append(contentsOf: data)
        } else {
            self.data = data
        }
        self.error = nil
    }
    
    open func onFinish(error: ErrorType) {
        self.isLoading = false
        self.error = error
    }

    open func onReset() {
        self.canLoadMore = true
        self.data.removeAll()
        self.error = nil
    }
    
    open func onCancel() {
    }
    
}
