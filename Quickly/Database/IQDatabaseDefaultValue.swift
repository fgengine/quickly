//
//  Quickly
//

import Foundation

// MARK: IQDatabaseDefaultValue

public protocol IQDatabaseDefaultValue {
    
    func queryDefaultValue() -> String
    
}

// MARK: Public • QDatabase.DefaultValueEmptyData

public extension QDatabase {
    
    struct DefaultValueEmptyData : IQDatabaseDefaultValue {
        
        public func queryDefaultValue() -> String {
            return "EMPTY_BLOB()"
        }
        
    }
    
}

// MARK: Bool : IQDatabaseDefaultValue

extension Bool : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return (self == true) ? "1" : "0"
    }
    
}

// MARK: Int8 : IQDatabaseDefaultValue

extension Int8 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: UInt8 : IQDatabaseDefaultValue

extension UInt8 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Int16 : IQDatabaseDefaultValue

extension Int16 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: UInt16 : IQDatabaseDefaultValue

extension UInt16 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Int32 : IQDatabaseDefaultValue

extension Int32 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: UInt32 : IQDatabaseDefaultValue

extension UInt32 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Int64 : IQDatabaseDefaultValue

extension Int64 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: UInt64 : IQDatabaseDefaultValue

extension UInt64 : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Int : IQDatabaseDefaultValue

extension Int : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: UInt : IQDatabaseDefaultValue

extension UInt : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Float : IQDatabaseDefaultValue

extension Float : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: Double : IQDatabaseDefaultValue

extension Double : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

// MARK: String : IQDatabaseDefaultValue

extension String : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\"\(self)\""
    }
    
}

// MARK: URL : IQDatabaseDefaultValue

extension URL : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return self.absoluteString.queryDefaultValue()
    }
    
}

// MARK: Date : IQDatabaseDefaultValue

extension Date : IQDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\"\(Int64(self.timeIntervalSince1970))\""
    }
    
}
