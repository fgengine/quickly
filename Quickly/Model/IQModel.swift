//
//  Quickly
//

import Foundation

public protocol IQModel {

    init(json: QJson) throws

    func from(json: QJson) throws

    func toJson() -> QJson?
    func toJson(json: QJson)

}
