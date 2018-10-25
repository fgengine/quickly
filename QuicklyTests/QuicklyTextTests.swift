//
//  Quickly
//

import XCTest
import Quickly

class QuicklyTextTests : XCTestCase {

    func testText() {
        let text = QText(NSAttributedString(string: "Test"))
        XCTAssertTrue(text.attributed.length == 4)
    }

    func testStyledText() {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: 10)
        let text = QAttributedText("Test", style: style)
        XCTAssertTrue(text.attributed.length == 4)
    }

    func testFormatText() {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: 10)
        style.color = UIColor.gray

        let linkStyle = QTextStyle(parent: style)
        linkStyle.color = UIColor.black

        let text = QFormatText("The test {link}", style: style, parts: [
            "{link}": QAttributedText("example.com", style: linkStyle)
       ])
        XCTAssertTrue(text.attributed.length == 20)
    }
    
}
