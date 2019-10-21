//
//  Quickly
//

public extension Data {

    var hexString: String {
        var string = String()
        self.forEach({ string += String(format: "%02x", $0) })
        return string
    }

}

public extension Data {

    var md2: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD2_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_MD2($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var md4: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD4_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_MD4($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var md5: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_MD5_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_MD5($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha1: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha224: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA224_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_SHA224($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha256: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha384: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA384_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_SHA384($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

    var sha512: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = self.withUnsafeBytes({ _ = CC_SHA512($0.baseAddress, CC_LONG(self.count), &hash) })
        return Data(hash)
    }

}
