//
//  Quickly
//

import UIKit

open class QImageResponse : QApiResponse {

    open var data: Data?
    open var image: UIImage?

    open override func parse(data: Data) throws {
        self.data = data
        do {
            self.image = try self.image(data: data)
        } catch let error {
            self.parse(error: error)
        }
    }

    open func image(data: Data) throws -> UIImage? {
        guard let image = UIImage(data: data) else {
            throw QApiError.invalidResponse
        }
        return image
    }

}
