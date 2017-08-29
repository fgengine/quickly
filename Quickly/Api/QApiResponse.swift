//
//  Quickly
//

import Foundation

open class QApiResponse: IQApiResponse {

    public private(set) var url: URL?
    public private(set) var mimeType: String?
    public private(set) var textEncodingName: String?
    public private(set) var httpStatusCode: Int?
    public private(set) var httpHeaders: [AnyHashable: Any]?
    public var error: Error?

    public init() {
    }

    open func parse(response: URLResponse, data: Data) {
        self.url = response.url
        self.mimeType = response.mimeType
        self.textEncodingName = response.textEncodingName
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            self.httpStatusCode = httpResponse.statusCode
            self.httpHeaders = httpResponse.allHeaderFields
        }
        do {
            try self.parse(data: data)
        } catch let error {
            self.parse(error: error)
        }
    }

    open func parse(data: Data) throws {
        if let json: QJson = QJson(data: data) {
            do {
                try self.parse(json: json)
            } catch let error {
                self.parse(error: error)
            }
        } else {
            self.parse(error: QApiError.invalidResponse)
        }
    }

    open func parse(json: QJson) throws {
    }

    open func parse(error: Error) {
        self.error = error
    }

    open func reset() {
        self.url = nil
        self.mimeType = nil
        self.textEncodingName = nil
        self.httpStatusCode = nil
        self.httpHeaders = nil
        self.error = nil
    }

}

extension QApiResponse: CustomStringConvertible {

    public var description: String {
        return ""
    }
    
}
