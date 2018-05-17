//
//  Quickly
//

import XCTest
import Quickly

class QuicklyModelTests : XCTestCase {

    enum Enum : String, IQJsonValue {
        case case1 = "case1"
    }

    class RootModel: QJsonModel {

        var child: ChildModel?
        
        override class func from(json: QJson) throws -> IQJsonModel {
            let value: String = try json.get(path: "type")
            switch value {
            case "A": return try SubRootModel(json: json)
            default: return try super.from(json: json)
            }
        }

        required init(json: QJson) throws {
            self.child = try? json.get(path: "child")
            try super.init(json: json)
        }

    }
    
    class SubRootModel: RootModel {
    }

    class ChildModel: QJsonModel {

        var type: Enum
        var value: String

        required init(json: QJson) throws {
            self.type = try json.get(path: "type")
            self.value = try json.get(path: "value")
            try super.init(json: json)
        }

    }

    func testModel() {
        let json = try! QJson(string:
            "{ \"type\" : \"A\", \"child\": { \"type\" : \"case1\", \"value\" : \"1\" } }"
        )
        let model: RootModel = try! json.get()
        XCTAssert(model.child != nil)
    }

}
