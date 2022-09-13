//
//  Quickly
//

import Foundation

public extension Array {
    
    func processing(
        prefix: (() throws -> Element?)? = nil,
        suffix: (() throws -> Element?)? = nil,
        separator: (() throws -> Element?)?
    ) rethrows -> [Element] {
        var result: [Element] = []
        if prefix != nil {
            if let item = try prefix?() {
                result.append(item)
            }
        }
        if separator != nil {
            if self.count > 1 {
                for item in self[0..<self.count - 1] {
                    result.append(item)
                    if let item = try separator?() {
                        result.append(item)
                    }
                }
                result.append(self[self.count - 1])
            } else if self.count > 0 {
                result.append(self[0])
            }
        } else {
            result.append(contentsOf: self)
        }
        if suffix != nil {
            if let item = try suffix?() {
                result.append(item)
            }
        }
        return result
    }
    
    func processing(
        prefix: (() throws -> [Element])? = nil,
        suffix: (() throws -> [Element])? = nil,
        separator: (() throws -> [Element])?
    ) rethrows -> [Element] {
        var result: [Element] = []
        if prefix != nil {
            if let items = try prefix?() {
                result.append(contentsOf: items)
            }
        }
        if separator != nil {
            if self.count > 1 {
                for item in self[0..<self.count - 1] {
                    result.append(item)
                    if let items = try separator?() {
                        result.append(contentsOf: items)
                    }
                }
                result.append(self[self.count - 1])
            } else if self.count > 0 {
                result.append(self[0])
            }
        } else {
            result.append(contentsOf: self)
        }
        if suffix != nil {
            if let items = try suffix?() {
                result.append(contentsOf: items)
            }
        }
        return result
    }
    
}
