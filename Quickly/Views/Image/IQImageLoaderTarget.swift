//
//  Quickly
//

import UIKit

public protocol IQImageLoaderTarget : AnyObject {
    
    func imageLoader(progress: Progress)
    func imageLoader(image: UIImage)
    func imageLoader(error: Error)
    
}
