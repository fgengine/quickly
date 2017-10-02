//
//  Quickly
//

import UIKit

public protocol IQImageLoaderTarget: class {

    func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage)

    func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress)
    func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage)
    func imageLoader(_ imageLoader: QImageLoader, downloadError: Error)

}

public protocol IQImageLoaderFilter: class {

    var name: String { get }

    func apply(_ image: UIImage) -> UIImage

}

public class QImageLoader {

    public typealias SuccessClosure = () -> Void
    public typealias FailureClosure = (_ error: Error) -> Void

    public private(set) var provider: QApiProvider
    public private(set) var cache: QImageCache
    public private(set) var operationQueue: OperationQueue
    public private(set) var syncQueue: DispatchQueue

    public static let shared: QImageLoader = try! QImageLoader(name: "QImageLoader")

    public init(name: String) throws {
        self.provider = QApiProvider()
        self.cache = try QImageCache(name: name)
        self.operationQueue = OperationQueue()
        self.operationQueue.maxConcurrentOperationCount = 5
        if #available(iOS 10.0, *) {
            self.syncQueue = DispatchQueue(
                label: name,
                qos: DispatchQoS.background,
                attributes: .concurrent,
                autoreleaseFrequency: .workItem,
                target: nil
            )
        } else {
            self.syncQueue = DispatchQueue(label: name, attributes: .concurrent)
        }
    }

    public func isExist(
        _ url: URL,
        filter: IQImageLoaderFilter? = nil
    ) -> Bool {
        guard let key: String = self.key(url, filter: filter) else {
            return false
        }
        return self.cache.isExist(key)
    }

    public func cacheImage(
        _ url: URL,
        filter: IQImageLoaderFilter? = nil
    ) -> UIImage? {
        guard let key: String = self.key(url, filter: filter) else {
            return nil
        }
        return self.cache.image(key)
    }

    public func set(
        _ image: UIImage,
        url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        if let data: Data = UIImagePNGRepresentation(image) {
            self.set(data, image: image, url: url, filter: filter, success: success, failure: failure)
        }
    }

    public func set(
        _ data: Data,
        url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        if let image: UIImage = UIImage(data: data) {
            self.set(data, image: image, url: url, filter: filter, success: success, failure: failure)
        }
    }

    public func set(
        _ data: Data,
        image: UIImage,
        url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        guard let key: String = self.key(url, filter: filter) else {
            return
        }
        self.cache.set(data, image: image, key: key, success: success, failure: failure)
    }

    public func remove(
        _ url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        guard let key: String = self.key(url, filter: filter) else {
            return
        }
        self.cache.remove(key, success: success, failure: failure)
    }

    public func cleanup(
        _ success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
        ) {
        self.cache.cleanup(success, failure: failure)
    }

    public func download(_ url: URL, filter: IQImageLoaderFilter?, target: IQImageLoaderTarget) {
        var existOperation: BaseOperation? = nil
        self.syncQueue.sync {
            self.operationQueue.isSuspended = true
            for operation: Operation in self.operationQueue.operations {
                if operation.isCancelled == true {
                    continue
                }
                if let operation: BaseOperation = operation as? BaseOperation {
                    if operation.url == url && operation.filter === filter {
                        existOperation = operation
                    }
                }
            }
            self.operationQueue.isSuspended = false
        }
        if let existOperation: BaseOperation = existOperation {
            existOperation.add(target: target)
        } else {
            if self.isExist(url, filter: filter) {
                existOperation = CacheOperation(
                    loader: self,
                    targets: [ target ],
                    url: url,
                    filter: filter
                )
            } else {
                existOperation = DownloadOperation(
                    loader: self,
                    targets: [ target ],
                    url: url,
                    filter: filter
                )
            }
            if let existOperation: BaseOperation = existOperation {
                self.syncQueue.sync {
                    self.operationQueue.isSuspended = true
                    self.operationQueue.addOperation(existOperation)
                    self.operationQueue.isSuspended = false
                }
            }
        }
    }

    public func cancel(_ target: IQImageLoaderTarget) {
        self.syncQueue.sync {
            self.operationQueue.isSuspended = true
            for operation: Operation in self.operationQueue.operations {
                if operation.isCancelled == true {
                    continue
                }
                if let operation: BaseOperation = operation as? BaseOperation {
                    if operation.contains(target: target) == true {
                        operation.cancel()
                    }
                }
            }
            self.operationQueue.isSuspended = false
        }
    }

    private func key(_ url: URL, filter: IQImageLoaderFilter?) -> String? {
        if let filter: IQImageLoaderFilter = filter {
            return self.key("{\(filter.name)}{\(url.absoluteString)}")
        } else {
            return self.key(url.absoluteString)
        }
    }

    private func key(_ name: String) -> String? {
        guard let key: String = name.sha256 else {
            return nil
        }
        return key
    }

    private class BaseOperation: Operation {

        public private(set) weak var loader: QImageLoader?
        public private(set) var targets: [IQImageLoaderTarget]
        public private(set) var url: URL
        public private(set) var filter: IQImageLoaderFilter?

        public init(loader: QImageLoader, targets: [IQImageLoaderTarget], url: URL, filter: IQImageLoaderFilter?) {
            self.loader = loader
            self.targets = targets
            self.url = url
            self.filter = filter
        }

        public func add(target: IQImageLoaderTarget) {
            self.targets.append(target)
        }

        public func remove(target: IQImageLoaderTarget) {
            let index: Int? = self.targets.index { (existTarget: IQImageLoaderTarget) -> Bool in
                return target === existTarget
            }
            if let index: Int = index {
                self.targets.remove(at: index)
            }
        }

        public func contains(target: IQImageLoaderTarget) -> Bool {
            let index: Int? = self.targets.index { (existTarget: IQImageLoaderTarget) -> Bool in
                return target === existTarget
            }
            return index != nil
        }

    }

    private class CacheOperation: BaseOperation {

        open override func main() {
            if let loader: QImageLoader = self.loader {
                if self.isCancelled == true {
                    return
                }
                if let filter: IQImageLoaderFilter = self.filter {
                    var final: UIImage? = nil
                    if let image = loader.cacheImage(self.url, filter: filter) {
                        final = image
                    } else if let image: UIImage = loader.cacheImage(self.url) {
                        let filtered: UIImage = filter.apply(image)
                        loader.set(filtered, url: self.url, filter: filter)
                        final = filtered
                    }
                    if let final: UIImage = final {
                        self.notifyCache(loader: loader, image: final)
                    }
                } else if let image: UIImage = loader.cacheImage(self.url) {
                    self.notifyCache(loader: loader, image: image)
                }
            }
        }

        private func notifyCache(loader: QImageLoader, image: UIImage) {
            DispatchQueue.main.async {
                for target: IQImageLoaderTarget in self.targets {
                    target.imageLoader(loader, cacheImage: image)
                }
            }
        }

    }

    private class DownloadOperation: BaseOperation {

        private var semaphore: DispatchSemaphore
        private var query: IQApiQuery?

        public override init(loader: QImageLoader, targets: [IQImageLoaderTarget], url: URL, filter: IQImageLoaderFilter?) {
            self.semaphore = DispatchSemaphore(value: 0)
            super.init(loader: loader, targets: targets, url: url, filter: filter)
        }

        open override func main() {
            if let loader: QImageLoader = self.loader {
                if self.isCancelled == true {
                    return
                }
                var downloadData: Data?
                var downloadImage: UIImage?
                var downloadError: Error?
                let request: QImageRequest = QImageRequest(url: self.url)
                let response: QImageResponse = QImageResponse()
                self.query = loader.provider.send(
                    request: request,
                    response: response,
                    queue: loader.syncQueue,
                    download: { (progress: Progress) in
                        self.notify(loader: loader, progress: progress)
                    },
                    completed: { (request: QImageRequest, response: QImageResponse) in
                        downloadData = response.data
                        downloadImage = response.image
                        downloadError = response.error
                        self.query = nil
                        self.semaphore.signal()
                    }
                )
                self.semaphore.wait()
                if self.isCancelled == false {
                    guard let data: Data = downloadData, let image: UIImage = downloadImage else {
                        if let error: Error = downloadError {
                            self.notifyFinish(loader: loader, error: error)
                        }
                        return
                    }
                    loader.set(data, image: image, url: self.url)
                    if let filter: IQImageLoaderFilter = self.filter {
                        let filtered: UIImage = filter.apply(image)
                        loader.set(filtered, url: self.url, filter: filter)
                        self.notifyFinish(loader: loader, image: filtered)
                    } else {
                        self.notifyFinish(loader: loader, image: image)
                    }
                }
            }
        }

        open override func cancel() {
            super.cancel()

            if let query: IQApiQuery = self.query {
                query.cancel()
            }
            self.semaphore.signal()
        }

        private func notify(loader: QImageLoader, progress: Progress) {
            DispatchQueue.main.async {
                for target: IQImageLoaderTarget in self.targets {
                    target.imageLoader(loader, downloadProgress: progress)
                }
            }
        }

        private func notifyFinish(loader: QImageLoader, image: UIImage) {
            DispatchQueue.main.async {
                for target: IQImageLoaderTarget in self.targets {
                    target.imageLoader(loader, downloadImage: image)
                }
            }
        }

        private func notifyFinish(loader: QImageLoader, error: Error) {
            DispatchQueue.main.async {
                for target: IQImageLoaderTarget in self.targets {
                    target.imageLoader(loader, downloadError: error)
                }
            }
        }

    }

}
