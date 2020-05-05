//
//  Quickly
//

public class QImageCache {

    public private(set) var name: String
    public private(set) var memory: [String: UIImage]
    public private(set) var url: URL
    
    private var _fileManager: FileManager
    private var _queue: DispatchQueue

    public init(name: String) throws {
        self.name = name
        self.memory = [:]
        self._fileManager = FileManager.default
        self._queue = DispatchQueue(label: name)
        if let cachePath = self._fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.url = cachePath
        } else {
            self.url = URL(fileURLWithPath: NSHomeDirectory())
        }
        self.url.appendPathComponent(name)
        if self._fileManager.fileExists(atPath: self.url.path) == false {
            try self._fileManager.createDirectory(at: self.url, withIntermediateDirectories: true, attributes: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self._didReceiveMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func isExist(url: URL, filter: IQImageLoaderFilter? = nil) -> Bool {
        guard let key = self._key(url: url, filter: filter) else {
            return false
        }
        let memoryImage = self._queue.sync(execute: { return self.memory[key] })
        if memoryImage != nil {
            return true
        }
        let url = self.url.appendingPathComponent(key)
        return self._fileManager.fileExists(atPath: url.path)
    }

    public func image(url: URL, filter: IQImageLoaderFilter? = nil) -> UIImage? {
        guard let key = self._key(url: url, filter: filter) else {
            return nil
        }
        let memoryImage = self._queue.sync(execute: { return self.memory[key] })
        if let image = memoryImage {
            return image
        }
        let url = self.url.appendingPathComponent(key)
        if let image = UIImage(contentsOfFile: url.path) {
            self._queue.sync(execute: {
                self.memory[key] = image
            })
            return image
        }
        return nil
    }

    public func set(data: Data, image: UIImage, url: URL, filter: IQImageLoaderFilter? = nil) throws {
        guard let key = self._key(url: url, filter: filter) else { return }
        let url = self.url.appendingPathComponent(key)
        do {
            try data.write(to: url, options: .atomic)
            self._queue.sync(execute: {
                self.memory[key] = image
            })
        } catch let error {
            throw error
        }
    }

    public func remove(url: URL, filter: IQImageLoaderFilter? = nil) throws {
        guard let key = self._key(url: url, filter: filter) else { return }
        self._queue.sync(execute: {
            _ = self.memory.removeValue(forKey: key)
        })
        let url = self.url.appendingPathComponent(key)
        if self._fileManager.fileExists(atPath: url.path) == true {
            do {
                try self._fileManager.removeItem(at: url)
            } catch let error {
                throw error
            }
        }
    }

    public func cleanup(before: TimeInterval) {
        self._queue.sync(execute: {
            self.memory.removeAll()
        })
        let now = Date()
        if let urls = try? self._fileManager.contentsOfDirectory(at: self.url, includingPropertiesForKeys: nil, options: [ .skipsHiddenFiles ]) {
            for url in urls {
                guard
                    let attributes = try? self._fileManager.attributesOfItem(atPath: url.path),
                    let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date
                else {
                    continue
                }
                let delta = now.timeIntervalSince1970 - modificationDate.timeIntervalSince1970
                if delta > before {
                    try? self._fileManager.removeItem(at: url)
                }
            }
        }
    }

    @objc
    private func _didReceiveMemoryWarning(_ notification: NSNotification) {
        self._queue.sync(execute: {
            self.memory.removeAll()
        })
    }

}

private extension QImageCache {
    
    func _key(url: URL, filter: IQImageLoaderFilter?) -> String? {
        var unique: String
        var path: String
        if url.isFileURL == true {
            path = url.lastPathComponent
        } else {
            path = url.absoluteString
        }
        if let filter = filter {
            unique = "{\(filter.name)}{\(path)}"
        } else {
            unique = path
        }
        if let key = unique.sha256 {
            return key
        }
        return nil
    }
    
}
