//
//  Quickly
//

// MARK: - IQDatabaseOutputValue

public protocol IQDatabaseOutputValue {
    
    static func value(statement: QDatabase.Statement, at index: Int) -> Self
    
}

// MARK: - Bool : IQDatabaseOutputValue -

extension Bool : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Bool {
        return statement.value(at: index)
    }
    
}

// MARK: - Int8 : IQDatabaseOutputValue -

extension Int8 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Int8 {
        return Int8(Int64(statement.value(at: index)))
    }
    
}

// MARK: - UInt8 : IQDatabaseOutputValue -

extension UInt8 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> UInt8 {
        return UInt8(Int64(statement.value(at: index)))
    }
    
}

// MARK: - Int16 : IQDatabaseOutputValue -

extension Int16 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Int16 {
        return Int16(Int64(statement.value(at: index)))
    }
    
}

// MARK: - UInt16 : IQDatabaseOutputValue -

extension UInt16 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> UInt16 {
        return UInt16(Int64(statement.value(at: index)))
    }
    
}

// MARK: - Int32 : IQDatabaseOutputValue -

extension Int32 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Int32 {
        return Int32(Int64(statement.value(at: index)))
    }
    
}

// MARK: - UInt32 : IQDatabaseOutputValue -

extension UInt32 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> UInt32 {
        return UInt32(Int64(statement.value(at: index)))
    }
    
}

// MARK: - Int64 : IQDatabaseOutputValue -

extension Int64 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Int64 {
        return statement.value(at: index)
    }
    
}

// MARK: - UInt64 : IQDatabaseOutputValue -

extension UInt64 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> UInt64 {
        return UInt64(Int64(statement.value(at: index)))
    }
    
}

// MARK: - Int : IQDatabaseOutputValue -

extension Int : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Int {
        return Int(Int64(statement.value(at: index)))
    }
    
}

// MARK: - UInt : IQDatabaseOutputValue -

extension UInt : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> UInt {
        return UInt(Int64(statement.value(at: index)))
    }
    
}

// MARK: - Float : IQDatabaseOutputValue -

extension Float : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Float {
        return Float(Double(statement.value(at: index)))
    }
    
}

// MARK: - Double : IQDatabaseOutputValue -

extension Double : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Double {
        return statement.value(at: index)
    }
    
}

// MARK: - String : IQDatabaseOutputValue -

extension String : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> String {
        return statement.value(at: index)
    }
    
}

// MARK: - Date : IQDatabaseOutputValue -

extension Date : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Date {
        let timestamp: Int64 = statement.value(at: index)
        return Date.init(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
}

// MARK: - Data : IQDatabaseOutputValue -

extension Data : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) -> Data {
        return statement.value(at: index)
    }
    
}
