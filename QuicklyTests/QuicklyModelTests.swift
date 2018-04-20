//
//  Quickly
//

import XCTest
import Quickly

class QuicklyModelTests: XCTestCase {

    class RootModel: QJsonModel {

        var child: ChildModel?
        
        override class func from(json: QJson) throws -> IQJsonModel? {
            var value = ""
            try value <<< (json, "type")
            switch value {
            case "A": return try SubRootModel(json: json)
            default: return try super.from(json: json)
            }
        }

        override func from(json: QJson) throws {
            self.child <<< (json, "child")
        }

    }
    
    class SubRootModel: RootModel {
    }

    class ChildModel: QJsonModel {

        var value = ""
        
        override class func from(json: QJson) throws -> IQJsonModel? {
            var value: String?
            value <<< (json, "value")
            guard let _ = value else {
                return try ChildModel(json: json)
            }
            return try super.from(json: json)
        }

        override func from(json: QJson) throws {
            try self.value <<< (json, "value")
        }

    }

    func testModel() {
        let json = QJson(basePath: "", string:
            "[ { \"type\" : \"A\", \"child\": \"1\" } ]"
        )!
        var models: [RootModel] = []
        models <<< json
        XCTAssert(models.first!.child == nil)
    }

}
