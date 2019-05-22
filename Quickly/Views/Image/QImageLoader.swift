//
//  Quickly
//

public class QImageLoader {

    public typealias ImageClosure = (_ image: UIImage?) -> Void
    public typealias SuccessClosure = () -> Void
    public typealias FailureClosure = (_ error: Error) -> Void

    public private(set) var provider: QApiProvider
    public private(set) var cache: QImageCache
    public private(set) var queue: DispatchQueue
    
    private var _tasks: [QImageLoaderTask]

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
        self.queue = DispatchQueue.global(qos: .background)
        self._tasks = []
    }
    
    public func isExist(url: URL, filter: IQImageLoaderFilter?) -> Bool {
        return self.cache.isExist(url: url, filter: filter)
    }

    public func download(url: URL, filter: IQImageLoaderFilter?, target: IQImageLoaderTarget) {
        if let task = self._tasks.first(where: { return $0.url == url && $0.filter === filter }) {
            task.add(target: target)
        } else {
            let task = QImageLoaderTask(delegate: self, provider: self.provider, cache: self.cache, url: url, filter: filter, target: target)
            self._tasks.append(task)
            task.execute(queue: self.queue)
        }
    }

    public func cancel(target: IQImageLoaderTarget) {
        self._tasks.removeAll(where: { (task) in
            if task.remove(target: target) == true {
                task.cancel()
            }
            return task.targets.isEmpty
        })
    }
    
    public func cleanup() {
        self.cache.cleanup()
    }
    
}

extension QImageLoader : IQImageLoaderTaskDelegate {
    
    public func didFinishImageLoaderTask(_ imageLoaderTask: QImageLoaderTask) {
        self._tasks.removeAll(where: { return $0 === imageLoaderTask })
    }
    
}
