//
//  Quickly
//

import XCTest
import Quickly

class QuicklyTimerTests : XCTestCase {

    func testSimple() {
        let trigger = self.expectation(description: "")
        let timer = QTimer(interval: 1)
        timer.onFinished = { (_) in
            trigger.fulfill()
        }
        timer.start()
        self.wait(for: [ trigger ], timeout: 10)
    }

    func testRepeated() {
        var repeatedIndex = 0
        let repeatedTrigger = [
            self.expectation(description: ""),
            self.expectation(description: ""),
            self.expectation(description: ""),
            self.expectation(description: ""),
            self.expectation(description: "")
        ]
        let finishedTrigger = self.expectation(description: "")
        let timer = QTimer(interval: 1, delay: 0, repeating: 5)
        timer.onRepeat = { (_) in
            repeatedTrigger[repeatedIndex].fulfill()
            repeatedIndex += 1
        }
        timer.onFinished = { (_) in
            finishedTrigger.fulfill()
        }
        timer.start()
        var waitTrigger: [XCTestExpectation] = []
        waitTrigger.append(contentsOf: repeatedTrigger)
        waitTrigger.append(finishedTrigger)
        self.wait(for: waitTrigger, timeout: 10)
    }

}
