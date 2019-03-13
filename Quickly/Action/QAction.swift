//
//  Quickly
//

public protocol IQAction {
    
    func perform()
    
}

public struct QAction< Target: AnyObject > : IQAction {
    
    public weak var target: Target?
    public let action: (Target) -> () -> ()
    
    public func perform() -> () {
        if let target = self.target {
            self.action(target)()
        }
    }
    
}
