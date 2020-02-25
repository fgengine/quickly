//
//  Quickly
//

public protocol IQPhotoItem : class {
    
    var isNeedLoad: Bool { get }
    var isLoading: Bool { get }
    var size: CGSize { get }
    var image: UIImage? { get }
    
    func add(observer: IQPhotoItemObserver)
    func remove(observer: IQPhotoItemObserver)

    func load()
    
    func draw(context: CGContext, bounds: CGRect, scale: CGFloat)
    
}

public protocol IQPhotoItemObserver : class {
    
    func willLoadPhotoItem(_ photoItem: IQPhotoItem)
    func didLoadPhotoItem(_ photoItem: IQPhotoItem)
    
}
