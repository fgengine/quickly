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

    open func onFinish(data: DataType) {
        self.isLoading = false
        self.data = data
        self.error = nil
    }
    
    open func onFinish(error: ErrorType) {
        self.isLoading = false
        self.error = error
    }

    open func onReset() {
        self.canLoad = true
        self.data = nil
        self.error = nil
    }
    
    open func onCancel() {
    }
    
}
