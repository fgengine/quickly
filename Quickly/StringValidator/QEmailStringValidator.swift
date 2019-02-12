//
//  Quickly
//

open class QEmailStringValidator : IQStringValidator {
    
    public init() {
    }
    
    public func validate(_ string: String, complete: Bool) -> Bool {
        let parts = string.split(separator: "@")
        if parts.count != 2 {
            return false
        }
        let name = parts[0]
        if name.count < 1 {
            return false
        }
        let host = parts[1]
        let hostParts = host.split(separator: ".")
        if hostParts.count != 2 {
            return false
        }
        let hostName = hostParts[0]
        let hostZone = hostParts[1]
        return (hostName.count > 1) && (hostZone.count > 1)
    }
    
}
