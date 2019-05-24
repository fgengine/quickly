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
            guard let strong = self else { return }
            var resultImage = strong.cache.image(url: strong.url, filter: strong.filter)
            var resultError: Error?
            if resultImage == nil {
                if let filter = strong.filter {
                    if let originImage = strong.cache.image(url: strong.url), let image = filter.apply(originImage) {
                        if let data = image.pngData() {
                            do {
                                try strong.cache.set(data: data, image: image, url: strong.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    }
                }
            }
            strong._finish(image: resultImage, error: resultError)
        })
    }
    
    private func _localWorkItem() -> DispatchWorkItem {
        return DispatchWorkItem(block: { [weak self] in
            guard let strong = self else { return }
            var resultImage: UIImage?
            var resultError: Error?
            do {
                let data = try Data(contentsOf: strong.url)
                if let originImage = UIImage(data: data) {
                    try strong.cache.set(data: data, image: originImage, url: strong.url)
                    if let filter = strong.filter, let image = filter.apply(originImage) {
                        if let data = image.pngData() {
                            do {
                                try strong.cache.set(data: data, image: image, url: strong.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else {
                        resultImage = originImage
                    }
                }
            } catch let error {
                resultError = error
            }
            strong._finish(image: resultImage, error: resultError)
        })
    }
    
    private func _remoteWorkItem() -> DispatchWorkItem {
        let semaphore = DispatchSemaphore(value: 0)
        return DispatchWorkItem(block: { [weak self] in
            guard let strong = self else { return }
            var downloadData: Data?
            var downloadImage: UIImage?
            var resultImage: UIImage?
            var resultError: Error?
            strong.query = strong.provider.send(
                request: QImageRequest(url: strong.url),
                response: QImageResponse(),
                download: { (progress) in
                    strong._progress(progress: progress)
                },
                completed: { (request, response) in
                    downloadData = response.data
                    downloadImage = response.image
                    resultError = response.error
                }
            )
            semaphore.wait()
            strong.query = nil
            if let data = downloadData, let originImage = downloadImage {
                do {
                    try strong.cache.set(data: data, image: originImage, url: strong.url)
                    if let filter = strong.filter, let image = filter.apply(originImage) {
                        if let data = image.pngData() {
                            do {
                                try strong.cache.set(data: data, image: image, url: strong.url, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else {
                        resultImage = originImage
                    }
                } catch let error {
                    resultError = error
                }
            }
            strong._finish(image: resultImage, error: resultError)
        })
    }
    
    private func _progress(progress: Progress) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strong = self else { return }
            for target in strong.targets {
                target.imageLoader(progress: progress)
            }
        })
    }
    
    private func _finish(image: UIImage?, error: Error?) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strong = self else { return }
            if let delegate = strong.delegate {
                delegate.didFinishImageLoaderTask(strong)
            }
            if strong.workItem != nil {
                strong.workItem = nil
                if let image = image {
                    for target in strong.targets {
                        target.imageLoader(image: image)
                    }
                } else if let error = error {
                    for target in strong.targets {
                        target.imageLoader(error: error)
                    }
                }
            }
        })
    }
    
}
