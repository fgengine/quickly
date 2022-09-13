//
//  Quickly
//

import UIKit

public class QImageRequest : QApiRequest {

    public init(url: URL) {
        super.init(method: "GET")
        self.url = url
    }

}
