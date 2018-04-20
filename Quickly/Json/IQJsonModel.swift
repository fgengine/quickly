//
//  Quickly
//

public protocol IQJsonModel : class {

    static func from(json: QJson) throws -> IQJsonModel?

    init(json: QJson) throws

    func from(json: QJson) throws

    func toJson() -> QJson?
    func toJson(json: QJson)

}
