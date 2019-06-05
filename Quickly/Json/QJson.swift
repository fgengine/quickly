//
//  Quickly
//

// MARK: - QJsonError -

public enum QJsonError : Error {
    case notJson
    case access(path: String)
    case cast(path: String)
}

// MARK: - IQJsonValue -

public protocol IQJsonValue {

    associatedtype FromValue: Any
    associatedtype ToValue: Any

    static func fromJson(value: Any, path: String) throws -> FromValue
    func toJsonValue(path: String) throws -> ToValue

}

// MARK: - IQJsonEnum -

public protocol IQJsonEnum : RawRepresentable {
    
    associatedtype RealValue
    
    var realValue: Self.RealValue { get }
    
    init(realValue: Self.RealValue)
    
}

// MARK: - IQJsonModel -

public protocol IQJsonModel {
    
    static func from(json: QJson) throws -> IQJsonModel
    
    init(json: QJson) throws
    
    func toJson() throws -> QJson?
    func toJson(json: QJson) throws
    
}

// MARK: - QJson -

public final class QJson {

    public private(set) var root: Any?
    public private(set) var basePath: String

    public init(basePath: String = "") {
        self.basePath = basePath
    }

    public init(root: Any, basePath: String = "") {
        self.root = root
        self.basePath = basePath
    }

    public init(data: Data, basePath: String = "") throws {
        self.root = try JSONSerialization.jsonObject(with: data, options: [])
        self.basePath = basePath
    }

    public convenience init(string: String, encoding: String.Encoding = String.Encoding.utf8, basePath: String = "") throws {
        guard let data = string.data(using: String.Encoding.utf8) else {
            throw QJsonError.notJson
        }
        try self.init(data: data, basePath: basePath)
    }

    public func saveAsData() throws -> Data {
        guard let root = self.root else {
            throw QJsonError.notJson
        }
        return try JSONSerialization.data(withJSONObject: root, options: [])
    }

    public func saveAsString(encoding: String.Encoding = String.Encoding.utf8) throws -> String? {
        return String(data: try self.saveAsData(), encoding: encoding)
    }

    public func isDictionary() -> Bool {
        return self.root is NSDictionary
    }

    public func dictionary() throws -> NSDictionary {
        guard let dictionary = self.root as? NSDictionary else { throw QJsonError.notJson }
        return dictionary
    }

    public func isArray() -> Bool {
        return self.root is NSArray
    }

    public func array() throws -> NSArray {
        guard let array = self.root as? NSArray else { throw QJsonError.notJson }
        return array
    }

    public func clean() {
        self.root = nil
    }

    public func set(_ value: Any, path: String? = nil) throws {
        if let path = path {
            try self._set(value, subpaths: self._subpaths(path))
        } else {
            self.root = value
        }
    }

    public func set(_ value: Date, format: String, path: String? = nil) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        try self.set(value, formatter: formatter, path: path)
    }

    public func set(_ value: Date, formatter: DateFormatter, path: String? = nil) throws {
        try self.set(formatter.string(from: value), path: path)
    }

    public func set< Type: IQJsonValue >(_ value: Type, path: String? = nil) throws {
        let jsonValue = try value.toJsonValue(path: self._buildPath([ path ]))
        try self.set(jsonValue, path: path)
    }

    public func set< Type: IQJsonValue >(_ value: [Type], mandatory: Bool, path: String? = nil) throws {
        var index: Int = 0
        let jsonArray = NSMutableArray()
        for item in value {
            let subpath = self._buildPath([ path, index ])
            if mandatory == true {
                let jsonItem = try item.toJsonValue(path: subpath)
                jsonArray.add(jsonItem)
            } else {
                if let jsonItem = try? item.toJsonValue(path: subpath) {
                    jsonArray.add(jsonItem)
                }
            }
            index += 1
        }
        try self.set(jsonArray, path: path)
    }

    public func set< Key: IQJsonValue, Value: IQJsonValue >(_ value: [Key: Value], mandatory: Bool, path: String? = nil) throws {
        var index: Int = 0
        let jsonDictionary = NSMutableDictionary()
        for item in value {
            let subpath = self._buildPath([ path, item.key ])
            guard let jsonKey = try item.key.toJsonValue(path: subpath) as? NSCopying else {
                throw QJsonError.cast(path: subpath)
            }
            if mandatory == true {
                let jsonValue = try item.value.toJsonValue(path: subpath)
                jsonDictionary.setObject(jsonValue, forKey: jsonKey)
            } else {
                if let jsonValue = try? item.value.toJsonValue(path: subpath) {
                    jsonDictionary.setObject(jsonValue, forKey: jsonKey)
                }
            }
            index += 1
        }
        try self.set(jsonDictionary, path: path)
    }

    public func remove(path: String) throws {
        try self._set(nil, subpaths: self._subpaths(path))
    }

    public func get(path: String? = nil) throws -> Any {
        guard var root = self.root else { throw QJsonError.notJson }
        guard let path = path else { return root }
        var subpathIndex: Int = 0
        let subpaths = self._subpaths(path)
        while subpaths.endIndex != subpathIndex {
            let subpath = subpaths[subpathIndex]
            if let dictionary = root as? NSDictionary {
                guard let key = subpath.jsonPathKey else {
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
                }
                guard let temp = dictionary.object(forKey: key) else {
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex + 1))
                }
                root = temp
            } else if let array = root as? NSArray {
                guard let index = subpath.jsonPathIndex, index < array.count else {
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
                }
                root = array.object(at: index)
            } else {
                throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
            }
            subpathIndex += 1
        }
        return root
    }

    public func get(format: String, path: String? = nil) throws -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return try self.get(formatter: formatter, path: path)
    }

    public func get(format: String, path: String? = nil) throws -> Date! {
        let result: Date = try self.get(format: format, path: path)
        return result
    }

    public func get(formatter: DateFormatter, path: String? = nil) throws -> Date {
        let string: String = try self.get(path: path)
        guard let date = formatter.date(from: string) else {
            throw QJsonError.cast(path: self._buildPath([ path ]))
        }
        return date
    }

    public func get(formatter: DateFormatter, path: String? = nil) throws -> Date! {
        let result: Date = try self.get(formatter: formatter, path: path)
        return result
    }

    public func get< Type: IQJsonValue >(path: String? = nil) throws -> Type {
        let jsonValue: Any = try self.get(path: path)
        return try Type.fromJson(value: jsonValue, path: self._buildPath([ path ])) as! Type
    }

    public func get< Type: IQJsonValue >(path: String? = nil) throws -> Type! {
        let result: Type = try self.get(path: path)
        return result
    }

    public func get< Type: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Type] {
        let jsonValue: Any = try self.get(path: path)
        guard let jsonArray = jsonValue as? NSArray else {
            throw QJsonError.cast(path: self._buildPath([ path ]))
        }
        var result: [Type] = []
        var index: Int = 0
        for jsonItem in jsonArray {
            let subpath = self._buildPath([ path, index ])
            if mandatory == true {
                let item = try Type.fromJson(value: jsonItem, path: subpath) as! Type
                result.append(item)
            } else {
                if let item = try? Type.fromJson(value: jsonItem, path: subpath) as? Type {
                    result.append(item)
                }
            }
            index += 1
        }
        return result
    }

    public func get< Type: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Type]! {
        let result: [Type] = try self.get(mandatory: mandatory, path: path)
        return result
    }

    public func get< Key: IQJsonValue, Value: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value] {
        let jsonValue: Any = try self.get(path: path)
        guard let jsonDictionary = jsonValue as? NSDictionary else {
            throw QJsonError.cast(path: self._buildPath([ path ]))
        }
        var result: [Key : Value] = [:]
        for jsonItem in jsonDictionary {
            let subpath = self._buildPath([ path, jsonItem.key ])
            let key = try Key.fromJson(value: jsonItem.key, path: subpath) as! Key
            if mandatory == true {
                let value = try Value.fromJson(value: jsonItem.value, path: subpath) as! Value
                result[key] = value
            } else {
                if let value = try? Value.fromJson(value: jsonItem.value, path: subpath) as? Value {
                    result[key] = value
                }
            }
        }
        return result
    }

    public func get< Key: IQJsonValue, Value: IQJsonValue >(mandatory: Bool, path: String? = nil) throws -> [Key : Value]! {
        let result: [Key : Value] = try self.get(mandatory: mandatory, path: path)
        return result
    }

    private func _subpaths(_ path: String) -> [IQJsonPath] {
        guard path.contains(Const.pathSeparator) == true else {
            return [ path ]
        }
        let components = path.components(separatedBy: Const.pathSeparator)
        return components.compactMap({ (subpath: String) -> IQJsonPath? in
            guard let match = Const.pathIndexPattern.firstMatch(in: subpath, options: [], range: NSRange(location: 0, length: subpath.count)) else {
                return subpath
            }
            if((match.range.location != NSNotFound) && (match.range.length > 0)) {
                let startIndex = subpath.index(subpath.startIndex, offsetBy: 1)
                let endIndex = subpath.index(subpath.endIndex, offsetBy: -1)
                let indexString = String(subpath[startIndex..<endIndex])
                return NSNumber.number(from: indexString)
            }
            return subpath
        })
    }

    private func _set(_ value: Any?, subpaths: [IQJsonPath]) throws {
        if self.root == nil {
            if let subpath = subpaths.first {
                if subpath.jsonPathKey != nil {
                    self.root = NSMutableDictionary()
                } else if subpath.jsonPathIndex != nil {
                    self.root = NSMutableArray()
                } else {
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: 1))
                }
            } else {
                throw QJsonError.access(path: self.basePath)
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
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
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
                    throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
                }
                if subpathIndex == subpaths.endIndex - 1 {
                    if let value = value {
                        mutable.insert(value, at: index)
                    } else {
                        mutable.removeObject(at: index)
                    }
                }
            } else {
                throw QJsonError.access(path: self._buildPath(subpaths, from: 0, to: subpathIndex))
            }
            subpathIndex += 1
            prevRoot = root
        }
    }

    private func _buildPath(_ subpaths: [Any?]) -> String {
        return self._buildPath(subpaths, from: subpaths.startIndex, to: subpaths.endIndex)
    }

    private func _buildPath(_ subpaths: [Any?], from: Int, to: Int) -> String {
        var path = self.basePath
        Array< Any? >(subpaths[from..<to]).forEach({
            guard let item = $0 else { return }
            if let string = item as? String {
                if path.count > 0 {
                    path.append(".\(string)")
                } else {
                    path.append(string)
                }
            } else if let number = item as? NSNumber {
                path.append("[\(number)]")
            } else if let number = item as? UInt {
                path.append("[\(number)]")
            } else if let number = item as? Int {
                path.append("[\(number)]")
            }
        })
        return path
    }

    private struct Const {
        public static var pathSeparator = "."
        public static var pathIndexPattern = try! NSRegularExpression(pattern: "^\\[\\d+\\]$", options: [ .anchorsMatchLines ])
    }

}

// MARK: - IQDebug

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

// MARK: - Bool • IQJsonValue -

extension Bool : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Bool {
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
            throw QJsonError.cast(path: path)
        }
        return boolean
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: - String • IQJsonValue -

extension String : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> String {
        guard let string = value as? String else {
            if let number = value as? NSNumber {
                return number.stringValue
            } else if let decimalNumber = value as? NSDecimalNumber {
                return decimalNumber.stringValue
            } else {
                throw QJsonError.cast(path: path)
            }
        }
        return string
    }

    public func toJsonValue(path: String) throws -> Any {
        return self
    }

}

// MARK: - URL • IQJsonValue -

extension URL : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> URL {
        guard let string = value as? String else {
            throw QJsonError.cast(path: path)
        }
        guard let url = URL(string: string) else {
            throw QJsonError.cast(path: path)
        }
        return url
    }

    public func toJsonValue(path: String) throws -> Any {
        return self.absoluteString
    }

}

// MARK: - NSNumber • IQJsonValue -

extension NSNumber : IQJsonValue {

    @objc
    public class func fromJson(value: Any, path: String) throws -> NSNumber {
        guard let number = value as? NSNumber else {
            if let string = value as? String {
                if let number = NSNumber.number(from: string) {
                    return number
                }
            } else {
                throw QJsonError.cast(path: path)
            }
            throw QJsonError.cast(path: path)
        }
        return number
    }

    @objc
    public func toJsonValue(path: String) throws -> Any {
        return self
    }

}

extension NSDecimalNumber {

    @objc
    public override class func fromJson(value: Any, path: String) throws -> NSDecimalNumber {
        guard let decimalNumber = value as? NSDecimalNumber else {
            if let string = value as? String {
                if let decimalNumber = NSDecimalNumber.decimalNumber(from: string) {
                    return decimalNumber
                }
            } else if let number = value as? NSNumber {
                return NSDecimalNumber(string: number.stringValue)
            } else {
                throw QJsonError.cast(path: path)
            }
            throw QJsonError.cast(path: path)
        }
        return decimalNumber
    }

    @objc
    public override func toJsonValue(path: String) throws -> Any {
        return self.stringValue
    }

}

// MARK: - Decimal • IQJsonValue -

extension Decimal : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Decimal {
        return try NSDecimalNumber.fromJson(value: value, path: path) as Decimal
    }

    public func toJsonValue(path: String) throws -> Any {
        return try (self as NSDecimalNumber).toJsonValue(path: path)
    }

}

// MARK: - Date • IQJsonValue -

extension Date : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Date {
        let timestamp = try NSNumber.fromJson(value: value, path: path)
        return Date(timeIntervalSince1970: timestamp.doubleValue)
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: Int(self.timeIntervalSince1970))
    }

}

// MARK: - Int • IQJsonValue -

extension Int : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Int {
        return try NSNumber.fromJson(value: value, path: path).intValue
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: - UInt • IQJsonValue -

extension UInt : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> UInt {
        return try NSNumber.fromJson(value: value, path: path).uintValue
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: - Float • IQJsonValue -

extension Float : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Float {
        return try NSNumber.fromJson(value: value, path: path).floatValue
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: - Double • IQJsonValue -

extension Double : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Double {
        return try NSNumber.fromJson(value: value, path: path).doubleValue
    }

    public func toJsonValue(path: String) throws -> Any {
        return NSNumber(value: self)
    }

}

// MARK: - CGFloat • IQJsonValue -

extension CGFloat : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> CGFloat {
        return try CGFloat(self.NativeType.fromJson(value: value, path: path))
    }

    public func toJsonValue(path: String) throws -> Any {
        return try self.native.toJsonValue(path: path)
    }

}

// MARK: - UIColor • IQJsonValue -

extension UIColor : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> UIColor {
        if let string = value as? String {
            if let color = UIColor.init(hexString: string) {
                return color
            }
        } else if let number = value as? NSNumber {
            return UIColor.init(hex: number.uint32Value)
        }
        throw QJsonError.cast(path: path)
    }

    public func toJsonValue(path: String) throws -> Any {
        return self.hexString()
    }

}

// MARK: - RawRepresentable • IQJsonValue -

extension RawRepresentable where Self.RawValue : IQJsonValue {

    public static func fromJson(value: Any, path: String) throws -> Any {
        let rawValue = try self.RawValue.fromJson(value: value, path: path) as! Self.RawValue
        guard let value = self.init(rawValue: rawValue) else {
            throw QJsonError.cast(path: path)
        }
        return value
    }

    public func toJsonValue(path: String) throws -> Any {
        return try self.rawValue.toJsonValue(path: path)
    }

}

// MARK: - IQJsonPath -

fileprivate protocol IQJsonPath {

    var jsonPathKey: String? { get }
    var jsonPathIndex: Int? { get }

}

// MARK: - String : IQJsonPath -

extension String : IQJsonPath {

    var jsonPathKey: String? {
        get { return self }
    }
    var jsonPathIndex: Int? {
        get { return nil }
    }

}

// MARK: - NSNumber : IQJsonPath -

extension NSNumber : IQJsonPath {

    var jsonPathKey: String? {
        get { return nil }
    }
    var jsonPathIndex: Int? {
        get { return self.intValue }
    }

}
