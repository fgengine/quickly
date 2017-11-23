//
//  Quickly
//

open class QApiProvider: NSObject, IQApiProvider {

    public var baseUrl: URL? = nil
    public var urlParams: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var bodyParams: [String: Any]?
    public var allowInvalidCertificates: Bool = true
    public var localCertificateUrls: [URL] = []
    public var isLogging: Bool = false

    public private(set) lazy var session: URLSession = self.prepareSession()
    public private(set) lazy var sessionConfiguration: URLSessionConfiguration = self.prepareSessionConfiguration()
    public private(set) lazy var sessionQueue: OperationQueue = self.prepareSessionQueue()
    internal var queue: DispatchQueue = DispatchQueue(label: "QApiProvider")
    internal var queries: [Int: IQApiQuery] = [:]

    public override init() {
        super.init()
    }

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl

        super.init()
    }

    public func set(urlParam: String, value: Any?) {
        self.queue.sync {
            if let safeValue: Any = value {
                self.urlParams[urlParam] = safeValue
            } else {
                self.urlParams.removeValue(forKey: urlParam)
            }
        }
    }

    public func get(urlParam: String) -> Any? {
        var result: Any? = nil
        self.queue.sync {
            result = self.urlParams[urlParam]
        }
        return result
    }

    public func removeAllUrlParams() {
        self.queue.sync {
            self.urlParams.removeAll()
        }
    }

    public func set(header: String, value: String?) {
        self.queue.sync {
            if let safeValue: String = value {
                self.headers[header] = safeValue
            } else {
                self.headers.removeValue(forKey: header)
            }
        }
    }

    public func get(header: String) -> Any? {
        var result: Any? = nil
        self.queue.sync {
            result = self.headers[header]
        }
        return result
    }

    public func removeAllHeaders() {
        self.queue.sync {
            self.headers.removeAll()
        }
    }

    public func set(bodyParam: String, value: Any?) {
        self.queue.sync {
            if let safeValue: Any = value {
                if self.bodyParams == nil {
                    self.bodyParams = [:]
                }
                self.bodyParams![bodyParam] = safeValue
            } else {
                if self.bodyParams != nil {
                    self.bodyParams!.removeValue(forKey: bodyParam)
                }
            }
        }
    }

    public func get(bodyParam: String) -> Any? {
        var result: Any? = nil
        self.queue.sync {
            if self.bodyParams != nil {
                result = self.bodyParams![bodyParam]
            }
        }
        return result
    }

    public func removeAllBodyParams() {
        self.queue.sync {
            self.bodyParams = nil
        }
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            completed: completed
        )
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        download: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            download: download,
            completed: completed
        )
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        download: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            download: download,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        upload: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            upload: upload,
            completed: completed
        )
    }

    open func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        upload: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            upload: upload,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    open func send(query: IQApiQuery) {
        if query.prepare(session: self.session) == true {
            self.set(query: query)
            query.resume()
        }
    }

    public func cancel(query: IQApiQuery) {
        if query.provider === self {
            query.cancel()
        }
    }

    private func prepareSession() -> URLSession {
        return URLSession(
            configuration: self.sessionConfiguration,
            delegate: self,
            delegateQueue: self.sessionQueue
        )
    }

    private func prepareSessionConfiguration() -> URLSessionConfiguration {
        let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.timeoutIntervalForResource = 60
        return sessionConfiguration
    }

    private func prepareSessionQueue() -> OperationQueue {
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue;
    }

    open override var description: String {
        return ""
    }
    
}

extension QApiProvider: IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent: Int = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let baseUrl: URL = self.baseUrl {
            var debug: String = String()
            baseUrl.debugString(&debug, 0, nextIndent, indent)
            QDebugString("BaseUrl: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.urlParams.count > 0 {
            var debug: String = String()
            self.urlParams.debugString(&debug, 0, nextIndent, indent)
            QDebugString("UrlParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.headers.count > 0 {
            var debug: String = String()
            self.headers.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let bodyParams: [String: Any] = self.bodyParams {
            var debug: String = String()
            bodyParams.debugString(&debug, 0, nextIndent, indent)
            QDebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.allowInvalidCertificates == true {
            var debug: String = String()
            self.allowInvalidCertificates.debugString(&debug, 0, nextIndent, indent)
            QDebugString("AllowInvalidCertificates: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}
