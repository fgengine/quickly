//
//  Quickly
//

open class QApiProvider : NSObject, IQApiProvider {

    public var baseUrl: URL? = nil
    public var urlParams: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var bodyParams: [String: Any]?
    public var allowInvalidCertificates: Bool = false
    public var localCertificateUrls: [URL] = []
    public var logging: QApiLogging = .never

    public private(set) lazy var session: URLSession = self.prepareSession()
    public private(set) var sessionConfiguration: URLSessionConfiguration
    public private(set) var sessionQueue: OperationQueue
    
    internal var queue: DispatchQueue = DispatchQueue(label: "QApiProvider")
    internal var queries: [Int: IQApiQuery] = [:]

    public init(sessionConfiguration: URLSessionConfiguration, sessionQueue: OperationQueue) {
        self.sessionConfiguration = sessionConfiguration
        self.sessionQueue = sessionQueue
        super.init()
    }

    public init(baseUrl: URL, sessionConfiguration: URLSessionConfiguration, sessionQueue: OperationQueue) {
        self.baseUrl = baseUrl
        self.sessionConfiguration = sessionConfiguration
        self.sessionQueue = sessionQueue
        super.init()
    }

    public func set(urlParam: String, value: Any?) {
        self.queue.sync {
            if let safeValue = value {
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
            if let safeValue = value {
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
            if let safeValue = value {
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
    
}

extension QApiProvider {

    private func prepareSession() -> URLSession {
        return URLSession(
            configuration: self.sessionConfiguration,
            delegate: self,
            delegateQueue: self.sessionQueue
        )
    }
    
}

extension QApiProvider : URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Error?
    ) {
        self.queue.sync {
            self.queries.removeAll()
        }
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        let challenge = QImplAuthenticationChallenge(
            localCertificateUrls: self.localCertificateUrls,
            allowInvalidCertificates: self.allowInvalidCertificates,
            challenge: challenge
        )
        completionHandler(challenge.disposition, challenge.credential)
    }
    
}

extension QApiProvider : URLSessionTaskDelegate {

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Swift.Void
    ) {
        completionHandler(request)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        let challenge = QImplAuthenticationChallenge(
            localCertificateUrls: self.localCertificateUrls,
            allowInvalidCertificates: self.allowInvalidCertificates,
            challenge: challenge
        )
        completionHandler(challenge.disposition, challenge.credential)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void
    ) {
        var inputStream: InputStream? = nil
        if let request = task.originalRequest {
            if let stream = request.httpBodyStream {
                inputStream = stream.copy() as? InputStream
            }
        }
        completionHandler(inputStream)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        if let query = self.getQuery(task: task) {
            query.upload(bytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
        }
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let query = self.removeQuery(task: task) {
            query.finish(error: error)
        }
    }
    
}

extension QApiProvider : URLSessionDataDelegate {

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void
    ) {
        if let query = self.getQuery(task: dataTask) {
            query.receive(response: response)
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask
    ) {
        if let query = self.moveQuery(fromTask: dataTask, toTask: downloadTask) {
            query.become(task: downloadTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask
    ) {
        if let query = self.moveQuery(fromTask: dataTask, toTask: streamTask) {
            query.become(task: streamTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let query = self.getQuery(task: dataTask) {
            query.receive(data: data)
        }
    }
    
}

extension QApiProvider : URLSessionDownloadDelegate {

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        if let query = self.getQuery(task: downloadTask) {
            if let response = downloadTask.response {
                query.receive(response: response)
            }
            query.download(url: location)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        if let query = self.getQuery(task: downloadTask) {
            query.download(bytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64
    ) {
        if let query = self.getQuery(task: downloadTask) {
            query.resumeDownload(bytes: fileOffset, totalBytes: expectedTotalBytes)
        }
    }
    
}

extension QApiProvider : IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let baseUrl = self.baseUrl {
            var debug = String()
            baseUrl.debugString(&debug, 0, nextIndent, indent)
            QDebugString("BaseUrl: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.urlParams.count > 0 {
            var debug = String()
            self.urlParams.debugString(&debug, 0, nextIndent, indent)
            QDebugString("UrlParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.headers.count > 0 {
            var debug = String()
            self.headers.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let bodyParams = self.bodyParams {
            var debug = String()
            bodyParams.debugString(&debug, 0, nextIndent, indent)
            QDebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.allowInvalidCertificates == true {
            var debug = String()
            self.allowInvalidCertificates.debugString(&debug, 0, nextIndent, indent)
            QDebugString("AllowInvalidCertificates: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}
