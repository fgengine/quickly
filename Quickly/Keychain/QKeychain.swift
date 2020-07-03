//
//  Quickly
//

import Security

public enum QKeychainAccessOptions {
    case accessibleWhenUnlocked
    case accessibleWhenUnlockedThisDeviceOnly
    case accessibleAfterFirstUnlock
    case accessibleAfterFirstUnlockThisDeviceOnly
    case accessibleAlways
    case accessibleWhenPasscodeSetThisDeviceOnly
    case accessibleAlwaysThisDeviceOnly

    public static var defaultOption: QKeychainAccessOptions {
        return .accessibleWhenUnlocked
    }

    public var value: String {
        switch self {
        case .accessibleWhenUnlocked: return kSecAttrAccessibleWhenUnlocked as String
        case .accessibleWhenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
        case .accessibleAfterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock as String
        case .accessibleAfterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
        case .accessibleAlways: return kSecAttrAccessibleAlways as String
        case .accessibleWhenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
        case .accessibleAlwaysThisDeviceOnly: return kSecAttrAccessibleAlwaysThisDeviceOnly as String
        }
    }
}

public final class QKeychain {

    public var accessGroup: String?
    public var synchronizable: Bool

    public init() {
        self.synchronizable = false
    }

    @discardableResult
    public func set(_ value: Data?, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }

    @discardableResult
    public func set(_ value: String?, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }

    @discardableResult
    public func set(_ value: Bool?, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(value, key: key, access: access)
    }

    @discardableResult
    public func set< ValueType: BinaryInteger >(_ value: ValueType?, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        guard let value = value else {
            return self._processDelete(key)
        }
        return self._processSet(String(value), key: key, access: access)
    }

    public func get(_ key: String) -> Data? {
        let query = self._process(query: [
            Constants.klass : kSecClassGenericPassword,
            Constants.attrAccount : key,
            Constants.returnData : kCFBooleanTrue as Any,
            Constants.matchLimit : kSecMatchLimitOne
       ], forceSync: false)
        var result: AnyObject? = nil
        let code = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if code == noErr {
            return result as? Data
        }
        return nil
    }

    public func get(_ key: String) -> String? {
        guard let data: Data = self.get(key) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }

    public func get(_ key: String) -> Bool? {
        guard let data: Data = self.get(key) else { return nil }
        guard let firstBit = data.first else { return nil }
        return firstBit != 0
    }

    public func get(_ key: String, radix: Int = 10) -> Int? {
        guard let string: String = self.get(key) else { return nil }
        return Int(string, radix: radix)
    }

    public func get(_ key: String, radix: Int = 10) -> UInt? {
        guard let string: String = self.get(key) else { return nil }
        return UInt(string, radix: radix)
    }

    @discardableResult
    public func clear() -> Bool {
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword
            ],
            forceSync: false
        )
        let code = SecItemDelete(query as CFDictionary)
        return code == noErr
    }
    
}

// MARK: Private

private extension QKeychain {

    func _processSet(_ value: Data, key: String, access: QKeychainAccessOptions) -> Bool {
        self._processDelete(key)
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword,
                Constants.attrAccount : key,
                Constants.valueData : value,
                Constants.accessible : access.value
            ],
            forceSync: true
        )
        let code = SecItemAdd(query as CFDictionary, nil)
        return code == noErr
    }

    func _processSet(_ value: String, key: String, access: QKeychainAccessOptions) -> Bool {
        guard let data = value.data(using: String.Encoding.utf8) else { return false }
        return self._processSet(data, key: key, access: access)
    }

    func _processSet(_ value: Bool, key: String, access: QKeychainAccessOptions) -> Bool {
        let bytes: [UInt8] = (value == true) ? [1] : [0]
        return self._processSet(Data(bytes), key: key, access: access)
    }

    @discardableResult
    func _processDelete(_ key: String) -> Bool {
        let query = self._process(
            query: [
                Constants.klass : kSecClassGenericPassword,
                Constants.attrAccount : key
            ],
            forceSync: false
        )
        let code = SecItemDelete(query as CFDictionary)
        return code == noErr
    }

    func _process(query: [String: Any], forceSync: Bool) -> [String: Any] {
        var result = query
        if let accessGroup = self.accessGroup {
            result[Constants.accessGroup] = accessGroup
        }
        if self.synchronizable == true {
            if forceSync == true {
                result[Constants.attrSynchronizable] = true
            } else {
                result[Constants.attrSynchronizable] = kSecAttrSynchronizableAny
            }
        }
        return result
    }

    struct Constants {

        public static var accessGroup: String { return kSecAttrAccessGroup as String }
        public static var accessible: String { return kSecAttrAccessible as String }
        public static var attrAccount: String { return kSecAttrAccount as String }
        public static var attrSynchronizable: String { return kSecAttrSynchronizable as String }
        public static var klass: String { return kSecClass as String }
        public static var matchLimit: String { return kSecMatchLimit as String }
        public static var returnData: String { return kSecReturnData as String }
        public static var valueData: String { return kSecValueData as String }

    }

}
