//
//  Quickly
//

open class QApiRequest : IQApiRequest {

    public var method: String
    public var url: URL?
    public var urlPart: String?
    public var urlParams: [String: Any] = [:]
    public var trimArraySymbolsUrlParams: Bool = false
    public var headers: [String: String] = [:]
    public var bodyData: Data?
    public var bodyParams: [String: Any]?
    public var uploadItems: [QApiRequestUploadItem]?

    public var timeout: TimeInterval = 30
    public var retries: TimeInterval = 0
    public var delay: TimeInterval = 1
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var isLogging: Bool = false

    public init(method: String) {
        self.method = method
    }

    public convenience init(method: String, url: URL) {
        self.init(method: method)
        self.url = url
    }

    public convenience init(method: String, urlPart: String) {
        self.init(method: method)
        self.urlPart = urlPart
    }

    public func set(urlParam: String, value: Any?) {
        if let safeValue = value {
            self.urlParams[urlParam] = safeValue
        } else {
            self.urlParams.removeValue(forKey: urlParam)
        }
    }

    public func get(urlParam: String) -> Any? {
        return self.urlParams[urlParam]
    }

    public func removeAllUrlParams() {
        self.urlParams.removeAll()
    }

    public func set(header: String, value: String?) {
        if let safeValue = value {
            self.headers[header] = safeValue
        } else {
            self.headers.removeValue(forKey: header)
        }
    }

    public func get(header: String) -> Any? {
        return self.headers[header]
    }

    public func removeAllHeaders() {
        self.headers.removeAll()
    }

    public func set(bodyParam: String, value: Any?) {
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

    public func get(bodyParam: String) -> Any? {
        if self.bodyParams != nil {
            return self.bodyParams![bodyParam]
        }
        return nil
    }

    public func removeAllBodyParams() {
        self.bodyParams = nil
    }

    public func urlRequest(provider: IQApiProvider) -> URLRequest? {
        if var components = self.prepareUrlComponents(provider: provider) {
            components.percentEncodedQuery = self.prepareUrlQuery(query: components.query, provider: provider)
            if let url = components.url {
                var headers = self.prepareHeaders(provider: provider)
                let bodyData = self.prepareBody(provider: provider, headers: &headers)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = self.method
                urlRequest.cachePolicy = self.cachePolicy
                urlRequest.allHTTPHeaderFields = headers
                if let body = bodyData {
                    urlRequest.httpBody = body
                }
                return urlRequest
            }
        }
        return nil
    }

    private func prepareUrlComponents(provider: IQApiProvider) -> URLComponents? {
        if let selfUrl = self.url {
            return URLComponents(string: selfUrl.absoluteString)
        } else if let providerUrl = provider.baseUrl {
            if let urlPart = self.urlPart {
                var string = providerUrl.absoluteString
                if string.hasSuffix("/") == true {
                    string.append(urlPart)
                } else {
                    string.append("/\(urlPart)")
                }
                if let finalUrl = URL(string: string) {
                    return URLComponents(string: finalUrl.absoluteString)
                }
            } else {
                return URLComponents(string: providerUrl.absoluteString)
            }
        }
        return nil
    }

    private func prepareUrlQuery(query: String?, provider: IQApiProvider) -> String {
        var result = String()
        var allParams: [String: Any] = [:]
        provider.urlParams.forEach({ (key: String, value: Any) in
            allParams[key] = value
        })
        if let query = query {
            let componentsUrlParams = query.components(
                pairSeparatedBy: "&",
                valueSeparatedBy: "="
            )
            componentsUrlParams.forEach({ (key: String, value: Any) in
                allParams[key] = value
            })
        }
        self.urlParams.forEach({ (key: String, value: Any) in
            allParams[key] = value
        })
        let flatParams = self.flatParams(params: allParams)
        flatParams.forEach({ (key: String, value: Any) in
            let encodeKey = self.encode(urlKey: key)
            let encodeValue = self.encode(value: value)
            if result.count > 0 {
                result.append("&\(encodeKey)=\(encodeValue)")
            } else {
                result.append("\(encodeKey)=\(encodeValue)")
            }
        })
        return result
    }

    private func prepareHeaders(provider: IQApiProvider) -> [String: String] {
        var result: [String: String] = [:]
        provider.headers.forEach({ (key: String, value: String) in
            result[key] = value
        })
        self.headers.forEach({ (key: String, value: String) in
            result[key] = value
        })
        return result
    }

    private func prepareBody(provider: IQApiProvider, headers: inout [String: String]) -> Data? {
        if let bodyData = self.bodyData {
            headers["Content-Length"] = "\(bodyData.count)"
            return bodyData
        } else {
            var allParams: [String: Any] = [:]
            if let bodyParams = provider.bodyParams {
                bodyParams.forEach({ (key: String, value: Any) in
                    allParams[key] = value
                })
            }
            if let bodyParams = self.bodyParams {
                bodyParams.forEach({ (key: String, value: Any) in
                    allParams[key] = value
                })
            }
            let flatParams = self.flatParams(params: allParams)
            if let uploadedItems = self.uploadItems {
                var data = Data()
                let boundary = UUID().uuidString
                flatParams.forEach({ (key: String, value: Any) in
                    let encodeKey = self.encode(value: key)
                    let rowString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(encodeKey)\"\r\n\r\n\(value)\r\n"
                    if let rowData = rowString.data(using: .ascii) {
                        data.append(rowData)
                    }
                })
                uploadedItems.forEach({ (uploadedItem: QApiRequestUploadItem) in
                    let encodeName = self.encode(value: uploadedItem.name)
                    let encodeFilename = self.encode(value: uploadedItem.filename)
                    let headerString = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(encodeName)\"; filename=\"\(encodeFilename)\"\r\nContent-Type: \(uploadedItem.mimetype)\r\n\r\n"
                    if let headerData = headerString.data(using: .ascii) {
                        data.append(headerData)
                    }
                    data.append(uploadedItem.data)
                    let footerString = "\r\n"
                    if let footerData = footerString.data(using: .ascii) {
                        data.append(footerData)
                    }
                })
                let footerString = "--\(boundary)--\r\n"
                if let footerData = footerString.data(using: .ascii) {
                    data.append(footerData)
                }
                headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                headers["Content-Length"] = "\(data.count)"
                return data
            } else if flatParams.count > 0 {
                var paramsString = String()
                flatParams.forEach({ (key: String, value: Any) in
                    let encodeKey = self.encode(urlKey: key)
                    let encodeValue = self.encode(value: value)
                    if paramsString.count > 0 {
                        paramsString.append("&\(encodeKey)=\(encodeValue)")
                    } else {
                        paramsString.append("\(encodeKey)=\(encodeValue)")
                    }
                })
                if let data = paramsString.data(using: .ascii) {
                    headers["Content-Type"] = "application/x-www-form-urlencoded"
                    headers["Content-Length"] = "\(data.count)"
                    return data
                }
            }
        }
        return nil
    }

    private func flatParams(params: [String: Any]) -> [String: Any] {
        var flatParams: [String: Any] = [:]
        params.forEach { (key: String, value: Any) in
            self.flatParams(flatParams: &flatParams, path: key, value: value)
        }
        return flatParams
    }

    private func flatParams(flatParams: inout [String: Any], path: String, value: Any) {
        if let valueDictionary = value as? [String: Any] {
            valueDictionary.forEach { (subPath: String, subValue: Any) in
                self.flatParams(flatParams: &flatParams, path: "\(path)[\(subPath)]", value: subValue)
            }
        } else if let valueArray = value as? [Any] {
            var index = 0
            valueArray.forEach({ (subValue: Any) in
                self.flatParams(flatParams: &flatParams, path: "\(path)[\(index)]", value: subValue)
                index += 1
            })
        } else {
            flatParams[path] = value
        }
    }

    private func encode(urlKey: String) -> String {
        var string = urlKey
        if self.trimArraySymbolsUrlParams == true {
            if let regexp = try? NSRegularExpression(pattern: "\\[[0-9]+\\]", options: []) {
                string = regexp.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length: string.count), withTemplate: "")
            }
        }
        return self.encode(value: string)
    }

    private func encode(value: Any) -> String {
        return self.encode(value: "\(value)")
    }

    private func encode(value: String) -> String {
        return value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

}

extension QApiRequest : IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        QDebugString("Method: \(self.method)\n", &buffer, indent, nextIndent, indent)
        if let url = self.url {
            var debug = String()
            url.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let urlPart = self.urlPart {
            var debug = String()
            urlPart.debugString(&debug, 0, nextIndent, indent)
            QDebugString("UrlPart: \(debug)\n", &buffer, indent, nextIndent, indent)
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
        if let bodyData = self.bodyData {
            var debug = String()
            if let json = QJson(basePath: "", data: bodyData) {
                json.debugString(&debug, 0, nextIndent, indent)
            } else {
                bodyData.debugString(&debug, 0, nextIndent, indent)
            }
            QDebugString("Body: \(debug)\n", &buffer, indent, nextIndent, indent)
        } else {
            if let bodyParams = self.bodyParams {
                var debug = String()
                bodyParams.debugString(&debug, 0, nextIndent, indent)
                QDebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
            if let uploadItems = self.uploadItems {
                var debug = String()
                uploadItems.debugString(&debug, 0, nextIndent, indent)
                QDebugString("UploadItems: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }
        if self.timeout > TimeInterval.leastNonzeroMagnitude {
            var debug = String()
            self.timeout.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Timeout: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.retries > TimeInterval.leastNonzeroMagnitude {
            var debug = String()
            self.retries.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Retries: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.delay > TimeInterval.leastNonzeroMagnitude {
            var debug = String()
            self.delay.debugString(&debug, 0, nextIndent, indent)
            QDebugString("Delay: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

open class QApiRequestUploadItem {

    public private(set) var name: String
    public private(set) var filename: String
    public private(set) var mimetype: String
    public private(set) var data: Data

    public init(name: String, filename: String, mimetype: String, data: Data) {
        self.name = name
        self.filename = filename
        self.mimetype = mimetype
        self.data = data
    }

}

extension QApiRequestUploadItem : IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        QDebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        QDebugString("Filename: \(self.filename)\n", &buffer, indent, nextIndent, indent)
        QDebugString("Mimetype: \(self.mimetype)\n", &buffer, indent, nextIndent, indent)
        QDebugString("Fata: \(self.data)\n", &buffer, indent, nextIndent, indent)

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}
