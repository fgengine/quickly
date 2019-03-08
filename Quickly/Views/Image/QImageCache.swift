//
//  Quickly
//

public class QImageCache {

    public typealias ImageClosure = (_ image: UIImage?) -> Void
    public typealias SuccessClosure = () -> Void
    public typealias FailureClosure = (_ error: Error) -> Void

    public let name: String
    public private(set) var memory: [String: UIImage]
    public private(set) lazy var queue: DispatchQueue = DispatchQueue(
        label: self.name,
        qos: .background,
        attributes: .concurrent,
        autoreleaseFrequency: .inherit,
        target: nil
    )
    public private(set) var url: URL

    public init(name: String) throws {
        self.name = name
        self.memory = [:]
        if let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.url = cachePath
        } else {
            self.url = URL(fileURLWithPath: NSHomeDirectory())
        }
        self.url.appendPathComponent(name)
        if FileManager.default.fileExists(atPath: self.url.path) == false {
            try FileManager.default.createDirectory(at: self.url, withIntermediateDirectories: true, attributes: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self._didReceiveMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func isExist(_ key: String) -> Bool {
        let memoryImage = self.queue.sync {
            return self.memory[key]
        }
        if memoryImage != nil {
            return true
        }
        let url = self.url.appendingPathComponent(key)
        return FileManager.default.fileExists(atPath: url.path)
    }

    public func image(_ key: String) -> UIImage? {
        let memoryImage = self.queue.sync {
            return self.memory[key]
        }
        if let image = memoryImage {
            return image
        }
        let url = self.url.appendingPathComponent(key)
        if let image = UIImage(contentsOfFile: url.path) {
            self.queue.sync {
                self.memory[key] = image
            }
            return image
        }
        return nil
    }

    public func image(_ key: String, complete: @escaping ImageClosure) {
        self.queue.async {
            if let image = self.memory[key] {
                complete(image)
            }
            let url = self.url.appendingPathComponent(key)
            if let image = UIImage(contentsOfFile: url.path) {
                self.memory[key] = image
                complete(image)
            }
        }
    }

    public func set(_ data: Data, image: UIImage, key: String, success: SuccessClosure?, failure: FailureClosure?) {
        self.queue.sync {
            self.memory[key] = image
        }
        let url = self.url.appendingPathComponent(key)
        if let success = success {
            self.queue.async {
                do {
                    try data.write(to: url, options: .atomic)
                    success()
                } catch let error {
                    failure?(error)
                }
            }
        } else {
            do {
                try data.write(to: url, options: .atomic)
            } catch let error {
                failure?(error)
            }
        }
    }

    public func remove(_ key: String, success: SuccessClosure?, failure: FailureClosure?) {
        self.queue.sync {
            _ = self.memory.removeValue(forKey: key)
        }
        let url = self.url.appendingPathComponent(key)
        if FileManager.default.fileExists(atPath: url.path) == true {
            if let success = success {
                self.queue.async {
                    do {
                        try FileManager.default.removeItem(at: url)
                        success()
                    } catch let error {
                        failure?(error)
                    }
                }
            } else {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch let error {
                    failure?(error)
                }
            }
        }
    }

    public func cleanup(_ success: SuccessClosure?, failure: FailureClosure?) {
        self.queue.sync {
            self.memory.removeAll()
        }
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: self.url, includingPropertiesForKeys: nil, options: [ .skipsHiddenFiles ])
            if let success = success {
                self.queue.async {
                    var lastError: Error? = nil
                    for url in urls {
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch let error {
                            lastError = error
                        }
                    }
                    if let lastError = lastError {
                        failure?(lastError)
                    } else {
                        success()
                    }
                }
            } else {
                var lastError: Error? = nil
                for url in urls {
                    do {
                        try FileManager.default.removeItem(at: url)
                    } catch let error {
                        lastError = error
                    }
                }
                if let lastError = lastError {
                    failure?(lastError)
                }
            }
        } catch let error {
            failure?(error)
        }
    }

    @objc
    private func _didReceiveMemoryWarning(_ notification: NSNotification) {
        self.queue.sync {
            self.memory.removeAll()
        }
    }

}
