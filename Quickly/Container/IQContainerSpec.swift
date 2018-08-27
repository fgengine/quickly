//
//  Quickly
//

public protocol IQContainerSpec : class {
    
    var containerSize: CGSize { get }
    var containerLeftInset: CGFloat { get }
    var containerRightInset: CGFloat { get }
    
    var containerAvailableSize: CGSize { get }

}

public extension IQContainerSpec {
    
    var containerAvailableSize: CGSize {
        get {
            return CGSize(
                width: self.containerSize.width - (self.containerLeftInset + self.containerRightInset),
                height: self.containerSize.height - (self.containerLeftInset + self.containerRightInset)
            )
        }
    }
    
}
