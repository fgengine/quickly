//
//  Quickly
//

open class QApiResponse : IQApiResponse {

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
        if let httpResponse = response as? HTTPURLResponse {
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
        if let json = try? QJson(data: data) {
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

extension QApiResponse : IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let url = self.url {
            var debug = String()
            url.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let mimeType = self.mimeType {
            var debug = String()
            mimeType.debugString(&debug, 0, nextIndent, indent)
            QDebugString("MimeType: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let textEncodingName = self.textEncodingName {
            var debug = String()
            textEncodingName.debugString(&debug, 0, nextIndent, indent)
            QDebugString("TextEncodingName: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let httpStatusCode = self.httpStatusCode {
            var debug = String()
            httpStatusCode.debugString(&debug, 0, nextIndent, indent)
            QDebugString("HttpStatusCode: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let httpHeaders = self.httpHeaders {
            var debug = String()
            httpHeaders.debugString(&debug, 0, nextIndent, indent)
            QDebugString("HttpHeaders: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let error = self.error as IQDebug? {
            var debug = String()
            error.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Error: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}
