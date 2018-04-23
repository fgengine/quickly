//
//  Quickly
//

public protocol IQJsonModel : IJsonValue {

    static func from(json: QJson) throws -> IQJsonModel?

    init(json: QJson) throws

    func from(json: QJson) throws

    func toJson() -> QJson?
    func toJson(json: QJson)

}

extension IQJsonModel {

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

public func >>> < Type: IQJsonModel >(left: Type, right: QJson) {
    guard let json = left.toJson(), let dict = json.dictionary() else { return }
    right.set(dict)
}

public func <<< < Type: IQJsonModel >(left: inout Type, right: QJson) throws {
    left = try Type.from(json: right) as! Type
}

public func <<< < Type: IQJsonModel >(left: inout Type!, right: QJson) throws {
    left = try Type.from(json: right) as! Type
}

public func <<? < Type: IQJsonModel >(left: inout Type?, right: QJson) {
    if let model = try? Type.from(json: right) {
        left = model as? Type
    } else {
        left = nil
    }
}
