//
//  Quickly
//

import Quickly.Private

public protocol IJsonValue {

    static func fromJson(value: Any?, at: String) throws -> Any
    func toJsonValue() -> Any?

}

extension Bool: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(boolean: self)
    }

}

extension Int: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).intValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension UInt: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).uintValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Float: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).floatValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Double: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).doubleValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Decimal: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toDecimalNumber(from: value, at: at).decimalValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(decimalNumber: NSDecimalNumber(decimal: self))
    }
    
}

extension String: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toString(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(string: self)
    }

}

extension URL: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toUrl(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(url: self)
    }
    
}

extension Date: IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toDate(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(date: self)
    }
    
}

extension CGFloat: IJsonValue {
    
    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try self.NativeType.fromJson(value: value, at: at)
    }
    
    public func toJsonValue() -> Any? {
        return self.native.toJsonValue()
    }
    
}

#if os(macOS)

    extension NSColor: IJsonValue {

        public static func fromJson(value: Any?, at: String) throws -> Any {
            return try QJsonImpl.toColor(from: value, at: at)
        }

        public func toJsonValue() -> Any? {
            return QJsonImpl.objectFrom(color: self)
        }

    }

#elseif os(iOS)

    extension UIColor: IJsonValue {

        public static func fromJson(value: Any?, at: String) throws -> Any {
            return try QJsonImpl.toColor(from: value, at: at)
        }

        public func toJsonValue() -> Any? {
            return QJsonImpl.objectFrom(color: self)
        }

    }

#endif

//
// MARK: Operators
//

infix operator >>>
infix operator <<<

//
// MARK: Any
//

public func >>> < Type: IJsonValue >(left: Type, right: (QJson, String)) {
    if let jsonValue: Any = left.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func >>> < Type: IJsonValue >(left: Type?, right: (QJson, String)) {
    if let safe: Type = left {
        if let jsonValue: Any = safe.toJsonValue() {
            right.0.set(jsonValue, forPath: right.1)
        } else {
            right.0.set(nil, forPath: right.1)
        }
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < Type: IJsonValue >(left: inout Type, right: (QJson, String)) throws {
    let source: Any? = try right.0.object(at: right.1)
    let jsonValue: Any = try Type.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    left = (jsonValue as! Type)
}

public func <<< < Type: IJsonValue >(left: inout Type!, right: (QJson, String)) throws {
    let source: Any? = try right.0.object(at: right.1)
    let jsonValue: Any = try Type.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    left = (jsonValue as! Type)
}

public func <<< < Type: IJsonValue >(left: inout Type?, right: (QJson, String)) {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            left = jsonValue as? Type
        } else {
            left = nil
        }
    } else {
        left = nil
    }
}

public func <<< < Type: IJsonValue >(left: inout Type, right: (QJson, String, Type)) {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let value: Type = jsonValue as? Type {
                left = value
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<< < Type: IJsonValue >(left: inout Type!, right: (QJson, String, Type)) {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let value: Type = jsonValue as? Type {
                left = value
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<< < Type: IJsonValue >(left: inout Type?, right: (QJson, String, Type?)) {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let value: Type = jsonValue as? Type {
                left = value
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = nil
    }
}

//
// MARK: RawRepresentable
//

public func >>> < EnumType: RawRepresentable >(left: EnumType, right: (QJson, String)) where EnumType.RawValue: IJsonValue {
    if let jsonValue: Any = left.rawValue.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func >>> < EnumType: RawRepresentable >(left: EnumType?, right: (QJson, String)) where EnumType.RawValue: IJsonValue {
    if let safe: EnumType = left {
        if let jsonValue: Any = safe.rawValue.toJsonValue() {
            right.0.set(jsonValue, forPath: right.1)
        } else {
            right.0.set(nil, forPath: right.1)
        }
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType, right: (QJson, String)) throws where EnumType.RawValue: IJsonValue {
    let source: Any? = try right.0.object(at: right.1)
    let jsonValue: Any = try EnumType.RawValue.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
        if let value: EnumType = EnumType(rawValue: rawValue) {
            left = value
        } else {
            throw QJsonImpl.convertError(
                at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
            )
        }
    } else {
        throw QJsonImpl.convertError(
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType!, right: (QJson, String)) throws where EnumType.RawValue: IJsonValue {
    let source: Any? = try right.0.object(at: right.1)
    let jsonValue: Any = try EnumType.RawValue.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
        if let value: EnumType = EnumType(rawValue: rawValue) {
            left = value
        } else {
            throw QJsonImpl.convertError(
                at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
            )
        }
    } else {
        throw QJsonImpl.convertError(
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType?, right: (QJson, String)) where EnumType.RawValue: IJsonValue {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
                left = EnumType(rawValue: rawValue)
            } else {
                left = nil
            }
        } else {
            left = nil
        }
    } else {
        left = nil
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType, right: (QJson, String, EnumType)) where EnumType.RawValue: IJsonValue {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
                if let enumValue: EnumType = EnumType(rawValue: rawValue) {
                    left = enumValue
                } else {
                    left = right.2
                }
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType!, right: (QJson, String, EnumType)) where EnumType.RawValue: IJsonValue {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
                if let enumValue: EnumType = EnumType(rawValue: rawValue) {
                    left = enumValue
                } else {
                    left = right.2
                }
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType?, right: (QJson, String, EnumType?)) where EnumType.RawValue: IJsonValue {
    let maybeMaybeSource: Any?? = try? right.0.object(at: right.1)
    if let maybeSource: Any? = maybeMaybeSource, let source: Any = maybeSource {
        let maybeJsonValue: Any? = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let jsonValue: Any = maybeJsonValue {
            if let rawValue: EnumType.RawValue = jsonValue as? EnumType.RawValue {
                left = EnumType(rawValue: rawValue)
            } else {
                left = right.2
            }
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

//
// MARK: Date
//

public func >>> (left: Date, right: (QJson, String, String)) {
    right.0.set(left, format: right.2, forPath: right.1)
}

public func >>> (left: Date?, right: (QJson, String, String)) {
    if let date: Date = left {
        right.0.set(date, format: right.2, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< (left: inout Date, right: (QJson, String, String)) throws {
    left = try right.0.date(at: right.1, formats: [right.2])
}

public func <<< (left: inout Date!, right: (QJson, String, String)) throws {
    left = try right.0.date(at: right.1, formats: [right.2])
}

public func <<< (left: inout Date?, right: (QJson, String, String)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: [right.2])
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = nil
    }
}

public func <<< (left: inout Date, right: (QJson, String, String, Date)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: [right.2])
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date!, right: (QJson, String, String, Date)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: [right.2])
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date?, right: (QJson, String, String, Date?)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: [right.2])
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date, right: (QJson, String, [String])) throws {
    left = try right.0.date(at: right.1, formats: right.2)
}

public func <<< (left: inout Date!, right: (QJson, String, [String])) throws {
    left = try right.0.date(at: right.1, formats: right.2)
}

public func <<< (left: inout Date?, right: (QJson, String, [String])) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: right.2)
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = nil
    }
}

public func <<< (left: inout Date, right: (QJson, String, [String], Date)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: right.2)
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date!, right: (QJson, String, [String], Date)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: right.2)
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date?, right: (QJson, String, [String], Date?)) {
    let maybeMaybeSource: Date?? = try? right.0.date(at: right.1, formats: right.2)
    if let maybeSource: Date? = maybeMaybeSource, let source: Date = maybeSource {
        left = source
    } else {
        left = right.3
    }
}

//
// MARK: Array
//

public func >>> < ItemType: IJsonValue >(left: [ItemType], right: QJson) {
    let jsonValue: [Any] = left.flatMap { (item: ItemType) -> Any? in
        return item.toJsonValue()
    }
    right.set(jsonValue)
}

public func >>> < ItemType: IJsonValue >(left: [ItemType]?, right: QJson) {
    if let jsonArray = left {
        let jsonValue: [Any] = jsonArray.flatMap { (item: ItemType) -> Any? in
            return item.toJsonValue()
        }
        right.set(jsonValue)
    } else {
        right.clean()
    }
}

public func >>> < ItemType: IJsonValue >(left: [ItemType], right: (QJson, String)) {
    let jsonValue: [Any] = left.flatMap { (item: ItemType) -> Any? in
        return item.toJsonValue()
    }
    right.0.set(jsonValue, forPath: right.1)
}

public func >>> < ItemType: IJsonValue >(left: [ItemType]?, right: (QJson, String)) {
    if let jsonArray = left {
        let jsonValue: [Any] = jsonArray.flatMap { (item: ItemType) -> Any? in
            return item.toJsonValue()
        }
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType], right: QJson) {
    if let source: [Any] = right.array() {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(path: right.basePath, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType]!, right: QJson) {
    if let source: [Any] = right.array() {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(path: right.basePath, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType]?, right: QJson) {
    if let source: [Any] = right.array() {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(path: right.basePath, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = nil
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType], right: (QJson, String)) {
    let maybeMaybeSource: [Any]?? = try? right.0.array(at: right.1)
    if let maybeSource: [Any]? = maybeMaybeSource, let source: [Any] = maybeSource {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType]!, right: (QJson, String)) {
    let maybeMaybeSource: [Any]?? = try? right.0.array(at: right.1)
    if let maybeSource: [Any]? = maybeMaybeSource, let source: [Any] = maybeSource {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType]?, right: (QJson, String)) {
    let maybeMaybeSource: [Any]?? = try? right.0.array(at: right.1)
    if let maybeSource: [Any]? = maybeMaybeSource, let source: [Any] = maybeSource {
        var index: Int = 0
        left = source.flatMap({ (item: Any) -> ItemType? in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, index: index)
            index += 1
            let maybeJsonValue: Any? = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue: Any = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = nil
    }
}

//
// MARK: Dictionary
//

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType], right: QJson) {
    var jsonValue: [AnyHashable: Any] = [:]
    left.forEach { (key: KeyType, value: ValueType) in
        if let safeKey: AnyHashable = key.toJsonValue() as? AnyHashable {
            if let safeValue: Any = value.toJsonValue() {
                jsonValue[safeKey] = safeValue
            }
        }
    }
    right.set(jsonValue)
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType]?, right: QJson) {
    if let jsonDictionary = left {
        var jsonValue: [AnyHashable: Any] = [:]
        jsonDictionary.forEach { (key: KeyType, value: ValueType) in
            if let safeKey: AnyHashable = key.toJsonValue() as? AnyHashable {
                if let safeValue: Any = value.toJsonValue() {
                    jsonValue[safeKey] = safeValue
                }
            }
        }
        right.set(jsonValue)
    } else {
        right.clean()
    }
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType], right: (QJson, String)) {
    var jsonValue: [AnyHashable: Any] = [:]
    left.forEach { (key: KeyType, value: ValueType) in
        if let safeKey: AnyHashable = key.toJsonValue() as? AnyHashable {
            if let safeValue: Any = value.toJsonValue() {
                jsonValue[safeKey] = safeValue
            }
        }
    }
    right.0.set(jsonValue, forPath: right.1)
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType]?, right: (QJson, String)) {
    if let jsonDictionary = left {
        var jsonValue: [AnyHashable: Any] = [:]
        jsonDictionary.forEach { (key: KeyType, value: ValueType) in
            if let safeKey: AnyHashable = key.toJsonValue() as? AnyHashable {
                if let safeValue: Any = value.toJsonValue() {
                    jsonValue[safeKey] = safeValue
                }
            }
        }
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.clean()
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType], right: QJson) {
    if let source: [AnyHashable: Any] = right.dictionary() {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(path: right.basePath, key: key)
            let maybeJsonKey: Any? = try? KeyType.fromJson(value: value, at: path)
            if let jsonKey: Any = maybeJsonKey {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    let maybeJsonValue: Any? = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue: Any = maybeJsonValue {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType]!, right: QJson) {
    if let source: [AnyHashable: Any] = right.dictionary() {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(path: right.basePath, key: key)
            let maybeJsonKey: Any? = try? KeyType.fromJson(value: value, at: path)
            if let jsonKey: Any = maybeJsonKey {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    let maybeJsonValue: Any? = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue: Any = maybeJsonValue {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType]?, right: QJson) {
    if let source: [AnyHashable: Any] = right.dictionary() {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(path: right.basePath, key: key)
            let maybeJsonKey: Any? = try? KeyType.fromJson(value: value, at: path)
            if let jsonKey: Any = maybeJsonKey {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    let maybeJsonValue: Any? = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue: Any = maybeJsonValue {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = nil
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType], right: (QJson, String)) {
    let maybeMaybeSource: [AnyHashable: Any]?? = try? right.0.dictionary(at: right.1)
    if let maybeSource: [AnyHashable: Any]? = maybeMaybeSource, let source: [AnyHashable: Any] = maybeSource {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            let maybeJsonKey: Any? = try? KeyType.fromJson(value: key, at: path)
            if let jsonKey: Any = maybeJsonKey {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    let maybeJsonValue: Any? = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue: Any = maybeJsonValue {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType]!, right: (QJson, String)) {
    let maybeMaybeSource: [AnyHashable: Any]?? = try? right.0.dictionary(at: right.1)
    if let maybeSource: [AnyHashable: Any]? = maybeMaybeSource, let source: [AnyHashable: Any] = maybeSource {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            if let jsonKey: Any = try? KeyType.fromJson(value: key, at: path) {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    if let jsonValue: Any = try? ValueType.fromJson(value: value, at: path) {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType]?, right: (QJson, String)) {
    let maybeMaybeSource: [AnyHashable: Any]?? = try? right.0.dictionary(at: right.1)
    if let maybeSource: [AnyHashable: Any]? = maybeMaybeSource, let source: [AnyHashable: Any] = maybeSource {
        var result: [KeyType: ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path: String = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            if let jsonKey: Any = try? KeyType.fromJson(value: key, at: path) {
                if let safeKey: KeyType = jsonKey as? KeyType {
                    if let jsonValue: Any = try? ValueType.fromJson(value: value, at: path) {
                        if let safeValue: ValueType = jsonValue as? ValueType {
                            result[safeKey] = safeValue
                        }
                    }
                }
            }
        })
        left = result
    } else {
        left = nil
    }
}
