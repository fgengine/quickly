//
//  Quickly
//

import Foundation

open class QApiProvider: NSObject, IQApiProvider {

    public var baseUrl: URL? = nil
    public var urlParams: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var bodyParams: [String: Any]?
    public var allowInvalidCertificates: Bool = true
    public var localCertificateUrl: URL? = nil
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

    public func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    public func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        download: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            download: download,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    public func send<
        RequestType: IQApiRequest,
        ResponseType: IQApiResponse
    >(
        request: RequestType,
        response: ResponseType,
        upload: @escaping QApiQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiQuery< RequestType, ResponseType > {
        let query: QApiQuery< RequestType, ResponseType > = QApiQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            upload: upload,
            completed: completed
        )
        self.send(query: query)
        return query
    }

    public func send(query: IQApiQuery) {
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
