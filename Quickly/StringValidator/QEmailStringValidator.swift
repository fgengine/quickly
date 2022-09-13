//
//  Quickly
//

import Foundation

open class QEmailStringValidator : IQStringValidator {
    
    public let error: String
    
    public init(
        error: String
    ) {
        self.error = error
    }
    
    public func validate(_ string: String) -> QStringValidatorResult {
        var errors = Set< String >()
        let parts = string.split(separator: "@")
        if parts.count != 2 {
            errors.insert(self.error)
        } else {
            let name = parts[0]
            if name.count < 1 {
                errors.insert(self.error)
            } else {
                let host = parts[1]
                let hostParts = host.split(separator: ".")
                if hostParts.count != 2 {
                    errors.insert(self.error)
                } else {
                    let hostName = hostParts[0]
                    let hostZone = hostParts[1]
                    if (hostName.count == 0) && (hostZone.count == 0) {
                        errors.insert(self.error)
                    }
                }
            }
        }
        return QStringValidatorResult(
            errors: Array(errors)
        )
    }
    
}
