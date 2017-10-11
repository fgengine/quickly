//
//  Quickly
//

import XCTest
import Quickly

class QuicklyModelTests: XCTestCase {

    class RootModel: QModel {

        var child: ChildModel?
        
        override class func from(json: QJson) throws -> IQModel? {
            var value: String = ""
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

    class ChildModel: QModel {

        var value: String = ""
        
        override class func from(json: QJson) throws -> IQModel? {
            var value: String?
            value <<< (json, "value")
            guard let _: String = value else {
                return try ChildModel(json: json)
            }
            return try super.from(json: json)
        }

        override func from(json: QJson) throws {
            try self.value <<< (json, "value")
        }

    }

    func testModel() {
        let json: QJson = QJson(basePath: "", string:
            "[ { \"type\" : \"A\", \"child\": \"1\" } ]"
        )!
        var models: [RootModel]!
        models <<< json
        XCTAssert(models.first!.child == nil)
    }

}
