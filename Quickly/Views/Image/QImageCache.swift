//
//  Quickly
//

public class QImageCache {

    public private(set) var name: String
    public private(set) var memory: [String: UIImage]
    public private(set) var url: URL
    
    private var fileManager: FileManager

    public init(name: String) throws {
        self.name = name
        self.memory = [:]
        self.fileManager = FileManager.default
        if let cachePath = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.url = cachePath
        } else {
            self.url = URL(fileURLWithPath: NSHomeDirectory())
        }
        self.url.appendPathComponent(name)
        if self.fileManager.fileExists(atPath: self.url.path) == false {
            try self.fileManager.createDirectory(at: self.url, withIntermediateDirectories: true, attributes: nil)
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
        if self.memory[key] != nil {
            return true
        }
        let url = self.url.appendingPathComponent(key)
        return self.fileManager.fileExists(atPath: url.path)
    }

    public func image(url: URL, filter: IQImageLoaderFilter? = nil) -> UIImage? {
        guard let key = self._key(url: url, filter: filter) else {
            return nil
        }
        if let image = self.memory[key] {
            return image
        }
        let url = self.url.appendingPathComponent(key)
        if let image = UIImage(contentsOfFile: url.path) {
            self.memory[key] = image
            return image
        }
        return nil
    }

    public func set(data: Data, image: UIImage, url: URL, filter: IQImageLoaderFilter? = nil) throws {
        guard let key = self._key(url: url, filter: filter) else { return }
        let url = self.url.appendingPathComponent(key)
        do {
            try data.write(to: url, options: .atomic)
            self.memory[key] = image
        } catch let error {
            throw error
        }
    }

    public func remove(url: URL, filter: IQImageLoaderFilter? = nil) throws {
        guard let key = self._key(url: url, filter: filter) else { return }
        self.memory.removeValue(forKey: key)
        let url = self.url.appendingPathComponent(key)
        if self.fileManager.fileExists(atPath: url.path) == true {
            do {
                try self.fileManager.removeItem(at: url)
            } catch let error {
                throw error
            }
        }
    }

    public func cleanup() {
        self.memory.removeAll()
        if let urls = try? self.fileManager.contentsOfDirectory(at: self.url, includingPropertiesForKeys: nil, options: [ .skipsHiddenFiles ]) {
            for url in urls {
                try? self.fileManager.removeItem(at: url)
            }
        }
    }

    @objc
    private func _didReceiveMemoryWarning(_ notification: NSNotification) {
        self.memory.removeAll()
    }

}

private extension QImageCache {
    
    func _key(url: URL, filter: IQImageLoaderFilter?) -> String? {
        var unique: String
        if let filter = filter {
            unique = "{\(filter.name)}{\(url.absoluteString)}"
        } else {
            unique = url.absoluteString
        }
        if let key = unique.sha256 {
            return key
        }
        return nil
    }
    
}
