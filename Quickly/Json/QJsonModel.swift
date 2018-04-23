//
//  Quickly
//

import Quickly.Private

open class QJsonModel : IQJsonModel {

    open class func from(json: QJson) throws -> IQJsonModel? {
        if json.isDictionary() == true {
            return try self.init(json: json)
        }
        return nil
    }

    public required init(json: QJson) throws {
        #if DEBUG
            do {
                try self.from(json: json)
            } catch let error as NSError {
                switch error.domain {
                case QJsonErrorDomain:
                    if let path = error.userInfo[QJsonErrorPathKey] {
                        print("QJsonModel::\(String(describing: self)) invalid parse from JSON in path '\(path)'")
                    } else {
                        print("QJsonModel::\(String(describing: self)) invalid parse from JSON")
                    }
                    break
                default: break
                }
                throw error
            } catch let error {
                throw error
            }
        #else
            try self.from(json: json)
        #endif
    }

    open func from(json: QJson) throws {
    }

    public final func toJson() -> QJson? {
        let json = QJson(basePath: "")
        self.toJson(json: json)
        return json
    }

    open func toJson(json: QJson) {
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
