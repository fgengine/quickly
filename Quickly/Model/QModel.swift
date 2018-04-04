//
//  Quickly
//

import Quickly.Private

open class QModel : IQModel {

    open class func from(json: QJson) throws -> IQModel? {
        if json.isDictionary() == true {
            return try self.init(json: json)
        }
        return nil
    }

    public init() {
    }

    public required init(json: QJson) throws {
        #if DEBUG
            do {
                try self.from(json: json)
            } catch let error as NSError {
                switch error.domain {
                case QJsonErrorDomain:
                    if let path = error.userInfo[QJsonErrorPathKey] {
                        print("QModel::\(String(describing: self)) invalid parse from JSON in path '\(path)'")
                    } else {
                        print("QModel::\(String(describing: self)) invalid parse from JSON")
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

extension QModel : IQDebug {

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

extension QModel : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        guard let value = value else {
            throw QJsonImpl.convertError(at: at)
        }
        guard let model = try self.from(json: QJson(basePath: at, root: value)) else {
            throw QJsonImpl.convertError(at: at)
        }
        return model
    }

    public func toJsonValue() -> Any? {
        if let json = self.toJson() {
            return json.root
        }
        return nil
    }
    
}

public func >>> < Type: IJsonValue & IQModel >(left: Type, right: QJson) {
    if let json = left.toJson() {
        if let dict = json.dictionary() {
            right.set(dict)
        }
    }
}

public func <<< < Type: IJsonValue & IQModel >(left: inout Type, right: QJson) throws {
    left = try Type.from(json: right) as! Type
}

public func <<< < Type: IJsonValue & IQModel >(left: inout Type?, right: QJson) {
    if let model = try? Type.from(json: right) {
        left = model as? Type
    } else {
        left = nil
    }
}
