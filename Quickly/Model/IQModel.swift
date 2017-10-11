//
//  Quickly
//

public protocol IQModel {

    static func from(json: QJson) throws -> IQModel?

    init(json: QJson) throws

    func from(json: QJson) throws

    func toJson() -> QJson?
    func toJson(json: QJson)

}
