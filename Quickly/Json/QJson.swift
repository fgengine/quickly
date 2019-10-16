//
//  Quickly
//

// MARK: QJsonError

public enum QJsonError : Error {
    case notJson
    case access
    case cast
}

// MARK: IQJsonValue

public protocol IQJsonValue {

    associatedtype Value: Any

    static func fromJson(value: Any) throws -> Value
    func toJsonValue() throws -> Any

}

// MARK: IQJsonEnum

public protocol IQJsonEnum : RawRepresentable {
    
    associatedtype RealValue
    
    var realValue: Self.RealValue { get }
    
    init(realValue: Self.RealValue)
    
}

// MARK: IQJsonModel

public protocol IQJsonModel {
    
    static func from(json: QJson) throws -> IQJsonModel
    
    init(json: QJson) throws
    
    func toJson() throws -> QJson?
    func toJson(json: QJson) throws
    
}

// MARK: QJson

public final class QJson {

    public private(set) var root: Any?

    public init() {
    }

    public init(root: Any) {
        self.root = root
    }

    public init(data: Data) throws {
        self.root = try JSONSerialization.jsonObject(with: data, options: [])
    }

    public convenience init(string: String, encoding: String.Encoding = String.Encoding.utf8) throws {
        guard let data = string.data(using: String.Encoding.utf8) else {
            throw QJsonError.notJson
        }
        try self.init(data: data)
    }
    
}

// MARK: QJson • Core

public extension QJson {
    
    func isDictionary() -> Bool {
        return self.root is NSDictionary
    }
    
    func dictionary() throws -> NSDictionary {
        guard let dictionary = self.root as? NSDictionary else { throw QJsonError.notJson }
        return dictionary
    }
    
    func isArray() -> Bool {
        return self.root is NSArray
    }
    
    func array() throws -> NSArray {
        guard let array = self.root as? NSArray else { throw QJsonError.notJson }
        return array
    }
    
    func clean() {
        self.root = nil
    }
    
}

// MARK: QJson • Save

public extension QJson {

    func saveAsData() throws -> Data {
        guard let root = self.root else {
            throw QJsonError.notJson
        }
        return try JSONSerialization.data(withJSONObject: root, options: [])
    }

    func saveAsString(encoding: String.Encoding = String.Encoding.utf8) throws -> String? {
        return String(data: try self.saveAsData(), encoding: encoding)
    }
    
}

// MARK: QJson • Set

public extension QJson {
    
    func setAny(_ value: Any, path: String? = nil) throws {
        if let path = path {
            try self._set(value, subpaths: self._subpaths(path))
        } else {
            self.root = value
        }
    }

    func set< Type: IQJsonValue >(_ value: Type, path: String? = nil) throws {
        let jsonValue = try value.toJsonValue()
        try self.setAny(jsonValue, path: path)
    }

    func set< Type: IQJsonValue >(_ value: [Type], mandatory: Bool, path: String? = nil) throws {
        var index: Int = 0
        let jsonArray = NSMutableArray()
        for item in value {
            if mandatory == true {
                let jsonItem = try item.toJsonValue()
                jsonArray.add(jsonItem)
            } else {
                if let jsonItem = try? item.toJsonValue() {
                    jsonArray.add(jsonItem)
                }
            }
            index += 1
        }
        try self.setAny(jsonArray, path: path)
    }

    func set< Key: IQJsonValue, Value: IQJsonValue >(_ value: [Key: Value], mandatory: Bool, path: String? = nil) throws {
        var index: Int = 0
        let jsonDictionary = NSMutableDictionary()
        for item in value {
            guard let jsonKey = try item.key.toJsonValue() as? NSCopying else { throw QJsonError.cast }
            if mandatory == true {
                let jsonValue = try item.value.toJsonValue()
                jsonDictionary.setObject(jsonValue, forKey: jsonKey)
            } else {
                if let jsonValue = try? item.value.toJsonValue() {
                    jsonDictionary.setObject(jsonValue, forKey: jsonKey)
                }
            }
            index += 1
        }
        try self.setAny(jsonDictionary, path: path)
    }
    
    func set(_ value: Date, format: String, path: String? = nil) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        try self.set(value, formatter: formatter, path: path)
    }
    
    func set(_ value: Date, formatter: DateFormatter, path: String? = nil) throws {
        try self.set(formatter.string(from: value), path: path)
    }
    
}

// MARK: QJson • Remove

public extension QJson {

    func remove(path: String) throws {
        try self._set(nil, subpaths: self._subpaths(path))
    }
    
}

// MARK: QJson • Get

public extension QJson {
    
    func getAny(path: String? = nil) throws -> Any {
        guard var root = self.root else { throw QJsonError.notJson }
        guard let path = path else { return root }
        var subpathIndex: Int = 0
        let subpaths = self._subpaths(path)
        while subpaths.endIndex != subpathIndex {
            let subpath = subpaths[subpathIndex]
            if let dictionary = root as? NSDictionary {
                guard let key = subpath.jsonPathKey else {
                    throw QJsonError.access
                }
                guard let temp = dictionary.object(forKey: key) else {
                    throw QJsonError.access
                }
                root = temp
            } else if let array = root as? NSArray {
                guard let index = subpath.jsonPathIndex, index < array.count else { throw QJsonError.access }
                root = array.object(at: index)
            } else {
                throw QJsonError.access
            }
            subpathIndex += 1
        }
        return root
    }

    func get< Type: IQJsonValue >(path: String? = nil) throws -> Type {
        let jsonValue: Any = try self.getAny(path: path)
        return try Type.fromJson(value: jsonValue) as! Type
    }
    
    func get< Type: RawRepresentable, TypeRawValue: IQJsonValue >(path: String? = nil) throws -> Type where Type.RawValue == TypeRawValue {
        let jsonValue: Any = try self.getAny(path: path)
        let rawValue = try TypeRawValue.fromJson(value: jsonValue) as! TypeRawValue
        guard let result = Type(rawValue: rawValue) else { throw QJsonError.cast }
        return result
    }

    func get< Type: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Type] {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonArray = jsonValue as? NSArray else { throw QJsonError.cast }
        var result: [Type] = []
        var index: Int = 0
        for jsonItem in jsonArray {
            if mandatory == true {
                let item = try Type.fromJson(value: jsonItem) as! Type
                result.append(item)
            } else {
                guard let item = try? Type.fromJson(value: jsonItem) as? Type else { continue }
                result.append(item)
            }
            index += 1
        }
        return result
    }
    
    func get< Type: RawRepresentable, TypeRawValue: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Type] where Type.RawValue == TypeRawValue {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonArray = jsonValue as? NSArray else { throw QJsonError.cast }
        var result: [Type] = []
        var index: Int = 0
        for jsonItem in jsonArray {
            if mandatory == true {
                let rawItem = try TypeRawValue.fromJson(value: jsonItem) as! TypeRawValue
                guard let item = Type(rawValue: rawItem) else { throw QJsonError.cast }
                result.append(item)
            } else {
                guard let rawItem = try? TypeRawValue.fromJson(value: jsonItem) as? TypeRawValue, let item = Type(rawValue: rawItem) else { continue }
                result.append(item)
            }
            index += 1
        }
        return result
    }

    func get< Key: IQJsonValue, Value: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value] {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonDictionary = jsonValue as? NSDictionary else { throw QJsonError.cast }
        var result: [Key : Value] = [:]
        for jsonItem in jsonDictionary {
            let key = try Key.fromJson(value: jsonItem.key) as! Key
            if mandatory == true {
                let value = try Value.fromJson(value: jsonItem.value) as! Value
                result[key] = value
            } else {
                guard let value = try? Value.fromJson(value: jsonItem.value) as? Value else { continue }
                result[key] = value
            }
        }
        return result
    }
    
    func get< Key: RawRepresentable, KeyRawValue: IQJsonValue, Value: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value] where Key.RawValue == KeyRawValue {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonDictionary = jsonValue as? NSDictionary else { throw QJsonError.cast }
        var result: [Key : Value] = [:]
        for jsonItem in jsonDictionary {
            let keyRaw = try KeyRawValue.fromJson(value: jsonItem.key) as! KeyRawValue
            if mandatory == true {
                guard let key = Key(rawValue: keyRaw) else { throw QJsonError.cast }
                let value = try Value.fromJson(value: jsonItem.value) as! Value
                result[key] = value
            } else if let key = Key(rawValue: keyRaw) {
                guard let value = try? Value.fromJson(value: jsonItem.value) as? Value else { continue }
                result[key] = value
            }
        }
        return result
    }
    
    func get< Key: IQJsonValue, Value: RawRepresentable, ValueRawValue: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value] where Value.RawValue == ValueRawValue {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonDictionary = jsonValue as? NSDictionary else { throw QJsonError.cast }
        var result: [Key : Value] = [:]
        for jsonItem in jsonDictionary {
            let key = try Key.fromJson(value: jsonItem.key) as! Key
            if mandatory == true {
                let valueRaw = try ValueRawValue.fromJson(value: jsonItem.value) as! ValueRawValue
                guard let value = Value(rawValue: valueRaw) else { throw QJsonError.cast }
                result[key] = value
            } else {
                guard let valueRaw = try? ValueRawValue.fromJson(value: jsonItem.value) as? ValueRawValue, let value = Value(rawValue: valueRaw) else { continue }
                result[key] = value
            }
        }
        return result
    }
    
    func get< Key: RawRepresentable, KeyRawValue: IQJsonValue, Value: RawRepresentable, ValueRawValue: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value] where Key.RawValue == KeyRawValue, Value.RawValue == ValueRawValue {
        let jsonValue: Any = try self.getAny(path: path)
        guard let jsonDictionary = jsonValue as? NSDictionary else { throw QJsonError.cast }
        var result: [Key : Value] = [:]
        for jsonItem in jsonDictionary {
            let keyRaw = try KeyRawValue.fromJson(value: jsonItem.key) as! KeyRawValue
            if mandatory == true {
                guard let key = Key(rawValue: keyRaw) else { throw QJsonError.cast }
                let valueRaw = try ValueRawValue.fromJson(value: jsonItem.value) as! ValueRawValue
                guard let value = Value(rawValue: valueRaw) else { throw QJsonError.cast }
                result[key] = value
            } else if let key = Key(rawValue: keyRaw) {
                guard let valueRaw = try? ValueRawValue.fromJson(value: jsonItem.value) as? ValueRawValue, let value = Value(rawValue: valueRaw) else { continue }
                result[key] = value
            }
        }
        return result
    }
    
    func get(format: String, path: String? = nil) throws -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return try self.get(formatter: formatter, path: path)
    }
    
    func get(formatter: DateFormatter, path: String? = nil) throws -> Date {
        let string: String = try self.get(path: path)
        guard let date = formatter.date(from: string) else { throw QJsonError.cast }
        return date
    }
    
}

// MARK: QJson • Private

private extension QJson {

    func _set(_ value: Any?, subpaths: [IQJsonPath]) throws {
        if self.root == nil {
            if let subpath = subpaths.first {
                if subpath.jsonPathKey != nil {
                    self.root = NSMutableDictionary()
                } else if subpath.jsonPathIndex != nil {
                    self.root = NSMutableArray()
                } else {
                    throw QJsonError.access
                }
            } else {
                throw QJsonError.access
            }
        }
        var root: Any = self.root!
        var prevRoot: Any?
        var subpathIndex: Int = 0
        while subpaths.endIndex != subpathIndex {
            let subpath = subpaths[subpathIndex]
            if let key = subpath.jsonPathKey {
                var mutable: NSMutableDictionary
                if root is NSMutableDictionary {
                    mutable = root as! NSMutableDictionary
                } else if root is NSDictionary {
                    mutable = NSMutableDictionary(dictionary: root as! NSDictionary)
                    if let prevRoot = prevRoot {
                        let prevSubpath = subpaths[subpathIndex - 1]
                        if let prevDictionary = prevRoot as? NSMutableDictionary {
                            prevDictionary.setValue(mutable, forKey: prevSubpath.jsonPathKey!)
                        } else if let prevArray = prevRoot as? NSMutableArray {
                            prevArray.insert(mutable, at: prevSubpath.jsonPathIndex!)
                        }
                    }
                    root = mutable
                } else {
                    throw QJsonError.access
                }
                if subpathIndex == subpaths.endIndex - 1 {
                    if let value = value {
                        mutable.setValue(value, forKey: key)
                    } else {
                        mutable.removeObject(forKey: key)
                    }
                }
            } else if let index = subpath.jsonPathIndex {
                var mutable: NSMutableArray
                if root is NSMutableArray {
                    mutable = root as! NSMutableArray
                } else if root is NSArray {
                    mutable = NSMutableArray(array: root as! NSArray)
                    if let prevRoot = prevRoot {
                        let prevSubpath = subpaths[subpathIndex - 1]
                        if let prevDictionary = prevRoot as? NSMutableDictionary {
                            prevDictionary.setValue(mutable, forKey: prevSubpath.jsonPathKey!)
                        } else if let prevArray = prevRoot as? NSMutableArray {
                            prevArray.insert(mutable, at: prevSubpath.jsonPathIndex!)
                        }
                    }
                    root = mutable
                } else {
                    throw QJsonError.access
                }
                if subpathIndex == subpaths.endIndex - 1 {
                    if let value = value {
                        mutable.insert(value, at: index)
                    } else {
                        mutable.removeObject(at: index)
                    }
                }
            } else {
                throw QJsonError.access
            }
            subpathIndex += 1
            prevRoot = root
        }
    }
    
    func _subpaths(_ path: String) -> [IQJsonPath] {
        guard path.contains(Const.pathSeparator) == true else { return [ path ] }
        let components = path.components(separatedBy: Const.pathSeparator)
        return components.compactMap({ (subpath: String) -> IQJsonPath? in
            guard let match = Const.pathIndexPattern.firstMatch(in: subpath, options: [], range: NSRange(location: 0, length: subpath.count)) else { return subpath }
            if((match.range.location != NSNotFound) && (match.range.length > 0)) {
                let startIndex = subpath.index(subpath.startIndex, offsetBy: 1)
                let endIndex = subpath.index(subpath.endIndex, offsetBy: -1)
                let indexString = String(subpath[startIndex..<endIndex])
                return NSNumber.number(from: indexString)
            }
            return subpath
        })
    }

    struct Const {
        public static var pathSeparator = "."
        public static var pathIndexPattern = try! NSRegularExpression(pattern: "^\\[\\d+\\]$", options: [ .anchorsMatchLines ])
    }

}

// MARK: IQDebug

#if DEBUG

extension QJson : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if self.isArray() == true {
            let array = try! self.array()
            array.debugString(&buffer, headerIndent, indent, footerIndent)
        } else if self.isDictionary() == true {
            let dictionary = try! self.dictionary()
            dictionary.debugString(&buffer, headerIndent, indent, footerIndent)
        } else {
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            buffer.append("<QJson>")
        }
    }

}

#endif

// MARK: Bool • IQJsonValue

extension Bool : IQJsonValue {

    public static func fromJson(value: Any) throws -> Bool {
        guard let boolean = value as? Bool else {
            if let string = value as? String {
                switch string.lowercased() {
                case "true", "yes", "on": return true
                case "false", "no", "off": return false
                default: break
                }
            } else if let number = value as? NSNumber {
                return number.boolValue
            }
            throw QJsonError.cast
        }
        return boolean
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: String • IQJsonValue

extension String : IQJsonValue {

    public static func fromJson(value: Any) throws -> String {
        guard let string = value as? String else {
            if let number = value as? NSNumber {
                return number.stringValue
            } else if let decimalNumber = value as? NSDecimalNumber {
                return decimalNumber.stringValue
            } else {
                throw QJsonError.cast
            }
        }
        return string
    }

    public func toJsonValue() throws -> Any {
        return self
    }

}

// MARK: URL • IQJsonValue

extension URL : IQJsonValue {

    public static func fromJson(value: Any) throws -> URL {
        if let string = value as? String, let url = URL(string: string) {
            return url
        }
        throw QJsonError.cast
    }

    public func toJsonValue() throws -> Any {
        return self.absoluteString
    }

}

// MARK: NSNumber • IQJsonValue

extension NSNumber : IQJsonValue {

    @objc
    public class func fromJson(value: Any) throws -> NSNumber {
        if let number = value as? NSNumber {
            return number
        }
        if let string = value as? String, let number = NSNumber.number(from: string) {
            return number
        }
        throw QJsonError.cast
    }

    @objc
    public func toJsonValue() throws -> Any {
        return self
    }

}

extension NSDecimalNumber {

    @objc
    public override class func fromJson(value: Any) throws -> NSDecimalNumber {
        if let decimalNumber = value as? NSDecimalNumber {
            return decimalNumber
        }
        if let string = value as? String, let decimalNumber = NSDecimalNumber.decimalNumber(from: string) {
            return decimalNumber
        } else if let number = value as? NSNumber {
            return NSDecimalNumber(string: number.stringValue)
        }
        throw QJsonError.cast
    }

    @objc
    public override func toJsonValue() throws -> Any {
        return self.stringValue
    }

}

// MARK: Decimal • IQJsonValue

extension Decimal : IQJsonValue {

    public static func fromJson(value: Any) throws -> Decimal {
        return try NSDecimalNumber.fromJson(value: value) as Decimal
    }

    public func toJsonValue() throws -> Any {
        return try (self as NSDecimalNumber).toJsonValue()
    }

}

// MARK: Date • IQJsonValue

extension Date : IQJsonValue {

    public static func fromJson(value: Any) throws -> Date {
        let timestamp = try NSNumber.fromJson(value: value)
        return Date(timeIntervalSince1970: timestamp.doubleValue)
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: Int(self.timeIntervalSince1970))
    }

}

// MARK: Int • IQJsonValue

extension Int : IQJsonValue {

    public static func fromJson(value: Any) throws -> Int {
        return try NSNumber.fromJson(value: value).intValue
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: UInt • IQJsonValue

extension UInt : IQJsonValue {

    public static func fromJson(value: Any) throws -> UInt {
        return try NSNumber.fromJson(value: value).uintValue
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: Float • IQJsonValue

extension Float : IQJsonValue {

    public static func fromJson(value: Any) throws -> Float {
        return try NSNumber.fromJson(value: value).floatValue
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: Double • IQJsonValue

extension Double : IQJsonValue {

    public static func fromJson(value: Any) throws -> Double {
        return try NSNumber.fromJson(value: value).doubleValue
    }

    public func toJsonValue() throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: CGFloat • IQJsonValue

extension CGFloat : IQJsonValue {

    public static func fromJson(value: Any) throws -> CGFloat {
        return try CGFloat(self.NativeType.fromJson(value: value))
    }

    public func toJsonValue() throws -> Any {
        return try self.native.toJsonValue()
    }

}

// MARK: UIColor • IQJsonValue

extension UIColor : IQJsonValue {

    public static func fromJson(value: Any) throws -> UIColor {
        if let string = value as? String, let color = UIColor(hexString: string) {
            return color
        } else if let number = value as? NSNumber {
            return UIColor.init(hex: number.uint32Value)
        }
        throw QJsonError.cast
    }

    public func toJsonValue() throws -> Any {
        return self.hexString()
    }

}

// MARK: IQJsonPath

fileprivate protocol IQJsonPath {

    var jsonPathKey: String? { get }
    var jsonPathIndex: Int? { get }

}

// MARK: String : IQJsonPath -

extension String : IQJsonPath {

    var jsonPathKey: String? {
        get { return self }
    }
    var jsonPathIndex: Int? {
        get { return nil }
    }

}

// MARK: NSNumber : IQJsonPath -

extension NSNumber : IQJsonPath {

    var jsonPathKey: String? {
        get { return nil }
    }
    var jsonPathIndex: Int? {
        get { return self.intValue }
    }

}
