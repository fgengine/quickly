//
//  Quickly
//

import XCTest
import Quickly

class QuicklyTextStyleTests: XCTestCase {

    func testTextStyle() {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: 10)
        let attributes = style.attributes
        XCTAssertTrue(attributes[NSFontAttributeName] as? UIFont == style.font)
    }

    func testParentTextStyle() {
        let parent = QTextStyle()
        parent.font = UIFont.systemFont(ofSize: 10)

        let style1 = QTextStyle(parent: parent)
        style1.color = UIColor.black
        let attributes1 = style1.attributes
        XCTAssertTrue(attributes1[NSFontAttributeName] as? UIFont === parent.font)
        XCTAssertTrue(attributes1[NSForegroundColorAttributeName] as? UIColor === style1.color)

        let style2 = QTextStyle(parent: parent)
        style2.font = UIFont.systemFont(ofSize: 12)
        style2.color = UIColor.black
        let attributes2 = style2.attributes
        XCTAssertTrue(attributes2[NSFontAttributeName] as? UIFont === style2.font)
        XCTAssertTrue(attributes2[NSForegroundColorAttributeName] as? UIColor === style2.color)

        let style3 = QTextStyle(parent: parent)
        let attributes3_1 = style3.attributes
        XCTAssertTrue(attributes3_1[NSFontAttributeName] as? UIFont === parent.font)
        style3.parent = nil
        let attributes3_2 = style3.attributes
        XCTAssertTrue(attributes3_2[NSFontAttributeName] as? UIFont == nil)
    }
    
}
