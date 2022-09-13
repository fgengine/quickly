//
//  Quickly
//

import UIKit

public protocol IQImageLoaderFilter : AnyObject {
    
    var name: String { get }
    
    func apply(_ image: UIImage) -> UIImage?
    
}
