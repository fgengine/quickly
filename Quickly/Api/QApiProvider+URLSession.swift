//
//  Quickly
//

import Quickly.Private

extension QApiProvider: URLSessionDelegate {

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
    )  {
        let challenge: QApiImplAuthenticationChallenge = QApiImplAuthenticationChallenge(
            localCertificateUrls: self.localCertificateUrls,
            allowInvalidCertificates: self.allowInvalidCertificates,
            challenge: challenge
        )
        completionHandler(challenge.disposition, challenge.credential)
    }

}

extension QApiProvider: URLSessionTaskDelegate {

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
        let challenge: QApiImplAuthenticationChallenge = QApiImplAuthenticationChallenge(
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
        if let request: URLRequest = task.originalRequest {
            if let stream: InputStream = request.httpBodyStream {
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
        if let query: IQApiQuery = self.getQuery(task: task) {
            query.upload(bytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
        }
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let query: IQApiQuery = self.removeQuery(task: task) {
            query.finish(error: error)
        }
    }

}

extension QApiProvider: URLSessionDataDelegate {

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void
    ) {
        if let query: IQApiQuery = self.getQuery(task: dataTask) {
            query.receive(response: response)
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask
    ) {
        if let query: IQApiQuery = self.moveQuery(fromTask: dataTask, toTask: downloadTask) {
            query.become(task: downloadTask)
        }
    }

    @available(iOS 9.0, *)
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask
    ) {
        if let query: IQApiQuery = self.moveQuery(fromTask: dataTask, toTask: streamTask) {
            query.become(task: streamTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let query: IQApiQuery = self.getQuery(task: dataTask) {
            query.receive(data: data)
        }
    }

}

extension QApiProvider: URLSessionDownloadDelegate {

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        if let query: IQApiQuery = self.getQuery(task: downloadTask) {
            if let response: URLResponse = downloadTask.response {
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
        if let query: IQApiQuery = self.getQuery(task: downloadTask) {
            query.download(bytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64
    ) {
        if let query: IQApiQuery = self.getQuery(task: downloadTask) {
            query.resumeDownload(bytes: fileOffset, totalBytes: expectedTotalBytes)
        }
    }

}
