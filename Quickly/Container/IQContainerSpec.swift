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
            let containerSize = self.containerSize
            let containerLeftInset = self.containerLeftInset
            let containerRightInset = self.containerRightInset
            return CGSize(
                width: containerSize.width - (containerLeftInset + containerRightInset),
                height: containerSize.height - (containerLeftInset + containerRightInset)
            )
        }
    }
    
}
