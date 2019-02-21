//
//  Quickly
//

public protocol IQJsonModel {

    static func from(json: QJson) throws -> IQJsonModel

    init(json: QJson) throws

    func toJson() throws -> QJson?
    func toJson(json: QJson) throws

}
