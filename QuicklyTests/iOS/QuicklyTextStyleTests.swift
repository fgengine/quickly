//
//  Quickly
//

import XCTest
import Quickly

class QuicklyTextStyleTests: XCTestCase {

    func testTextStyle() {
        let style = QTextStyle()
        style.font = QPlatformFont.systemFont(ofSize: 10)
        let attributes = style.attributes
        XCTAssertTrue(attributes[.font] as? QPlatformFont == style.font)
    }

    func testParentTextStyle() {
        let parent = QTextStyle()
        parent.font = QPlatformFont.systemFont(ofSize: 10)

        let style1 = QTextStyle(parent: parent)
        style1.color = QPlatformColor.black
        let attributes1 = style1.attributes
        XCTAssertTrue(attributes1[.font] as? QPlatformFont === parent.font)
        XCTAssertTrue(attributes1[.foregroundColor] as? QPlatformColor === style1.color)

        let style2 = QTextStyle(parent: parent)
        style2.font = QPlatformFont.systemFont(ofSize: 12)
        style2.color = QPlatformColor.black
        let attributes2 = style2.attributes
        XCTAssertTrue(attributes2[.font] as? QPlatformFont === style2.font)
        XCTAssertTrue(attributes2[.foregroundColor] as? QPlatformColor === style2.color)

        let style3 = QTextStyle(parent: parent)
        let attributes3_1 = style3.attributes
        XCTAssertTrue(attributes3_1[.font] as? QPlatformFont === parent.font)
        style3.parent = nil
        let attributes3_2 = style3.attributes
        XCTAssertTrue(attributes3_2[.font] as? QPlatformFont == nil)
    }
    
}
