//
//  Quickly
//

import XCTest
import Quickly

class QuicklyObserverTests : XCTestCase {

    func testPriority() {
        var firstTriggered = false
        let firstResponder = FakeObserver({
            firstTriggered = true
        })
        let secondResponder = FakeObserver({
            XCTAssert(firstTriggered == true, "First not triggered")
        })
        let observer = QObserver< FakeObserver >()
        observer.add(firstResponder, priority: 0)
        observer.add(secondResponder, priority: 1)
        observer.notify({ $0.test() })
    }

    class FakeObserver {

        private var _onTest: () -> Void

        init(_ onTest: @escaping () -> Void) {
            self._onTest = onTest
        }

        func test() {
            self._onTest()
        }

    }

}
