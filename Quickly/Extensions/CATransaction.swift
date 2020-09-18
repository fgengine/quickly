//
//  Quickly
//

public extension CATransaction {
    
    class func withoutActions(_ closure: () -> Void) {
        Self.begin()
        Self.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        closure()
        Self.commit()
    }
    
}
