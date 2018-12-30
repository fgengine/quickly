//
//  Quickly
//

public protocol IQImageLoaderTarget : class {

    func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage)

    func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress)
    func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage)
    func imageLoader(_ imageLoader: QImageLoader, downloadError: Error)

}

public protocol IQImageLoaderFilter : class {

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

    public static let shared: QImageLoader = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.timeoutIntervalForResource = 60
        let sessionQueue = OperationQueue()
        sessionQueue.maxConcurrentOperationCount = 1
        return try! QImageLoader(
            name: "QImageLoader",
            sessionConfiguration: sessionConfiguration,
            sessionQueue: sessionQueue
        )
    }()

    public init(name: String, sessionConfiguration: URLSessionConfiguration, sessionQueue: OperationQueue) throws {
        self.provider = QApiProvider(
            sessionConfiguration: sessionConfiguration,
            sessionQueue: sessionQueue
        )
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
        guard let key = self._key(url, filter: filter) else { return false }
        return self.cache.isExist(key)
    }

    public func cacheImage(
        _ url: URL,
        filter: IQImageLoaderFilter? = nil
    ) -> UIImage? {
        guard let key = self._key(url, filter: filter) else { return nil }
        return self.cache.image(key)
    }

    public func set(
        _ image: UIImage,
        url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        if let data = image.pngData() {
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
        if let image = UIImage(data: data) {
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
        guard let key = self._key(url, filter: filter) else { return }
        self.cache.set(data, image: image, key: key, success: success, failure: failure)
    }

    public func remove(
        _ url: URL,
        filter: IQImageLoaderFilter? = nil,
        success: SuccessClosure? = nil,
        failure: FailureClosure? = nil
    ) {
        guard let key = self._key(url, filter: filter) else { return }
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
            for operation in self.operationQueue.operations {
                if operation.isCancelled == true {
                    continue
                }
                if let operation = operation as? BaseOperation {
                    if operation.url == url && operation.filter === filter {
                        existOperation = operation
                    }
                }
            }
            self.operationQueue.isSuspended = false
        }
        if let existOperation = existOperation {
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
            if let existOperation = existOperation {
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
            for operation in self.operationQueue.operations {
                if operation.isCancelled == true {
                    continue
                }
                if let operation = operation as? BaseOperation {
                    if operation.contains(target: target) == true {
                        operation.cancel()
                    }
                }
            }
            self.operationQueue.isSuspended = false
        }
    }

    private func _key(_ url: URL, filter: IQImageLoaderFilter?) -> String? {
        if let filter = filter {
            return self._key("{\(filter.name)}{\(url.absoluteString)}")
        } else {
            return self._key(url.absoluteString)
        }
    }

    private func _key(_ name: String) -> String? {
        guard let key = name.sha256 else { return nil }
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
            if let index = self.targets.index(where: { return $0 === target }) {
                self.targets.remove(at: index)
            }
        }

        public func contains(target: IQImageLoaderTarget) -> Bool {
            let index = self.targets.index(where: { return $0 === target })
            return index != nil
        }

    }

    private class CacheOperation: BaseOperation {

        open override func main() {
            if let loader = self.loader {
                if self.isCancelled == true {
                    return
                }
                if let filter = self.filter {
                    var final: UIImage? = nil
                    if let image = loader.cacheImage(self.url, filter: filter) {
                        final = image
                    } else if let image = loader.cacheImage(self.url) {
                        let filtered = filter.apply(image)
                        loader.set(filtered, url: self.url, filter: filter)
                        final = filtered
                    }
                    if let final = final {
                        self._notifyCache(loader: loader, image: final)
                    }
                } else if let image = loader.cacheImage(self.url) {
                    self._notifyCache(loader: loader, image: image)
                }
            }
        }

        private func _notifyCache(loader: QImageLoader, image: UIImage) {
            DispatchQueue.main.async {
                for target in self.targets {
                    target.imageLoader(loader, cacheImage: image)
                }
            }
        }

    }

    private class DownloadOperation: BaseOperation {

        private var _semaphore: DispatchSemaphore
        private var _query: IQApiQuery?

        public override init(loader: QImageLoader, targets: [IQImageLoaderTarget], url: URL, filter: IQImageLoaderFilter?) {
            self._semaphore = DispatchSemaphore(value: 0)
            super.init(loader: loader, targets: targets, url: url, filter: filter)
        }

        open override func main() {
            if let loader = self.loader {
                if self.isCancelled == true {
                    return
                }
                var downloadData: Data?
                var downloadImage: UIImage?
                var downloadError: Error?
                let request = QImageRequest(url: self.url)
                let response = QImageResponse()
                self._query = loader.provider.send(
                    request: request,
                    response: response,
                    queue: loader.syncQueue,
                    download: { [weak self] (progress) in
                        self?._notify(loader: loader, progress: progress)
                    },
                    completed: { [weak self] (request, response) in
                        downloadData = response.data
                        downloadImage = response.image
                        downloadError = response.error
                        self?._query = nil
                        self?._semaphore.signal()
                    }
                )
                self._semaphore.wait()
                if self.isCancelled == false {
                    guard let data = downloadData, let image = downloadImage else {
                        if let error = downloadError {
                            self._notifyFinish(loader: loader, error: error)
                        }
                        return
                    }
                    loader.set(data, image: image, url: self.url)
                    if let filter = self.filter {
                        let filtered = filter.apply(image)
                        loader.set(filtered, url: self.url, filter: filter)
                        self._notifyFinish(loader: loader, image: filtered)
                    } else {
                        self._notifyFinish(loader: loader, image: image)
                    }
                }
            }
        }

        open override func cancel() {
            super.cancel()

            if let query = self._query {
                query.cancel()
            }
            self._semaphore.signal()
        }

        private func _notify(loader: QImageLoader, progress: Progress) {
            DispatchQueue.main.async {
                for target in self.targets {
                    target.imageLoader(loader, downloadProgress: progress)
                }
            }
        }

        private func _notifyFinish(loader: QImageLoader, image: UIImage) {
            DispatchQueue.main.async {
                for target in self.targets {
                    target.imageLoader(loader, downloadImage: image)
                }
            }
        }

        private func _notifyFinish(loader: QImageLoader, error: Error) {
            DispatchQueue.main.async {
                for target in self.targets {
                    target.imageLoader(loader, downloadError: error)
                }
            }
        }

    }

}
