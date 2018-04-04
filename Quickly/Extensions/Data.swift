//
//  Quickly
//

#if os(macOS)
    import QuicklyCryptoMacOS
#elseif os(iOS)
    #if (arch(i386) || arch(x86_64))
        import QuicklyCryptoIOSSimulator
    #else
        import QuicklyCryptoIOS
    #endif
#elseif os(tvOS)
    #if (arch(i386) || arch(x86_64))
        import QuicklyCryptoTvOSSimulator
    #else
        import QuicklyCryptoTvOS
    #endif
#elseif os(watchOS)
    #if (arch(i386) || arch(x86_64))
        import QuicklyCryptoWatchOSSimulator
    #else
        import QuicklyCryptoWatchOS
    #endif
#endif

public extension Data {

    public var hexString: String {
        var string = String()
        self.enumerateBytes { pointer, index, _ in
            for i in index ..< pointer.count {
                string += String(format: "%02x", pointer[i])
            }
        }
        return string
    }

}

public extension Data {

    public var md2: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD2_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_MD2($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var md4: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD4_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_MD4($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var md5: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_MD5($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var sha1: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_SHA1($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var sha224: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA224_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_SHA224($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var sha256: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_SHA256($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var sha384: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA384_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_SHA384($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

    public var sha512: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        self.withUnsafeBytes { _ = CC_SHA512($0, CC_LONG(self.count), &hash) }
        return Data(bytes: hash)
    }

}
