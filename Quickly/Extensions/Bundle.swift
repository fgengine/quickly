//
//  Quickly
//

public extension Bundle {
    
    var isTestFlight: Bool {
        get {
            return self.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        }
    }
    var version: String? {
        get {
            return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    }
    
}
