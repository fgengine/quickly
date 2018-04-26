//
//  Quickly
//

import Quickly.Private

open class QJsonModel : IQJsonModel {

    open class func from(json: QJson) throws -> IQJsonModel {
        guard json.isDictionary() == true else {
            throw QJsonError.cast(path: json.basePath)
        }
        #if DEBUG
        do {
            return try self.init(json: json)
        } catch let error as QJsonError {
            switch error {
            case .notJson: print("QJsonModel::\(String(describing: self)) Not JSON")
            case .access(let path): print("QJsonModel::\(String(describing: self)) invalid set/get from JSON in path '\(path)'")
            case .cast(let path): print("QJsonModel::\(String(describing: self)) invalid cast from JSON in path '\(path)'")
            }
            throw error
        } catch let error {
            throw error
        }
        #else
        return try self.init(json: json)
        #endif
    }

    public init() {
    }

    public required init(json: QJson) throws {
    }

    public final func toJson() -> QJson? {
        let json = QJson(basePath: "")
        self.toJson(json: json)
        return json
    }

    open func toJson(json: QJson) {
    }

}

extension QJsonModel : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> IQJsonModel {
        return try self.from(json: QJson(root: value, basePath: path))
    }

    public func toJsonValue(path: String) throws -> Any {
        guard let json = self.toJson(), let root = json.root else {
            throw QJsonError.cast(path: path)
        }
        return root
    }

}

extension QJsonModel : IQDebug {

    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        let mirror = Mirror(reflecting: self)
        for (label, value) in mirror.children {
            guard let label = label else {
                continue
            }
            var debug = String()
            if let debugValue = value as? IQDebug {
                debugValue.debugString(&debug, 0, nextIndent, indent)
            } else {
                debug.append("\(value)")
            }
            QDebugString("\(label) : \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }

}
