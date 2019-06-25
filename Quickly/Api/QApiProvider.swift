//
//  Quickly
//

public final class QApiProvider : NSObject, IQApiProvider {

    public var baseUrl: URL? = nil
    public var urlParams: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var bodyParams: [String: Any]?
    public var allowInvalidCertificates: Bool = false
    public var localCertificateUrls: [URL] = []
    #if DEBUG
    public var logging: QApiLogging = .never
    #endif

    public private(set) lazy var session: URLSession = URLSession(
        configuration: self.sessionConfiguration,
        delegate: self,
        delegateQueue: self.sessionQueue
    )
    public private(set) var sessionConfiguration: URLSessionConfiguration
    public private(set) var sessionQueue: OperationQueue
    
    private var _queue: DispatchQueue = DispatchQueue(label: "QApiProvider")
    private var _taskQueries: [Int: IQApiTaskQuery] = [:]

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
    
    public func send(query: IQApiQuery) {
        if let taskQuery = query as? IQApiTaskQuery {
            if taskQuery.prepare(session: self.session) == true {
                self._set(query: taskQuery)
                taskQuery.start()
            }
        } else {
            query.start()
        }
    }
    
}

public extension QApiProvider {

    func set(urlParam: String, value: Any?) {
        self._queue.sync {
            if let safeValue = value {
                self.urlParams[urlParam] = safeValue
            } else {
                self.urlParams.removeValue(forKey: urlParam)
            }
        }
    }

    func get(urlParam: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            result = self.urlParams[urlParam]
        }
        return result
    }

    func removeAllUrlParams() {
        self._queue.sync {
            self.urlParams.removeAll()
        }
    }

    func set(header: String, value: String?) {
        self._queue.sync {
            if let safeValue = value {
                self.headers[header] = safeValue
            } else {
                self.headers.removeValue(forKey: header)
            }
        }
    }

    func get(header: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            result = self.headers[header]
        }
        return result
    }

    func removeAllHeaders() {
        self._queue.sync {
            self.headers.removeAll()
        }
    }

    func set(bodyParam: String, value: Any?) {
        self._queue.sync {
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

    func get(bodyParam: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            if self.bodyParams != nil {
                result = self.bodyParams![bodyParam]
            }
        }
        return result
    }

    func removeAllBodyParams() {
        self._queue.sync {
            self.bodyParams = nil
        }
    }
    
}

// MARK: Send • Task

public extension QApiProvider {

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            completed: completed
        )
    }

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        let query = QApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        download: @escaping QApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            download: download,
            completed: completed
        )
    }

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        download: @escaping QApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        let query = QApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onDownload: download,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        upload: @escaping QApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        return self.send(
            request: request,
            response: response,
            queue: DispatchQueue.main,
            upload: upload,
            completed: completed
        )
    }

    func send< RequestType: IQApiRequest, ResponseType: IQApiResponse >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue,
        upload: @escaping QApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping QApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> QApiTaskQuery< RequestType, ResponseType > {
        let query = QApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onUpload: upload,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }
    
}

// MARK: Send • Mock

public extension QApiProvider {
    
    func send< ResponseType: IQApiResponse >(
        response: ResponseType,
        prepare: @escaping QApiMockQuery< ResponseType >.PrepareClosure,
        completed: @escaping QApiMockQuery< ResponseType >.CompleteClosure
    ) -> QApiMockQuery< ResponseType > {
        return self.send(
            response: response,
            queue: DispatchQueue.main,
            prepare: prepare,
            completed: completed
        )
    }
    
    func send< ResponseType: IQApiResponse >(
        response: ResponseType,
        queue: DispatchQueue,
        prepare: @escaping QApiMockQuery< ResponseType >.PrepareClosure,
        completed: @escaping QApiMockQuery< ResponseType >.CompleteClosure
    ) -> QApiMockQuery<  ResponseType > {
        let query = QApiMockQuery< ResponseType >(
            provider: self,
            response: response,
            queue: queue,
            onPrepare: prepare,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }
    
}

// MARK: Private

private extension QApiProvider {
    
    func _set(query: IQApiTaskQuery) {
        self._queue.sync {
            self._taskQueries[query.task!.taskIdentifier] = query
        }
    }
    
    func _query(task: URLSessionTask) -> IQApiTaskQuery? {
        var query: IQApiTaskQuery? = nil
        self._queue.sync {
            query = self._taskQueries[task.taskIdentifier]
        }
        return query
    }
    
    func _remove(task: URLSessionTask) -> IQApiTaskQuery? {
        var query: IQApiTaskQuery? = nil
        self._queue.sync {
            let key = task.taskIdentifier
            query = self._taskQueries[key]
            self._taskQueries.removeValue(forKey: key)
        }
        return query
    }
    
    func _move(fromTask: URLSessionTask, toTask: URLSessionTask) -> IQApiTaskQuery? {
        var query: IQApiTaskQuery? = nil
        self._queue.sync {
            query = self._taskQueries[fromTask.taskIdentifier]
            self._taskQueries.removeValue(forKey: fromTask.taskIdentifier)
            if let query = query {
                self._taskQueries[toTask.taskIdentifier] = query
            }
        }
        return query
    }
    
}

extension QApiProvider : URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Error?
    ) {
        self._queue.sync {
            self._taskQueries.removeAll()
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
        if let query = self._query(task: task) {
            query.upload(bytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
        }
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let query = self._remove(task: task) {
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
        if let query = self._query(task: dataTask) {
            query.receive(response: response)
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask
    ) {
        if let query = self._move(fromTask: dataTask, toTask: downloadTask) {
            query.become(task: downloadTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask
    ) {
        if let query = self._move(fromTask: dataTask, toTask: streamTask) {
            query.become(task: streamTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let query = self._query(task: dataTask) {
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
        if let query = self._query(task: downloadTask) {
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
        if let query = self._query(task: downloadTask) {
            query.download(bytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64
    ) {
        if let query = self._query(task: downloadTask) {
            query.resumeDownload(bytes: fileOffset, totalBytes: expectedTotalBytes)
        }
    }
    
}

#if DEBUG

extension QApiProvider : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let baseUrl = self.baseUrl {
            let debug = baseUrl.debugString(0, nextIndent, indent)
            QDebugString("BaseUrl: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.urlParams.count > 0 {
            let debug = self.urlParams.debugString(0, nextIndent, indent)
            QDebugString("UrlParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.headers.count > 0 {
            let debug = self.headers.debugString(0, nextIndent, indent)
            QDebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let bodyParams = self.bodyParams {
            let debug = bodyParams.debugString(0, nextIndent, indent)
            QDebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.allowInvalidCertificates == true {
            let debug = self.allowInvalidCertificates.debugString(0, nextIndent, indent)
            QDebugString("AllowInvalidCertificates: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
