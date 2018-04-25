//
//  Quickly
//

public protocol IQJsonModel {

    static func from(json: QJson) throws -> IQJsonModel

    init(json: QJson) throws

    func toJson() -> QJson?
    func toJson(json: QJson)

}
