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
    
    func containsUrlSheme(url: URL) -> Bool {
        var shemes: [String] = []
        guard let scheme = url.scheme else { return false }
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [Any] else { return false }
        urlTypes.forEach({
            guard let dictionary = $0 as? [String : Any], let urlSchemes = dictionary["CFBundleURLSchemes"] as? [String] else { return }
            shemes.append(contentsOf: urlSchemes)
        })
        return shemes.contains(scheme)
    }
    
}
