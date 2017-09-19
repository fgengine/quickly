//
//  Quickly
//

import Foundation
import UIKit

//
// MARK: IQDebug
//

public protocol IQDebug {

    func debugString() -> String
    func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int)

}

public extension IQDebug {

    public func debugString() -> String {
        var buffer: String = String()
        self.debugString(&buffer, 0, 0, 0)
        return buffer
    }

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("\(self)")
    }
    
}

public func QDebugString(_ value: IQDebug) -> String {
    return value.debugString()
}

public func QDebugString(_ value: IQDebug, _ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
    value.debugString(&buffer, headerIndent, indent, footerIndent)
}

//
// MARK: Extension IQDebug
//

extension Int: IQDebug {}
extension Int8: IQDebug {}
extension Int16: IQDebug {}
extension Int32: IQDebug {}
extension Int64: IQDebug {}
extension UInt: IQDebug {}
extension UInt8: IQDebug {}
extension UInt16: IQDebug {}
extension UInt32: IQDebug {}
extension UInt64: IQDebug {}
extension Float: IQDebug {}
extension Double: IQDebug {}
extension String: IQDebug {}
extension URL: IQDebug {}
extension NSURL: IQDebug {}

//
// MARK: Extension IQDebug
//

extension Bool: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append((self == true) ? "true" : "false")
    }

}

extension Data: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.count) bytes>")
    }

}

extension NSData: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.length) bytes>")
    }
    
}

extension CGPoint: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGPoint x: \(self.x) y: \(self.y)>")
    }

}

extension CGSize: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGSize width: \(self.width) height: \(self.height)>")
    }

}

extension CGRect: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGRect x: \(self.origin.x) y: \(self.origin.y) width: \(self.size.width) height: \(self.size.height)>")
    }

}

extension UIColor: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        if let hexString: String = self.hexString() {
            buffer.append("<UIColor \(hexString)>")
        } else {
            buffer.append("<UIColor>")
        }
    }

}

extension UIImage: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<UIImage width: \(self.size.width) height: \(self.size.height)>")
    }
    
}

extension NSError: IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<NSError domain: \(self.domain) code: \(self.code)>")
    }

}

extension Array {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let baseIndent: Int = indent + 1
        let nextIndent: Int = baseIndent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement: IQDebug = element as? IQDebug {
                debugElement.debugString(&buffer, baseIndent, nextIndent, baseIndent)
            } else {
                if baseIndent > 0 {
                    buffer.append(String(repeating: "\t", count: baseIndent))
                }
                buffer.append("\(element)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("]")
    }

}

extension NSArray {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let baseIndent: Int = indent + 1
        let nextIndent: Int = baseIndent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement: IQDebug = element as? IQDebug {
                debugElement.debugString(&buffer, baseIndent, nextIndent, baseIndent)
            } else {
                if baseIndent > 0 {
                    buffer.append(String(repeating: "\t", count: baseIndent))
                }
                buffer.append("\(element)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("]")
    }
    
}

extension Dictionary {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let baseIndent: Int = indent + 1
        let nextIndent: Int = baseIndent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey: IQDebug = key as? IQDebug {
                debugKey.debugString(&buffer, baseIndent, nextIndent, 0)
            } else {
                if baseIndent > 0 {
                    buffer.append(String(repeating: "\t", count: baseIndent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue: IQDebug = value as? IQDebug {
                debugValue.debugString(&buffer, 0, nextIndent, baseIndent)
            } else {
                buffer.append("\(value)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("}")
    }
    
}

extension NSDictionary {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let baseIndent: Int = indent + 1
        let nextIndent: Int = baseIndent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey: IQDebug = key as? IQDebug {
                debugKey.debugString(&buffer, baseIndent, nextIndent, 0)
            } else {
                if baseIndent > 0 {
                    buffer.append(String(repeating: "\t", count: baseIndent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue: IQDebug = value as? IQDebug {
                debugValue.debugString(&buffer, 0, nextIndent, baseIndent)
            } else {
                buffer.append("\(value)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("}")
    }
    
}
