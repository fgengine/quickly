//
//  Quickly
//

import XCTest
import Quickly

class QuicklyJsonTests : XCTestCase {

    private func _fakeJson() -> QJson {
        return QJson(root: [
            "bool": true,
            "int": 1,
            "uint": 1,
            "float": 1.9,
            "double": 1.9,
            "numberString": "1",
            "string": "test",
            "date": "183548353",
            "color_gg": "#aa",
            "color_rgb": "#4da",
            "color_rrggbb": "#40d0a0",
            "color_rrggbbaa": "#40d0a070"
       ])
    }

    func testDebugJson() {
        let json = self._fakeJson()
        print(json.debugString())
    }

    func testSimpleGetJson() {
        let json = self._fakeJson()

        let bool: Bool = try! json.get(path: "bool")
        XCTAssert(bool == true)

        let int: Int = try! json.get(path: "int")
        XCTAssert(int == 1)

        let uint: UInt = try! json.get(path: "uint")
        XCTAssert(uint == 1)

        let float: Float = try! json.get(path: "float")
        XCTAssert(float == 1.9)

        let double: Float = try! json.get(path: "double")
        XCTAssert(double == 1.9)

        let numberString: Int = try! json.get(path: "numberString")
        XCTAssert(numberString == 1)

        let string: String = try! json.get(path: "string")
        XCTAssert(string == "test")

        let colorGG: UIColor = try! json.get(path: "color_gg")
        XCTAssert(colorGG == UIColor(hex: 0xaaaaaaff))

        let colorRGB: UIColor = try! json.get(path: "color_rgb")
        XCTAssert(colorRGB == UIColor(hex: 0x44ddaaff))

        let colorRRGGBB: UIColor = try! json.get(path: "color_rrggbb")
        XCTAssert(colorRRGGBB == UIColor(hex: 0x40d0a0ff))

        let colorRRGGBBAA: UIColor = try! json.get(path: "color_rrggbbaa")
        XCTAssert(colorRRGGBBAA == UIColor(hex: 0x40d0a070))
    }
    
}
