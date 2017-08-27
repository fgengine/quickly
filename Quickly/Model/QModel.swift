//
//  Quickly
//

import Foundation

open class QModel: IQModel {

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

