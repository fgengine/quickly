//
//  Quickly
//

public protocol IQImageLoaderFilter : class {
    
    var name: String { get }
    
    func apply(_ image: UIImage) -> UIImage?
    
}
