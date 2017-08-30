//
//  Quickly
//

import Foundation

public class QApiQuery<
    RequestType: IQApiRequest,
    ResponseType: IQApiResponse
>: IQApiQuery {

    public typealias ProgressClosure = (_ progress: Progress) -> Void
    public typealias CompleteClosure = (_ request: RequestType, _ response: ResponseType) -> Void

    public private(set) var task: URLSessionTask?
    public private(set) var provider: IQApiProvider
    public private(set) var createAt: Date

    public private(set) var request: RequestType
    public private(set) var response: ResponseType
    public private(set) var downloadProgress: Progress = Progress()
    public private(set) var download: ProgressClosure?
    public private(set) var uploadProgress: Progress = Progress()
    public private(set) var upload: ProgressClosure?
    public private(set) var completed: CompleteClosure

    private var receivedResponse: URLResponse?
    private var receivedData: Data?

    public init(
        provider: IQApiProvider,
        request: RequestType,
        response: ResponseType,
        completed: @escaping CompleteClosure
    ) {
        self.createAt = Date()
        self.provider = provider
        self.request = request
        self.response = response
        self.completed = completed
    }

    public convenience init(
        provider: IQApiProvider,
        request: RequestType,
        response: ResponseType,
        download: @escaping ProgressClosure,
        completed: @escaping CompleteClosure
    ) {
        self.init(
            provider: provider,
            request: request,
            response: response,
            completed: completed
        )

        self.download = download
    }

    public convenience init(
        provider: IQApiProvider,
        request: RequestType,
        response: ResponseType,
        upload: @escaping ProgressClosure,
        completed: @escaping CompleteClosure
    ) {
        self.init(
            provider: provider,
            request: request,
            response: response,
            completed: completed
        )

        self.upload = upload
    }

    public func prepare(session: URLSession) -> Bool {
        if self.task == nil {
            if let urlRequest: URLRequest = self.request.urlRequest(provider: self.provider) {
                if self.download != nil {
                    self.task = session.downloadTask(with: urlRequest)
                } else if self.upload != nil {
                    self.task = session.uploadTask(withStreamedRequest: urlRequest)
                } else {
                    self.task = session.dataTask(with: urlRequest)
                }
            }
        }
        return self.task != nil
    }

    public func resume() {
        if let task: URLSessionTask = self.task {
            task.resume()
        }
    }

    public func suspend() {
        if let task: URLSessionTask = self.task {
            task.suspend()
        }
    }

    public func cancel() {
        if let task: URLSessionTask = self.task {
            task.cancel()
            self.task = nil
            self.receivedResponse = nil
            self.receivedData = nil
        }
    }

    public func upload(bytes: Int64, totalBytes: Int64) {
        self.uploadProgress.totalUnitCount = totalBytes
        self.uploadProgress.completedUnitCount = bytes
        if let upload: ProgressClosure = self.upload {
            DispatchQueue.main.async {
                upload(self.uploadProgress)
            }
        }
    }

    public func resumeDownload(bytes: Int64, totalBytes: Int64) {
        self.downloadProgress.totalUnitCount = totalBytes
        self.downloadProgress.completedUnitCount = bytes
        if let download: ProgressClosure = self.download {
            DispatchQueue.main.async {
                download(self.downloadProgress)
            }
        }
    }

    public func download(bytes: Int64, totalBytes: Int64) {
        self.downloadProgress.totalUnitCount = totalBytes
        self.downloadProgress.completedUnitCount = bytes
        if let download: ProgressClosure = self.download {
            DispatchQueue.main.async {
                download(self.downloadProgress)
            }
        }
    }

    public func receive(response: URLResponse) {
        self.receivedResponse = response
    }

    public func become(task: URLSessionTask) {
        self.task = task
    }

    public func receive(data: Data) {
        if self.receivedData != nil {
            self.receivedData!.append(data)
        } else {
            self.receivedData = data
        }
    }

    public func download(url: URL) {
        if let data: Data = try? Data(contentsOf: url) {
            self.receivedData = data
        }
    }

    public func finish(error: Error?) {
        self.task = nil
        if let error: NSError = error as NSError? {
            if error.isUrlErrorCancelled() == false {
                self.parse(error: error)
            }
        } else {
            self.parse()
        }
    }

    private func parse() {
        guard let response: URLResponse = self.receivedResponse, let data: Data = self.receivedData else {
            return
        }
        self.response.parse(response: response, data: data)
        self.completeIfNeeded()
    }

    private func parse(error: Error) {
        self.response.parse(error: error)
        self.completeIfNeeded()
    }

    private func completeIfNeeded() {
        if self.response.error == nil {
            self.complete()
        } else {
            if(abs(self.createAt.timeIntervalSinceNow) <= self.request.retries) {
                self.response.reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + self.request.delay, execute: {
                    self.provider.send(query: self)
                })
            } else {
                self.complete()
            }
        }
    }

    private func complete() {
        if (self.request.isLogging == true) || (self.provider.isLogging == true) {
            print("\(self.request) \(self.response)")
        }
        DispatchQueue.main.async {
            self.completed(self.request, self.response)
        }
    }

}

extension QApiQuery: CustomStringConvertible {

    public var description: String {
        return ""
    }

}
