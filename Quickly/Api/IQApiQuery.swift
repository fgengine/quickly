//
//  Quickly
//

import Foundation

public protocol IQApiQuery: class {

    var task: URLSessionTask? { get }
    var provider: IQApiProvider { get }
    var createAt: Date { get }

    func prepare(session: URLSession) -> Bool
    func resume()
    func suspend()
    func cancel()

    func upload(bytes: Int64, totalBytes: Int64)
    func resumeDownload(bytes: Int64, totalBytes: Int64)
    func download(bytes: Int64, totalBytes: Int64)
    func receive(response: URLResponse)
    func become(task: URLSessionTask)
    func receive(data: Data)
    func download(url: URL)
    func finish(error: Error?)

}
