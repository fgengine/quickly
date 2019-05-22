//
//  Quickly
//

public protocol IQImageLoaderTarget : class {
    
    func imageLoader(progress: Progress)
    func imageLoader(image: UIImage)
    func imageLoader(error: Error)
    
}
