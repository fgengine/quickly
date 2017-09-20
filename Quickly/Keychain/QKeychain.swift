//
//  Quickly
//

import Foundation
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

open class QKeychain {

    open var accessGroup: String?
    open var synchronizable: Bool = false

    public init() {
    }

    @discardableResult
    open func set(_ value: Data, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        self.delete(key)
        let query: [String : Any] = self.process(query: [
            Constants.klass : kSecClassGenericPassword,
            Constants.attrAccount : key,
            Constants.valueData : value,
            Constants.accessible : access.value
       ], forceSync: true)
        let code: OSStatus = SecItemAdd(query as CFDictionary, nil)
        return code == noErr
    }

    @discardableResult
    open func set(_ value: String, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        if let value: Data = value.data(using: String.Encoding.utf8) {
            return self.set(value, key: key, access: access)
        }
        return false
    }

    @discardableResult
    open func set(_ value: Bool, key: String, access: QKeychainAccessOptions = .defaultOption) -> Bool {
        let bytes: [UInt8] = value ? [1] : [0]
        let data: Data = Data(bytes: bytes)
        return self.set(data, key: key, access: access)
    }

    open func getData(_ key: String) -> Data? {
        let query: [String: Any] = self.process(query: [
            Constants.klass : kSecClassGenericPassword,
            Constants.attrAccount : key,
            Constants.returnData : kCFBooleanTrue,
            Constants.matchLimit : kSecMatchLimitOne
       ], forceSync: false)
        var result: AnyObject? = nil
        let code: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if code == noErr {
            return result as? Data
        }
        return nil
    }

    open func getString(_ key: String) -> String? {
        if let data: Data = self.getData(key) {
            if let currentString: String = String(data: data, encoding: .utf8) {
                return currentString
            }
        }
        return nil
    }

    open func getBool(_ key: String) -> Bool? {
        guard let data: Data = self.getData(key) else {
            return nil
        }
        guard let firstBit: UInt8 = data.first else {
            return nil
        }
        return firstBit == 1
    }

    @discardableResult
    open func delete(_ key: String) -> Bool {
        let query: [String: Any] = self.process(query: [
            Constants.klass : kSecClassGenericPassword,
            Constants.attrAccount : key
       ], forceSync: false)
        let code: OSStatus = SecItemDelete(query as CFDictionary)
        return code == noErr
    }

    @discardableResult
    open func clear() -> Bool {
        let query: [String: Any] = self.process(query: [
            Constants.klass : kSecClassGenericPassword
       ], forceSync: false)
        let code: OSStatus = SecItemDelete(query as CFDictionary)
        return code == noErr
    }

    private func process(query: [String: Any], forceSync: Bool) -> [String: Any] {
        var result: [String: Any] = query
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

    private struct Constants {
        public static var accessGroup: String {
            return kSecAttrAccessGroup as String
        }
        public static var accessible: String {
            return kSecAttrAccessible as String
        }
        public static var attrAccount: String {
            return kSecAttrAccount as String
        }
        public static var attrSynchronizable: String {
            return kSecAttrSynchronizable as String
        }
        public static var klass: String {
            return kSecClass as String
        }
        public static var matchLimit: String {
            return kSecMatchLimit as String
        }
        public static var returnData: String {
            return kSecReturnData as String
        }
        public static var valueData: String {
            return kSecValueData as String
        }
    }

}
