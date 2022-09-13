//
//  Quickly
//

import Foundation
import SQLite3

// MARK: QDatabase

public class QDatabase {
    
    public enum Error : Swift.Error {
        case sqlite(code: Int, message: String?)
        case sqliteQuery(code: Int)
        case columnNotFound(name: String)
        case nullValueOf(column: String)
        case cast(column: String)
    }
    
    public enum Location {
        case inMemory
        case temporary
        case uri(_ path: String)
    }
    
    public enum DataType {
        case integer
        case double
        case string
        case dateTime
        case data
    }
    
    public struct OrderBy {
        
        public enum Mode {
            case asc
            case desc
        }
        
        public let columns: [Column]
        public let mode: Mode
        
        public init(columns: [Column], mode: Mode) {
            self.columns = columns
            self.mode = mode
        }
        
    }
    
    public struct Pagination {
        
        public let limit: Int
        public let offset: Int?
        
        public init(limit: Int, offset: Int? = nil) {
            self.limit = limit
            self.offset = offset
        }
        
    }
    
    public enum TransactionMode {
        case deferred
        case immediate
        case exclusive
    }
    
    open class Table {
        
        public internal(set) var name: String
        public internal(set) var columns: [Column]
        
        public init(
            name: String,
            columns: [Column]
        ) {
            self.name = name
            self.columns = columns
        }
        
    }
    
    open class Column {
        
        public internal(set) var name: String
        public internal(set) var dataType: DataType
        public internal(set) var isPrimaryKey: Bool
        public internal(set) var isAutoincrement: Bool
        public internal(set) var isNonNull: Bool
        public internal(set) var isUnique: Bool
        public internal(set) var defaultValue: IQDatabaseDefaultValue?
        
        public init(
            name: String,
            dataType: DataType,
            isPrimaryKey: Bool = false,
            isAutoincrement: Bool = false,
            isNonNull: Bool = false,
            isUnique: Bool = false,
            defaultValue: IQDatabaseDefaultValue? = nil
        ) {
            self.name = name
            self.dataType = dataType
            self.isPrimaryKey = isPrimaryKey
            self.isAutoincrement = isAutoincrement
            self.isNonNull = isNonNull
            self.isUnique = isUnique
            self.defaultValue = defaultValue
        }
        
    }
    
    public final class Statement {
        
        public enum Error : Swift.Error {
            case cast(index: Int)
        }
        
        private static let DefaultDestructor = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        private let _database: OpaquePointer
        private let _statement: OpaquePointer
        public private(set) lazy var numberOfParameters: Int = {
            return Int(sqlite3_bind_parameter_count(self._statement))
        }()
        public private(set) lazy var numberOfColumns: Int = {
            return Int(sqlite3_column_count(self._statement))
        }()
        public private(set) lazy var columnNames: [String] = {
            var result: [String] = []
            for index in 0..<self.numberOfColumns {
                if let name = sqlite3_column_name(self._statement, Int32(index)) {
                    if let nsString = NSString(utf8String: name) {
                        result.append(nsString as String)
                    } else {
                        result.append("")
                    }
                } else {
                    result.append("")
                }
            }
            return result
        }()
        public private(set) lazy var numberOfRows: Int = {
            return Int(sqlite3_data_count(self._statement))
        }()
        
        internal init(database: OpaquePointer, statement: OpaquePointer) {
            self._database = database
            self._statement = statement
        }
        
        deinit {
            do {
                try self.reset()
                try self.finalize()
            } catch let error {
                fatalError("QDatabase: Error destruct statement: \(error)")
            }
        }
        
    }
    
    public private(set) var location: Location
    public private(set) var isReadonly: Bool
    public var deletingAfterClose: Bool
    public var lastInsertedRowId: Int64 {
        get { return sqlite3_last_insert_rowid(self._database) }
    }
    public var numberOfChangedRows: Int {
        get { return Int(sqlite3_changes(self._database)) }
    }
    public var isInTransaction: Bool {
        get { return sqlite3_get_autocommit(self._database) == 0 }
    }
    public var error: Error {
        get { return QDatabase._error(database: self._database) }
    }
    
    private let _database: OpaquePointer
    
    public init(location: Location, readonly: Bool = false, deletingAfterClose: Bool = false) throws {
        self.location = location
        self.isReadonly = readonly
        self.deletingAfterClose = deletingAfterClose
        self._database = try QDatabase._open(location, readonly)
    }
    
    public convenience init(filename: String, readonly: Bool = false, deletingAfterClose: Bool = false) throws {
        let path = try FileManager.default.documentDirectory() as String
        try self.init(location: .uri("\(path)/\(filename).sqlite"), readonly: readonly, deletingAfterClose: deletingAfterClose)
    }
    
    deinit {
        do {
            let result = sqlite3_close(self._database)
            if result != SQLITE_OK {
                throw QDatabase._error(database: self._database)
            }
        } catch let error {
            fatalError("QDatabase: Error closing database: \(error.localizedDescription)")
        }
        if self.deletingAfterClose == true {
            switch self.location {
            case .inMemory, .temporary: break
            case .uri(let path):
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch let error {
                    fatalError("QDatabase: Error deleting database: \(error.localizedDescription)")
                }
            }
        }
    }
        
}

// MARK: Public • QDatabase

public extension QDatabase {
    
    static func isExist(filename: String) throws -> Bool {
        let path = try FileManager.default.documentDirectory() as String
        return FileManager.default.fileExists(atPath: "\(path)/\(filename).sqlite")
    }
    
    static func drop(filename: String) throws {
        let path = try FileManager.default.documentDirectory() as String
        try FileManager.default.removeItem(atPath: path)
    }
    
}

// MARK: Public • QDatabase • UserVersion

public extension QDatabase {
    
    func set(userVersion: Int) throws {
        let query = "PRAGMA USER_VERSION = \(userVersion)"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func userVersion() throws -> Int {
        let query = "PRAGMA USER_VERSION"
        let statement = try self.statement(query: query)
        try statement.executeUntilRow()
        return Int(statement.value(at: 0))
    }
    
}

// MARK: Public • QDatabase • Table

public extension QDatabase {
    
    func create(table: Table, ifNotExists: Bool = false) throws {
        let columnsDeclarations: [String] = table.columns.compactMap({ return $0.queryString() })
        var query = "CREATE TABLE "
        if ifNotExists == true {
            query += "IF NOT EXISTS "
        }
        query += table.name + " (" + columnsDeclarations.joined(separator: ", ") + ")"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func drop(table: Table, ifExists: Bool = false) throws {
        var query = "DROP TABLE "
        if ifExists == true {
            query += "IF EXISTS "
        }
        query += table.name
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
    }
    
    func rename(table: Table, to: String) throws {
        let query = "ALTER TABLE " + table.name + " RENAME TO " + to
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.name = to
    }
    
    func isExist(table: Table) throws -> Bool {
        return try self.isExist(table: table.name)
    }
    
    func isExist(table: String) throws -> Bool {
        let query = "SELECT tbl_name FROM sqlite_master WHERE tbl_name == \"\(table)\""
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        return statement.numberOfRows > 0
    }

}

// MARK: Public • QDatabase • Transactions

public extension QDatabase {
    
    func transaction(mode: TransactionMode = .deferred, block: () throws -> Void) throws {
        let beginStatement = try self.statement(query: "BEGIN \(mode.queryString()) TRANSACTION")
        try beginStatement.executeUntilDone()
        do {
            try block()
            let commitStatement = try self.statement(query: "COMMIT TRANSACTION")
            try commitStatement.executeUntilDone()
        } catch let error {
            let commitStatement = try self.statement(query: "ROLLBACK TRANSACTION")
            try commitStatement.executeUntilDone()
            throw error
        }
    }

}

// MARK: Public • QDatabase • Column

public extension QDatabase {
    
    func add(column: Column, in table: Table) throws {
        let query = "ALTER TABLE \(table.name) ADD COLUMN " + column.queryString()
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.add(column: column)
    }
    
    func remove(column: Column, in table: Table) throws {
        let columnsNames: [String] = table.columns.compactMap({
            guard $0 != column else { return nil }
            return $0.name
        })
        let columnsDeclarations: [String] = table.columns.compactMap({
            guard $0 != column else { return nil }
            return $0.queryString()
        })
        var query = "BEGIN TRANSACTION;\n"
        query += "CREATE TEMPORARY TABLE " + table.name + "_temp (" + columnsDeclarations.joined(separator: ", ") + ");\n"
        query += "INSERT INTO " + table.name + "_temp SELECT " + columnsNames.joined(separator: ", ") + " FROM " + table.name + ";\n"
        query += "DROP TABLE " + table.name + ";\n"
        query += "CREATE TABLE " + table.name + " (" + columnsDeclarations.joined(separator: ", ") + ");\n"
        query += "INSERT INTO " + table.name + " SELECT " + columnsNames.joined(separator: ", ") + " FROM " + table.name + "_temp;\n"
        query += "DROP TABLE " + table.name + "_temp;\n"
        query += "COMMIT;"
        let statement = try self.statement(query: query)
        try statement.executeUntilDone()
        table.remove(column: column)
    }
    
}

// MARK: Public • QDatabase • Insert

public extension QDatabase {
    
    @discardableResult
    func insert(table: Table, data: [Column : IQDatabaseInputValue]) throws -> Int64 {
        let columns: [String] = data.compactMap({ return $0.key.name })
        let values: [String] = data.compactMap({ _ in return "?" })
        let query = "INSERT INTO " + table.name + " (" + columns.joined(separator: ", ") + ") VALUES (" + values.joined(separator: ", ") + ")"
        let statement = try self.statement(query: query)
        try statement.bind(data.values)
        try statement.executeUntilDone()
        return self.lastInsertedRowId
    }
    
}

// MARK: Public • QDatabase • Update

public extension QDatabase {
    
    @discardableResult
    func update(table: Table, data: [Column : IQDatabaseInputValue], where: IQDatabaseExpressable?, orderBy: OrderBy? = nil, pagination: Pagination? = nil) throws -> Int {
        let values: [String] = data.compactMap({ return $0.key.name + " = ?" })
        var bindables = data.values.compactMap({ return $0 })
        var query = "UPDATE " + table.name + " SET " + values.joined(separator: ", ")
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        try statement.executeUntilDone()
        return self.numberOfChangedRows
    }
    
}

// MARK: Public • QDatabase • Delete

public extension QDatabase {
    
    @discardableResult
    func delete(table: Table, where: IQDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil) throws -> Int {
        var bindables: [IQDatabaseInputValue] = []
        var query = "DELETE FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        try statement.executeUntilDone()
        return self.numberOfChangedRows
    }
    
}

// MARK: Public • QDatabase • Select

public extension QDatabase {
    
    func select< Type >(table: Table, columns: [Column]? = nil, where: IQDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil, processing: (QDatabase.Statement) throws -> Type) throws -> [Type] {
        var bindables: [IQDatabaseInputValue] = []
        var query = "SELECT "
        if let columns = columns {
            query += columns.compactMap({ return $0.name }).joined(separator: ", ")
        } else {
            query += "*"
        }
        query += " FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        return try statement.executeRows(processing)
    }
    
    func selectFirst< Type >(table: Table, columns: [Column]? = nil, where: IQDatabaseExpressable? = nil, orderBy: OrderBy? = nil, pagination: Pagination? = nil, processing: (QDatabase.Statement) throws -> Type) throws -> Type? {
        var bindables: [IQDatabaseInputValue] = []
        var query = "SELECT "
        if let columns = columns {
            query += columns.compactMap({ return $0.name }).joined(separator: ", ")
        } else {
            query += "*"
        }
        query += " FROM " + table.name
        if let whereExpr = `where` {
            bindables.append(contentsOf: whereExpr.inputValues())
            query += " WHERE " + whereExpr.queryExpression()
        }
        if let orderBy = orderBy {
            let orderByColumns: [String] = orderBy.columns.compactMap({ return $0.name })
            query += " ORDER BY " + orderByColumns.joined(separator: ", ") + " " + orderBy.mode.queryString()
        }
        if let pagination = pagination {
            query += " LIMIT \(pagination.limit)"
            if let offset = pagination.offset {
                query += " OFFSET \(offset)"
            }
        }
        let statement = try self.statement(query: query)
        try statement.bind(bindables)
        return try statement.executeFirstRow(processing)
    }
    
}

// MARK: Public • QDatabase.Column : Hashable

extension QDatabase.Column : Hashable {
    
    public var hashValue: Int {
        get { return self.name.hashValue }
    }
    
    public func hash(into hasher: inout Hasher) {
        self.name.hash(into: &hasher)
    }
    
    public static func == (lhs: QDatabase.Column, rhs: QDatabase.Column) -> Bool {
        return lhs.name == rhs.name
    }
    
}

// MARK: Public • QDatabase.Statement

public extension QDatabase.Statement {
    
    func value< Type: IQDatabaseOutputValue >(of column: QDatabase.Column) throws -> Type {
        guard let index = self.columnIndex(of: column.name) else {
            throw QDatabase.Error.columnNotFound(name: column.name)
        }
        if sqlite3_column_type(self._statement, Int32(index)) == SQLITE_NULL {
            throw QDatabase.Error.nullValueOf(column: column.name)
        }
        var result: Type
        do {
            result = try Type.value(statement: self, at: index)
        } catch Error.cast(let index) {
            throw QDatabase.Error.cast(column: self.columnName(at: index))
        } catch let error {
            throw error
        }
        return result
    }
    
    func value< Type: RawRepresentable, Value: IQDatabaseOutputValue >(of column: QDatabase.Column) throws -> Type where Type.RawValue == Value {
        guard let index = self.columnIndex(of: column.name) else {
            throw QDatabase.Error.columnNotFound(name: column.name)
        }
        if sqlite3_column_type(self._statement, Int32(index)) == SQLITE_NULL {
            throw QDatabase.Error.nullValueOf(column: column.name)
        }
        var rawValue: Value
        do {
            rawValue = try Value.value(statement: self, at: index)
        } catch Error.cast(let index) {
            throw QDatabase.Error.cast(column: self.columnName(at: index))
        } catch let error {
            throw error
        }
        guard let value = Type(rawValue: rawValue) else {
            throw QDatabase.Error.cast(column: column.name)
        }
        return value
    }
    
}

// MARK: Internal • QDatabase

internal extension QDatabase {
    
    func statement(query: String) throws -> Statement {
        return Statement(
            database: self._database,
            statement: try self._prepareStatement(query)
        )
    }
    
}

// MARK: Internal QDatabase.Location

internal extension QDatabase.Location {
    
    var sqlitePath: String {
        get {
            switch self {
            case .inMemory: return ":memory:"
            case .temporary: return ""
            case .uri(let path): return path
            }
        }
    }
    
}

// MARK: Internal QDatabase.DataType

internal extension QDatabase.DataType {
    
    var type: Int32 {
        get {
            switch self {
            case .integer: return SQLITE_INTEGER
            case .double: return SQLITE_FLOAT
            case .string: return SQLITE_TEXT
            case .dateTime: return SQLITE_FLOAT
            case .data: return SQLITE_BLOB
            }
        }
    }
    
    func queryString() -> String {
        switch self {
        case .integer: return "INTEGER"
        case .double, .dateTime: return "REAL"
        case .string: return "TEXT"
        case .data: return "BLOB"
        }
    }
    
}

// MARK: Internal QDatabase.OrderBy.Mode

internal extension QDatabase.OrderBy.Mode {
    
    func queryString() -> String {
        switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        }
    }
    
}

// MARK: Internal QDatabase.TransactionMode

internal extension QDatabase.TransactionMode {
    
    func queryString() -> String {
        switch self {
        case .deferred: return "DEFERRED"
        case .immediate: return "IMMEDIATE"
        case .exclusive: return "EXCLUSIVE"
        }
    }
    
}

// MARK: Internal • QDatabase.Table

internal extension QDatabase.Table {
    
    func add(column: QDatabase.Column) {
        guard self.columns.contains(where: { return $0.name == column.name }) == false else { return }
        self.columns.append(column)
    }
    
    func remove(column: QDatabase.Column) {
        guard let index = self.columns.firstIndex(where: { return $0.name == column.name }) else { return }
        self.columns.remove(at: index)
    }
    
}

// MARK: Internal • QDatabase.Column

internal extension QDatabase.Column {
    
    func queryString() -> String {
        var string: String = "\(self.name) \(self.dataType.queryString())"
        if self.isPrimaryKey == true { string += " PRIMARY KEY" }
        if self.isAutoincrement == true { string += " AUTOINCREMENT" }
        if self.isNonNull == true { string += " NOT NULL" }
        if self.isUnique == true { string += " UNIQUE" }
        if let defaultValue = self.defaultValue {
            string += " DEFAULT " + defaultValue.queryDefaultValue()
        }
        return string
        
    }
    
}

// MARK: Internal • QDatabase.Statement

internal extension QDatabase.Statement {
    
    // MARK: Reset
    
    func reset() throws {
        let result = sqlite3_reset(self._statement)
        if result != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func finalize() throws {
        let result = sqlite3_finalize(self._statement)
        if result != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    // MARK: Execute
    
    func executeUntilDone() throws {
        let step = sqlite3_step(self._statement)
        switch step {
        case SQLITE_DONE: return
        default: throw QDatabase._error(database: self._database)
        }
    }
    
    func executeUntilRow() throws {
        let step = sqlite3_step(self._statement)
        switch step {
        case SQLITE_ROW: return
        default: throw QDatabase._error(database: self._database)
        }
    }
    
    func executeFirstRow< Type >(_ block: (QDatabase.Statement) throws -> Type) throws -> Type? {
        while true {
            let step = sqlite3_step(self._statement)
            switch step {
            case SQLITE_ROW: return try block(self)
            case SQLITE_DONE: return nil
            default: throw QDatabase._error(database: self._database)
            }
        }
    }
    
    func executeRows< Type >(_ block: (QDatabase.Statement) throws -> Type) throws -> [Type] {
        var results: [Type] = []
        while true {
            let step = sqlite3_step(self._statement)
            switch step {
            case SQLITE_ROW: results.append(try block(self))
            case SQLITE_DONE: return results
            default: throw QDatabase._error(database: self._database)
            }
        }
        return results
    }
    
    // MARK: Bind
    
    func bindIndex(of name: String) -> Int? {
        guard let name = name.cString(using: String.Encoding.utf8) else { return nil }
        let index = sqlite3_bind_parameter_index(self._statement, name)
        return (index > 0) ? Int(index) : nil
    }
    
    // MARK: Bind • Bool
    
    func bind(at index: Int, value: Bool) throws {
        if sqlite3_bind_int(self._statement, Int32(index), Int32(value ? 1 : 0)) != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Bool) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    // MARK: Bind • Int
    
    func bind(at index: Int, value: Int64) throws {
        if sqlite3_bind_int64(self._statement, Int32(index), value) != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Int64) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    // MARK: Bind • Double
    
    func bind(at index: Int, value: Double) throws {
        if sqlite3_bind_double(self._statement, Int32(index), value) != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: Double) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    // MARK: Bind • Decimal
    
    func bind(at index: Int, value: Decimal) throws {
        try self.bind(at: index, value: NSDecimalNumber(decimal: value).int64Value)
    }
    
    func bind(of name: String, value: Decimal) throws {
        try self.bind(of: name, value: NSDecimalNumber(decimal: value).int64Value)
    }
    
    // MARK: Bind • String
    
    func bind(at index:Int, value: String) throws {
        let cString = value.cString(using: String.Encoding.utf8)
        if sqlite3_bind_text(self._statement, Int32(index), cString!, -1, QDatabase.Statement.DefaultDestructor) != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func bind(of name: String, value: String) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    // MARK: Bind • Data
    
    func bind(at index: Int, value: Data) throws {
        let nsData = value as NSData
        if nsData.length > 0 {
            if sqlite3_bind_blob(self._statement, Int32(index), nsData.bytes, Int32(nsData.length), QDatabase.Statement.DefaultDestructor) != SQLITE_OK {
                throw QDatabase._error(database: self._database)
            }
        } else {
            if sqlite3_bind_zeroblob(self._statement, Int32(index), 0) != SQLITE_OK {
                throw QDatabase._error(database: self._database)
            }
        }
    }
    
    func bind(of name: String, value: Data) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bind(at: index, value: value)
    }
    
    // MARK: Bind • Null
    
    func bindNull(at index: Int) throws {
        if sqlite3_bind_null(self._statement, Int32(index)) != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
    }
    
    func bindNull(of name: String) throws {
        guard let index = self.bindIndex(of: name) else {
            throw QDatabase.Error.columnNotFound(name: name)
        }
        try self.bindNull(at: index)
    }
    
    // MARK: Column
    
    func columnName(at index: Int) -> String {
        return self.columnNames[index]
    }
    
    func columnIndex(of name: String) -> Int? {
        return self.columnNames.firstIndex(of: name)
    }
    
    // MARK: Value • Bool
    
    func value(at index: Int) -> Bool {
        return sqlite3_column_int64(self._statement, Int32(index)) != 0
    }
    
    // MARK: Value • Int
    
    func value(at index: Int) -> Int64 {
        return sqlite3_column_int64(self._statement, Int32(index))
    }
    
    // MARK: Value • Double
    
    func value(at index: Int) -> Double {
        return sqlite3_column_double(self._statement, Int32(index))
    }
    
    // MARK: Value • Decimal
    
    func value(at index: Int) -> Decimal {
        let int64: Int64 = self.value(at: index)
        return Decimal(int64)
    }
    
    // MARK: Value • String
    
    func value(at index: Int) -> String {
        guard let text = sqlite3_column_text(self._statement, Int32(index)) else { return "" }
        let assumingText = UnsafeRawPointer(text).assumingMemoryBound(to: Int8.self)
        guard let string = NSString(utf8String: assumingText) else { return "" }
        return string as String
    }
    
    // MARK: Value • Data
    
    func value(at index: Int) -> Data {
        guard let bytes = sqlite3_column_blob(self._statement, Int32(index)) else { return Data() }
        let count = sqlite3_column_bytes(self._statement, Int32(index))
        return Data(bytes: bytes, count: Int(count))
    }
    
}

// MARK: Private

private extension QDatabase {
    
    static func _open(_ location: Location, _ isReadonly: Bool) throws -> OpaquePointer {
        var database: OpaquePointer? = nil
        let flags = (isReadonly == true) ? SQLITE_OPEN_READONLY : (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        let result = sqlite3_open_v2(location.sqlitePath.cString(using: String.Encoding.utf8)!, &database, flags | SQLITE_OPEN_FULLMUTEX, nil)
        if result != SQLITE_OK {
            throw QDatabase._error(database: database!)
        }
        return database!
    }
    
    static func _error(database: OpaquePointer) -> QDatabase.Error {
        var message: String?
        if let errorMessage = sqlite3_errmsg(database) {
            if let nsString = NSString(utf8String: errorMessage) {
                message = nsString as String
            }
        }
        return QDatabase.Error.sqlite(
            code: Int(sqlite3_errcode(database)),
            message: message
        )
    }
    
    func _prepareStatement(_ query: String) throws -> OpaquePointer {
        var statement: OpaquePointer? = nil
        let resultCode = sqlite3_prepare_v2(self._database, query.cString(using: String.Encoding.utf8)!, -1, &statement, nil)
        if resultCode != SQLITE_OK {
            throw QDatabase._error(database: self._database)
        }
        return statement!
    }
    
}
