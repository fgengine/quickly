//
//  Quickly
//

import Foundation

public protocol IQApiTaskQuery : IQApiQuery {

    var task: URLSessionTask? { get }

    func prepare(session: URLSession) -> Bool
    
    func upload(bytes: Int64, totalBytes: Int64)
    func resumeDownload(bytes: Int64, totalBytes: Int64)
    func download(bytes: Int64, totalBytes: Int64)
    func receive(response: URLResponse)
    func become(task: URLSessionTask)
    func receive(data: Data)
    func download(url: URL)
    func finish(error: Error?)

}
