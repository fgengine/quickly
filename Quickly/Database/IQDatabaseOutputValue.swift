//
//  Quickly
//

import Foundation
import CoreGraphics

// MARK: IQDatabaseOutputValue

public protocol IQDatabaseOutputValue {
    
    static func value(statement: QDatabase.Statement, at index: Int) throws -> Self
    
}

// MARK: Bool : IQDatabaseOutputValue

extension Bool : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Bool {
        return statement.value(at: index)
    }
    
}

// MARK: Int8 : IQDatabaseOutputValue

extension Int8 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Int8 {
        return Int8(statement.value(at: index) as Int64)
    }
    
}

// MARK: UInt8 : IQDatabaseOutputValue

extension UInt8 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> UInt8 {
        return UInt8(statement.value(at: index) as Int64)
    }
    
}

// MARK: Int16 : IQDatabaseOutputValue

extension Int16 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Int16 {
        return Int16(statement.value(at: index) as Int64)
    }
    
}

// MARK: UInt16 : IQDatabaseOutputValue

extension UInt16 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> UInt16 {
        return UInt16(statement.value(at: index) as Int64)
    }
    
}

// MARK: Int32 : IQDatabaseOutputValue

extension Int32 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Int32 {
        return Int32(statement.value(at: index) as Int64)
    }
    
}

// MARK: UInt32 : IQDatabaseOutputValue

extension UInt32 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> UInt32 {
        return UInt32(statement.value(at: index) as Int64)
    }
    
}

// MARK: Int64 : IQDatabaseOutputValue

extension Int64 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Int64 {
        return statement.value(at: index)
    }
    
}

// MARK: UInt64 : IQDatabaseOutputValue

extension UInt64 : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> UInt64 {
        return UInt64(statement.value(at: index) as Int64)
    }
    
}

// MARK: Int : IQDatabaseOutputValue

extension Int : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Int {
        return Int(statement.value(at: index) as Int64)
    }
    
}

// MARK: UInt : IQDatabaseOutputValue

extension UInt : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> UInt {
        return UInt(statement.value(at: index) as Int64)
    }
    
}

// MARK: Float : IQDatabaseOutputValue

extension Float : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Float {
        return Float(statement.value(at: index) as Double)
    }
    
}

// MARK: Double : IQDatabaseOutputValue

extension Double : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Double {
        return statement.value(at: index)
    }
    
}

// MARK: CGFloat : IQDatabaseOutputValue

extension CGFloat : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> CGFloat {
        return CGFloat(statement.value(at: index) as Double)
    }
    
}

// MARK: Decimal : IQDatabaseOutputValue

extension Decimal : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Decimal {
        return statement.value(at: index)
    }
    
}

// MARK: String : IQDatabaseOutputValue

extension String : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> String {
        return statement.value(at: index)
    }
    
}

// MARK: URL : IQDatabaseOutputValue

extension URL : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> URL {
        let string = statement.value(at: index) as String
        guard let url = URL(string: string) else {
            throw QDatabase.Statement.Error.cast(index: index)
        }
        return url
    }
    
}

// MARK: Date : IQDatabaseOutputValue

extension Date : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Date {
        return Date(timeIntervalSince1970: TimeInterval(statement.value(at: index) as Double))
    }
    
}

// MARK: Data : IQDatabaseOutputValue

extension Data : IQDatabaseOutputValue {
    
    public static func value(statement: QDatabase.Statement, at index: Int) throws -> Data {
        return statement.value(at: index)
    }
    
}
