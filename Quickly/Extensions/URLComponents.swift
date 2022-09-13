//
//  Quickly
//

import Foundation

public extension URLComponents {
    
    func queryItem(by name: String) -> URLQueryItem? {
        guard let queryItems = self.queryItems else { return nil }
        return queryItems.first(where: { return $0.name == name })
    }
    
}
