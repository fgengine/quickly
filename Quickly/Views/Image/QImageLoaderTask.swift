//
//  Quickly
//

public protocol IQImageLoaderTaskDelegate : class {
    
    func didFinishImageLoaderTask(_ imageLoaderTask: QImageLoaderTask)
    
}

public class QImageLoaderTask {
    
    public private(set) weak var delegate: IQImageLoaderTaskDelegate?
    public private(set) var provider: QApiProvider
    public private(set) var cache: QImageCache
    public private(set) var url: URL
    public private(set) var filter: IQImageLoaderFilter?
    public private(set) var targets: [IQImageLoaderTarget]
    public private(set) var workItem: DispatchWorkItem?
    public private(set) var query: IQApiQuery?
    
    public init(delegate: IQImageLoaderTaskDelegate, provider: QApiProvider, cache: QImageCache, url: URL, filter: IQImageLoaderFilter?, target: IQImageLoaderTarget) {
        self.delegate = delegate
        self.provider = provider
        self.cache = cache
        self.url = url
        self.filter = filter
        self.targets = [ target ]
    }
    
    public func add(target: IQImageLoaderTarget) {
        self.targets.append(target)
    }
    
    public func remove(target: IQImageLoaderTarget) -> Bool {
        guard let index = self.targets.firstIndex(where: { return $0 === target }) else {
            return false
        }
        self.targets.remove(at: index)
        return true
    }
    
    public func execute(queue: DispatchQueue) {
        var workItem: DispatchWorkItem
        if self.cache.isExist(url: self.url, filter: self.filter) == true {
            workItem = self._cacheWorkItem()
        } else if self.cache.isExist(url: self.url) == true {
            workItem = self._cacheWorkItem()
        } else if self.url.isFileURL == true {
            workItem = self._localWorkItem()
        } else {
            workItem = self._remoteWorkItem()
        }
        self.workItem = workItem
        queue.async(execute: workItem)
    }
    
    public func cancel() {
        if let workItem = self.workItem {
            workItem.cancel()
            self.workItem = nil
        }
        if let query = self.query {
            query.cancel()
            self.query = nil
        }
    }
    
    private func _cacheWorkItem() -> DispatchWorkItem {
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self.workItem else { return }
            var resultImage = self.cache.image(url: self.url, filter: self.filter)
            var resultError: Error?
            if resultImage == nil {
                if workItem.isCancelled == false, let filter = self.filter {
                    if workItem.isCancelled == false, let originImage = self.cache.image(url: self.url), let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self.cache.set(data: data, image: image, url: self.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    }
                }
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    private func _localWorkItem() -> DispatchWorkItem {
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self.workItem else { return }
            var resultImage: UIImage?
            var resultError: Error?
            do {
                let data = try Data(contentsOf: self.url)
                if workItem.isCancelled == false, let originImage = UIImage(data: data) {
                    try self.cache.set(data: data, image: originImage, url: self.url)
                    if workItem.isCancelled == false, let filter = self.filter, let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self.cache.set(data: data, image: image, url: self.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else if workItem.isCancelled == false {
                        resultImage = originImage
                    }
                }
            } catch let error {
                resultError = error
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    private func _remoteWorkItem() -> DispatchWorkItem {
        let semaphore = DispatchSemaphore(value: 0)
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self.workItem else { return }
            var downloadData: Data?
            var downloadImage: UIImage?
            var resultImage: UIImage?
            var resultError: Error?
            self._progress(progress: Progress(totalUnitCount: 0))
            self.query = self.provider.send(
                request: QImageRequest(url: self.url),
                response: QImageResponse(),
                download: { (progress) in
                    self._progress(progress: progress)
                },
                completed: { (request, response) in
                    downloadData = response.data
                    downloadImage = response.image
                    resultError = response.error
                    semaphore.signal()
                }
            )
            semaphore.wait()
            self.query = nil
            if workItem.isCancelled == false, let data = downloadData, let originImage = downloadImage {
                do {
                    try self.cache.set(data: data, image: originImage, url: self.url)
                    if workItem.isCancelled == false, let filter = self.filter, let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self.cache.set(data: data, image: image, url: self.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else if workItem.isCancelled == false {
                        resultImage = originImage
                    }
                } catch let error {
                    resultError = error
                }
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    private func _progress(progress: Progress) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            for target in self.targets {
                target.imageLoader(progress: progress)
            }
        })
    }
    
    private func _finish(workItem: DispatchWorkItem, image: UIImage?, error: Error?) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            if let delegate = self.delegate {
                delegate.didFinishImageLoaderTask(self)
            }
            self.workItem = nil
            if workItem.isCancelled == false {
                if let image = image {
                    for target in self.targets {
                        target.imageLoader(image: image)
                    }
                } else if let error = error {
                    for target in self.targets {
                        target.imageLoader(error: error)
                    }
                }
            }
        })
    }
    
}
