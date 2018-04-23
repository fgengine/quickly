//
//  Quickly
//

import Quickly.Private

public protocol IJsonValue {

    static func fromJson(value: Any?, at: String) throws -> Any
    func toJsonValue() -> Any?

}

extension Bool : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(boolean: self)
    }

}

extension Int : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).intValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension UInt : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).uintValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Float : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).floatValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Double : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toNumber(from: value, at: at).doubleValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(number: NSNumber(value: self))
    }
    
}

extension Decimal : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toDecimalNumber(from: value, at: at).decimalValue
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(decimalNumber: NSDecimalNumber(decimal: self))
    }
    
}

extension String : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toString(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(string: self)
    }

}

extension URL : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toUrl(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(url: self)
    }
    
}

extension Date : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toDate(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(date: self)
    }
    
}

extension CGFloat : IJsonValue {
    
    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try self.NativeType.fromJson(value: value, at: at)
    }
    
    public func toJsonValue() -> Any? {
        return self.native.toJsonValue()
    }
    
}

extension UIColor : IJsonValue {

    public static func fromJson(value: Any?, at: String) throws -> Any {
        return try QJsonImpl.toColor(from: value, at: at)
    }

    public func toJsonValue() -> Any? {
        return QJsonImpl.objectFrom(color: self)
    }

}

//
// MARK: Operators
//

infix operator >>>
infix operator <<<
infix operator <<?

//
// MARK: Any
//

public func >>> < Type: IJsonValue >(left: Type, right: (QJson, String)) {
    if let jsonValue = left.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func >>> < Type: IJsonValue >(left: Type?, right: (QJson, String)) {
    if let jsonValue = left?.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < Type: IJsonValue >(left: inout Type, right: (QJson, String)) throws {
    let jsonValue = try Type.fromJson(
        value: try right.0.object(at: right.1),
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    left = (jsonValue as! Type)
}

public func <<< < Type: IJsonValue >(left: inout Type!, right: (QJson, String)) throws {
    let jsonValue = try Type.fromJson(
        value: try right.0.object(at: right.1),
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    left = (jsonValue as! Type)
}

public func <<? < Type: IJsonValue >(left: inout Type?, right: (QJson, String)) {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        left = jsonValue as? Type
    } else {
        left = nil
    }
}

public func <<< < Type: IJsonValue >(left: inout Type, right: (QJson, String, Type)) {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let value = jsonValue as? Type {
            left = value
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<< < Type: IJsonValue >(left: inout Type!, right: (QJson, String, Type)) {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let value = jsonValue as? Type {
            left = value
        } else {
            left = right.2
        }
    } else {
        left = right.2
    }
}

public func <<? < Type: IJsonValue >(left: inout Type?, right: (QJson, String, Type?)) {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? Type.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let value = jsonValue as? Type {
            left = value
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
    if let jsonValue = left.rawValue.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func >>> < EnumType: RawRepresentable >(left: EnumType?, right: (QJson, String)) where EnumType.RawValue: IJsonValue {
    if let jsonValue = left?.rawValue.toJsonValue() {
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType, right: (QJson, String)) throws where EnumType.RawValue: IJsonValue {
    let source = try right.0.object(at: right.1)
    let jsonValue = try EnumType.RawValue.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    if let rawValue = jsonValue as? EnumType.RawValue {
        if let value = EnumType(rawValue: rawValue) {
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
    let source = try right.0.object(at: right.1)
    let jsonValue = try EnumType.RawValue.fromJson(
        value: source,
        at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
    )
    if let rawValue = jsonValue as? EnumType.RawValue {
        if let value = EnumType(rawValue: rawValue) {
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

public func <<? < EnumType: RawRepresentable >(left: inout EnumType?, right: (QJson, String)) where EnumType.RawValue: IJsonValue {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let rawValue = jsonValue as? EnumType.RawValue {
            left = EnumType(rawValue: rawValue)
        } else {
            left = nil
        }
    } else {
        left = nil
    }
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType, right: (QJson, String, EnumType)) where EnumType.RawValue: IJsonValue {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let rawValue = jsonValue as? EnumType.RawValue {
            if let enumValue = EnumType(rawValue: rawValue) {
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
}

public func <<< < EnumType: RawRepresentable >(left: inout EnumType!, right: (QJson, String, EnumType)) where EnumType.RawValue: IJsonValue {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let rawValue = jsonValue as? EnumType.RawValue {
            if let enumValue = EnumType(rawValue: rawValue) {
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
}

public func <<? < EnumType: RawRepresentable >(left: inout EnumType?, right: (QJson, String, EnumType?)) where EnumType.RawValue: IJsonValue {
    if let source = try? right.0.object(at: right.1) {
        let jsonValue = try? EnumType.RawValue.fromJson(
            value: source,
            at: QJsonImpl.prepare(basePath: right.0.basePath, path: right.1)
        )
        if let rawValue = jsonValue as? EnumType.RawValue {
            left = EnumType(rawValue: rawValue)
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
    if let date = left {
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

public func <<? (left: inout Date?, right: (QJson, String, String)) {
    let maybeSource = try? right.0.date(at: right.1, formats: [right.2])
    if let source = maybeSource {
        left = source
    } else {
        left = nil
    }
}

public func <<< (left: inout Date, right: (QJson, String, String, Date)) {
    if let source = try? right.0.date(at: right.1, formats: [right.2]) {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date!, right: (QJson, String, String, Date)) {
    if let source = try? right.0.date(at: right.1, formats: [right.2]) {
        left = source
    } else {
        left = right.3
    }
}

public func <<? (left: inout Date?, right: (QJson, String, String, Date?)) {
    if let source = try? right.0.date(at: right.1, formats: [right.2]) {
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

public func <<? (left: inout Date?, right: (QJson, String, [String])) {
    if let source = try? right.0.date(at: right.1, formats: right.2) {
        left = source
    } else {
        left = nil
    }
}

public func <<< (left: inout Date, right: (QJson, String, [String], Date)) {
    if let source = try? right.0.date(at: right.1, formats: right.2) {
        left = source
    } else {
        left = right.3
    }
}

public func <<< (left: inout Date!, right: (QJson, String, [String], Date)) {
    if let source = try? right.0.date(at: right.1, formats: right.2) {
        left = source
    } else {
        left = right.3
    }
}

public func <<? (left: inout Date?, right: (QJson, String, [String], Date?)) {
    if let source = try? right.0.date(at: right.1, formats: right.2) {
        left = source
    } else {
        left = right.3
    }
}

//
// MARK: Array
//

public func >>> < ItemType: IJsonValue >(left: [ItemType], right: QJson) {
    let jsonValue = left.compactMap { return $0.toJsonValue() }
    right.set(jsonValue)
}

public func >>> < ItemType: IJsonValue >(left: [ItemType]?, right: QJson) {
    if let jsonArray = left {
        let jsonValue = jsonArray.compactMap { return $0.toJsonValue() }
        right.set(jsonValue)
    } else {
        right.clean()
    }
}

public func >>> < ItemType: IJsonValue >(left: [ItemType], right: (QJson, String)) {
    let jsonValue = left.compactMap { return $0.toJsonValue() }
    right.0.set(jsonValue, forPath: right.1)
}

public func >>> < ItemType: IJsonValue >(left: [ItemType]?, right: (QJson, String)) {
    if let jsonArray = left {
        let jsonValue = jsonArray.compactMap { return $0.toJsonValue() }
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.set(nil, forPath: right.1)
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType], right: QJson) {
    if let source = right.array() {
        var index = 0
        left = source.compactMap({ (item) -> ItemType? in
            let path = QJsonImpl.prepare(path: right.basePath, index: index)
            index += 1
            if let jsonValue = try? ItemType.fromJson(value: item, at: path) {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<? < ItemType: IJsonValue >(left: inout [ItemType]?, right: QJson) {
    if let source = right.array() {
        var index = 0
        left = source.compactMap({ (item) -> ItemType? in
            let path = QJsonImpl.prepare(path: right.basePath, index: index)
            index += 1
            if let jsonValue = try? ItemType.fromJson(value: item, at: path) {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = nil
    }
}

public func <<< < ItemType: IJsonValue >(left: inout [ItemType], right: (QJson, String)) {
    if let source = try? right.0.array(at: right.1) {
        var index = 0
        left = source.compactMap({ (item: Any) -> ItemType? in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, index: index)
            index += 1
            let maybeJsonValue = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue = maybeJsonValue {
                return jsonValue as? ItemType
            }
            return nil
        })
    } else {
        left = []
    }
}

public func <<? < ItemType: IJsonValue >(left: inout [ItemType]?, right: (QJson, String)) {
    if let source = try? right.0.array(at: right.1) {
        var index = 0
        left = source.compactMap({ (item: Any) -> ItemType? in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, index: index)
            index += 1
            let maybeJsonValue = try? ItemType.fromJson(value: item, at: path)
            if let jsonValue = maybeJsonValue {
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
    var jsonValue: [KeyType:ValueType] = [:]
    left.forEach { (key: KeyType, value: ValueType) in
        guard
            let safeKey = key.toJsonValue() as? KeyType,
            let safeValue = value.toJsonValue() as? ValueType
            else { return }
        jsonValue[safeKey] = safeValue
    }
    right.set(jsonValue)
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType]?, right: QJson) {
    if let jsonDictionary = left {
        var jsonValue: [KeyType:ValueType] = [:]
        jsonDictionary.forEach { (key: KeyType, value: ValueType) in
            guard
                let safeKey = key.toJsonValue() as? KeyType,
                let safeValue = value.toJsonValue() as? ValueType
                else { return }
            jsonValue[safeKey] = safeValue
        }
        right.set(jsonValue)
    } else {
        right.clean()
    }
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType], right: (QJson, String)) {
    var jsonValue: [KeyType:ValueType] = [:]
    left.forEach { (key: KeyType, value: ValueType) in
        guard
            let safeKey = key.toJsonValue() as? KeyType,
            let safeValue = value.toJsonValue() as? ValueType
            else { return }
        jsonValue[safeKey] = safeValue
    }
    right.0.set(jsonValue, forPath: right.1)
}

public func >>> < KeyType: IJsonValue, ValueType: IJsonValue >(left: [KeyType: ValueType]?, right: (QJson, String)) {
    if let jsonDictionary = left {
        var jsonValue: [KeyType:ValueType] = [:]
        jsonDictionary.forEach { (key: KeyType, value: ValueType) in
            guard
                let safeKey = key.toJsonValue() as? KeyType,
                let safeValue = value.toJsonValue() as? ValueType
                else { return }
            jsonValue[safeKey] = safeValue
        }
        right.0.set(jsonValue, forPath: right.1)
    } else {
        right.0.clean()
    }
}

public func <<< < KeyType: IJsonValue, ValueType: IJsonValue >(left: inout [KeyType: ValueType], right: QJson) {
    if let source = right.dictionary() {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(path: right.basePath, key: key)
            let maybeJsonKey = try? KeyType.fromJson(value: key, at: path)
            if let jsonKey = maybeJsonKey {
                if let safeKey = jsonKey as? KeyType {
                    let maybeJsonValue = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue = maybeJsonValue {
                        if let safeValue = jsonValue as? ValueType {
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
    if let source = right.dictionary() {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(path: right.basePath, key: key)
            let maybeJsonKey = try? KeyType.fromJson(value: key, at: path)
            if let jsonKey = maybeJsonKey {
                if let safeKey = jsonKey as? KeyType {
                    let maybeJsonValue = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue = maybeJsonValue {
                        if let safeValue = jsonValue as? ValueType {
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
    if let source = try? right.0.dictionary(at: right.1) {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            let maybeJsonKey = try? KeyType.fromJson(value: key, at: path)
            if let jsonKey = maybeJsonKey {
                if let safeKey = jsonKey as? KeyType {
                    let maybeJsonValue = try? ValueType.fromJson(value: value, at: path)
                    if let jsonValue = maybeJsonValue {
                        if let safeValue = jsonValue as? ValueType {
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
    if let source = try? right.0.dictionary(at: right.1) {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            if let jsonKey = try? KeyType.fromJson(value: key, at: path) {
                if let safeKey = jsonKey as? KeyType {
                    if let jsonValue = try? ValueType.fromJson(value: value, at: path) {
                        if let safeValue = jsonValue as? ValueType {
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

public func <<< < KeyType: RawRepresentable, ValueType: IJsonValue >(left: inout [KeyType: ValueType], right: (QJson, String)) where KeyType.RawValue: IJsonValue {
    if let source = try? right.0.dictionary(at: right.1) {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            let maybeJsonKey: KeyType?
            if let rawValue = (try? KeyType.RawValue.fromJson(value: key, at: path)) as? KeyType.RawValue, let key = KeyType(rawValue: rawValue) {
                maybeJsonKey = key
            } else {
                maybeJsonKey = nil
            }
            if let jsonKey = maybeJsonKey {
                let maybeJsonValue = try? ValueType.fromJson(value: value, at: path)
                if let jsonValue = maybeJsonValue {
                    if let safeValue = jsonValue as? ValueType {
                        result[jsonKey] = safeValue
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}

public func <<< < KeyType: RawRepresentable, ValueType: IJsonValue >(left: inout [KeyType: ValueType]?, right: (QJson, String)) where KeyType.RawValue: IJsonValue {
    if let source = try? right.0.dictionary(at: right.1) {
        var result: [KeyType:ValueType] = [:]
        source.forEach({ (key: AnyHashable, value: Any) in
            let path = QJsonImpl.prepare(basePath: right.0.basePath, path: right.1, key: key)
            let maybeJsonKey: KeyType?
            if let rawValue = (try? KeyType.RawValue.fromJson(value: key, at: path)) as? KeyType.RawValue, let key = KeyType(rawValue: rawValue) {
                maybeJsonKey = key
            } else {
                maybeJsonKey = nil
            }
            if let jsonKey = maybeJsonKey {
                let maybeJsonValue = try? ValueType.fromJson(value: value, at: path)
                if let jsonValue = maybeJsonValue {
                    if let safeValue = jsonValue as? ValueType {
                        result[jsonKey] = safeValue
                    }
                }
            }
        })
        left = result
    } else {
        left = [:]
    }
}
