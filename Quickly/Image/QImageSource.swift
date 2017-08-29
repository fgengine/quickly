//
//  Quickly
//

import UIKit

public class QImageSource {

    public var image: UIImage?
    public var url: URL?

    public init(_ image: UIImage) {
        self.image = image
    }

    public init(_ imageNamed: String) {
        self.image = UIImage(named: imageNamed)
    }

    public init(_ url: URL) {
        self.url = url
    }

}
