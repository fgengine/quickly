//
//  Quickly
//

public extension Bundle {
    
    public var version: String? {
        get {
            return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    }
    
}
