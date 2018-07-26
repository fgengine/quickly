//
//  Quickly
//

public protocol IQContainerSpec {
    
    var containerSize: CGSize { get }
    var containerLeftEdgeInset: CGFloat { get }
    var containerRightEdgeInset: CGFloat { get }
    
    var containerAvailableSize: CGSize { get }

}

public extension IQContainerSpec {
    
    var containerAvailableSize: CGSize {
        get {
            return CGSize(
                width: self.containerSize.width - (self.containerLeftEdgeInset + self.containerRightEdgeInset),
                height: self.containerSize.height - (self.containerLeftEdgeInset + self.containerRightEdgeInset)
            )
        }
    }
    
}
