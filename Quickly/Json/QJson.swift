//
//  Quickly
//

import Quickly.Private

public let QJsonErrorDomain: String = QJsonImplErrorDomain

public enum QJsonErrorCode : Int {
    case notFound
    case convert
}

public final class QJson {

    public var root: Any? {
        get { return self.impl.root }
    }
    internal var impl: QJsonImpl

    public init() {
        self.impl = QJsonImpl()
    }

    public init(root: Any) {
        self.impl = QJsonImpl(root: root)
    }

    public init?(data: Data) {
        if let impl: QJsonImpl = QJsonImpl(data: data) {
            self.impl = impl
        } else {
            return nil
        }
    }

    public init?(string: String) {
        if let impl: QJsonImpl = QJsonImpl(string: string) {
            self.impl = impl
        } else {
            return nil
        }
    }

    public init?(string: String, encoding: UInt) {
        if let impl: QJsonImpl = QJsonImpl(string: string, encoding: encoding) {
            self.impl = impl
        } else {
            return nil
        }
    }

    public func saveAsData() -> Data? {
        return self.impl.saveAsData()
    }

    public func saveAsString() -> String? {
        return self.impl.saveAsString()
    }

    public func saveAsString(encoding: UInt) -> String? {
        return self.impl.saveAsString(encoding: encoding)
    }

    public func isDictionary() -> Bool {
        return self.impl.isDictionary()
    }

    public func set(_ value: [AnyHashable : Any]) {
        self.impl.set(value: value)
    }

    public func dictionary() -> [AnyHashable : Any]? {
        return self.impl.dictionary()
    }

    public func isRootArray() -> Bool {
        return self.impl.isArray()
    }

    public func set(_ value: [Any]) {
        self.impl.set(value: value)
    }

    public func array() -> [Any]? {
        return self.impl.array()
    }

    public func clean() {
        self.impl.clean()
    }

    @discardableResult
    public func set(_ value: Any?, forPath path: String) -> Bool {
        return self.impl.set(object: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: [AnyHashable : Any], forPath path: String) -> Bool {
        return self.impl.set(dictionary: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: [Any], forPath path: String) -> Bool {
        return self.impl.set(array: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: Bool, forPath path: String) -> Bool {
        return self.impl.set(boolean: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: Int, forPath path: String) -> Bool {
        return self.impl.set(number: NSNumber(value: value), forPath: path)
    }

    @discardableResult
    public func set(_ value: UInt, forPath path: String) -> Bool {
        return self.impl.set(number: NSNumber(value: value), forPath: path)
    }

    @discardableResult
    public func set(_ value: Float, forPath path: String) -> Bool {
        return self.impl.set(number: NSNumber(value: value), forPath: path)
    }

    @discardableResult
    public func set(_ value: Double, forPath path: String) -> Bool {
        return self.impl.set(number: NSNumber(value: value), forPath: path)
    }

    @discardableResult
    public func set(_ value: NSNumber, forPath path: String) -> Bool {
        return self.impl.set(number: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: NSDecimalNumber, forPath path: String) -> Bool {
        return self.impl.set(decimalNumber: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: String, forPath path: String) -> Bool {
        return self.impl.set(string: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: URL, forPath path: String) -> Bool {
        return self.impl.set(url: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: Date, forPath path: String) -> Bool {
        return self.impl.set(date: value, forPath: path)
    }

    @discardableResult
    public func set(_ value: Date, format: String, forPath path: String) -> Bool {
        return self.impl.set(date: value, format: format, forPath: path)
    }

    @discardableResult
    public func set(_ value: UIColor?, forPath path: String) -> Bool {
        return self.impl.set(color: value, forPath: path)
    }

    public func object(at: String) throws -> Any? {
        return try self.impl.object(at: at)
    }

    public func dictionary(at: String) throws -> [AnyHashable : Any]? {
        return try self.impl.dictionary(at: at)
    }

    public func array(at: String) throws -> [Any]? {
        return try self.impl.array(at: at)
    }

    public func boolean(at: String) throws -> Bool {
        return try self.impl.number(at: at).boolValue
    }

    public func int(at: String) throws -> Int {
        return try self.impl.number(at: at).intValue
    }

    public func uint(at: String) throws -> UInt {
        return try self.impl.number(at: at).uintValue
    }

    public func float(at: String) throws -> Float {
        return try self.impl.number(at: at).floatValue
    }

    public func double(at: String) throws -> Double {
        return try self.impl.number(at: at).doubleValue
    }

    public func number(at: String) throws -> NSNumber {
        return try self.impl.number(at: at)
    }

    public func decimalNumber(at: String) throws -> NSDecimalNumber {
        return try self.impl.decimalNumber(at: at)
    }

    public func string(at: String) throws -> String {
        return try self.impl.string(at: at)
    }

    public func url(at: String) throws -> URL {
        return try self.impl.url(at: at)
    }

    public func date(at: String) throws -> Date {
        return try self.impl.date(at: at)
    }

    public func date(at: String, formats: [String]) throws -> Date {
        return try self.impl.date(at: at, formats: formats)
    }

    public func color(at: String) throws -> UIColor {
        return try self.impl.color(at: at)
    }

}
