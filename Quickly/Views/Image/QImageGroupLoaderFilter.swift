//
//  Quickly
//

public class QImageGroupLoaderFilter : IQImageLoaderFilter {

    public var filters: [IQImageLoaderFilter]
    public var name: String {
        get { return self.filters.compactMap({ $0.name }).joined(separator: "|") }
    }
    
    public init(_ filters: [IQImageLoaderFilter]) {
        self.filters = filters
    }
    
    public func apply(_ image: UIImage) -> UIImage? {
        return self.filters.reduce(image, {
            return $1.apply($0) ?? $0
        })
    }
    
}
