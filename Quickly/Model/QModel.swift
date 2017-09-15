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
        let json = QJson()
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

