//
//  Quickly
//

import Foundation

open class QModel: IQModel {

    open class func from(json: QJson) throws -> IQModel? {
        return try self.init(json: json)
    }

    public init() {
    }

    public required init(json: QJson) throws {
        try self.from(json: json)
    }

    open func from(json: QJson) throws {
    }

    public final func toJson() -> QJson? {
        let json: QJson = QJson()
        self.toJson(json: json)
        return json
    }

    open func toJson(json: QJson) {
    }

}

extension QModel: IJsonValue {

    public static func fromJson(value: Any?) throws -> Any {
        guard let value: Any = value else {
            throw NSError(domain: QJsonErrorDomain, code: QJsonErrorCode.convert.rawValue, userInfo: nil)
        }
        guard let model: IQModel = try self.from(json: QJson(root: value)) else {
            throw NSError(domain: QJsonErrorDomain, code: QJsonErrorCode.convert.rawValue, userInfo: nil)
        }
        return model
    }

    public func toJsonValue() -> Any? {
        if let json: QJson = self.toJson() {
            return json.root
        }
        return nil
    }
    
}

public func >>> < Type: IJsonValue & IQModel >(left: Type, right: QJson) {
    if let json: QJson = left.toJson() {
        if let dict: [AnyHashable: Any] = json.dictionary() {
            right.set(dict)
        }
    }
}

public func <<< < Type: IJsonValue & IQModel >(left: inout Type, right: QJson) throws {
    guard let model: IQModel = try Type.from(json: right) else {
        throw NSError(domain: QJsonErrorDomain, code: QJsonErrorCode.convert.rawValue, userInfo: nil)
    }
    left = model as! Type
}

public func <<< < Type: IJsonValue & IQModel >(left: inout Type!, right: QJson) throws {
    guard let model: IQModel = try Type.from(json: right) else {
        throw NSError(domain: QJsonErrorDomain, code: QJsonErrorCode.convert.rawValue, userInfo: nil)
    }
    left = model as! Type
}

public func <<< < Type: IJsonValue & IQModel >(left: inout Type?, right: QJson) {
    if let model: IQModel? = try? Type.from(json: right) {
        if let model: IQModel = model {
            left = model as? Type
        } else {
            left = nil
        }
    } else {
        left = nil
    }
}
