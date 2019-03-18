//
//  Quickly
//

public extension Bundle {
    
    public var isTestFlight: Bool {
        get {
            return self.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        }
    }
    public var version: String? {
        get {
            return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    }
    
}
