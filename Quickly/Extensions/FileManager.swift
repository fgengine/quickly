//
//  Quickly
//

public extension FileManager {
    
    func documentDirectory() throws -> URL {
        return try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    func documentDirectory() throws -> String {
        return try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
    }
    
}
