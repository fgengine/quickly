//
//  Quickly
//

// MARK: - IQDatabaseInputValue

public protocol IQDatabaseInputValue {
    
    func bindTo(statement: QDatabase.Statement, at index: Int) throws
    
}

// MARK: - Internal • QDatabase.Statement

internal extension QDatabase.Statement {
    
    // MARK: Bind
    
    func bind< Type : Sequence >(_ bindables: Type) throws where Type.Iterator.Element == IQDatabaseInputValue {
        var index = 1
        for bindable in bindables {
            try bindable.bindTo(statement: self, at: index)
            index += 1
        }
    }
    
}

// MARK: - Bool : IQDatabaseInputValue -

extension Bool : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

// MARK: - Int8 : IQDatabaseInputValue -

extension Int8 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - UInt8 : IQDatabaseInputValue -

extension UInt8 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - Int16 : IQDatabaseInputValue -

extension Int16 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - UInt16 : IQDatabaseInputValue -

extension UInt16 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - Int32 : IQDatabaseInputValue -

extension Int32 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - UInt32 : IQDatabaseInputValue -

extension UInt32 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - Int64 : IQDatabaseInputValue -

extension Int64 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

// MARK: - UInt64 : IQDatabaseInputValue -

extension UInt64 : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - Int : IQDatabaseInputValue -

extension Int : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - UInt : IQDatabaseInputValue -

extension UInt : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self))
    }
    
}

// MARK: - Float : IQDatabaseInputValue -

extension Float : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Double(self))
    }
    
}

// MARK: - Double : IQDatabaseInputValue -

extension Double : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

// MARK: - String : IQDatabaseInputValue -

extension String : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

// MARK: - Date : IQDatabaseInputValue -

extension Date : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: Int64(self.timeIntervalSince1970))
    }
    
}

// MARK: - Data : IQDatabaseInputValue -

extension Data : IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try statement.bind(at: index, value: self)
    }
    
}

// MARK: - Optional : IQDatabaseInputValue -

extension Optional : IQDatabaseInputValue where Wrapped == IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        switch self {
        case .none: try statement.bindNull(at: index)
        case .some(let wrapped): try wrapped.bindTo(statement: statement, at: index)
        }
    }
    
}

// MARK: - RawRepresentable : IQDatabaseInputValue -

extension RawRepresentable where RawValue == IQDatabaseInputValue {
    
    public func bindTo(statement: QDatabase.Statement, at index: Int) throws {
        try self.rawValue.bindTo(statement: statement, at: index)
    }
    
}
