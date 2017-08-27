//
//  Quickly
//

import Foundation

open class QOneDataSource<
    ContainerType: IQContainer,
    DataType,
    ErrorType
> : IQOneDataSource {
    
    public var container: ContainerType
    public internal(set) var canLoad: Bool = true
    public internal(set) var isLoading: Bool = false
    public private(set) var data: DataType? = nil
    public private(set) var error: ErrorType? = nil

    public init(container: ContainerType) {
        self.container = container
    }
    
    public func load() {
        if self.isLoading == false {
            self.isLoading = true
            self.onLoad()
        }
    }

    public func reset() {
        self.cancel()
        self.onReset()
    }
    
    public func cancel() {
        if self.isLoading == true {
            self.isLoading = false
            self.onCancel()
        }
    }
    
    internal func onLoad() {
    }

    internal func onFinish(data: DataType) {
        self.isLoading = false
        self.data = data
        self.error = nil
    }
    
    internal func onFinish(error: ErrorType) {
        self.isLoading = false
        self.error = error
    }

    internal func onReset() {
        self.canLoad = true
        self.data = nil
        self.error = nil
    }
    
    internal func onCancel() {
    }
    
}
