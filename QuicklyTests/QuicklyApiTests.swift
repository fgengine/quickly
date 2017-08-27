//
//  Quickly
//

import XCTest
import Quickly

class QuicklyApiTests: XCTestCase {

    func testGetApi() {
        let expectation = self.expectation(description: "")

        let provider: QApiProvider = QApiProvider(baseUrl: URL(string: "http://yandex.ru")!)
        let request: QApiRequest = QApiRequest(method: "GET")
        let response: QApiResponse = QApiResponse()
        let query: IQApiQuery = provider.send(request: request, response: response) { (request: QApiRequest, response: QApiResponse) in
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 100)
    }
    
}
