//
//  Quickly
//

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#endif

//
// MARK: IQDebug
//

public protocol IQDebug {

    func debugString() -> String
    func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int)

}

public extension IQDebug {

    public func debugString() -> String {
        var buffer = String()
        self.debugString(&buffer, 0, 1, 0)
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

extension Int : IQDebug {}
extension Int8 : IQDebug {}
extension Int16 : IQDebug {}
extension Int32 : IQDebug {}
extension Int64 : IQDebug {}
extension UInt : IQDebug {}
extension UInt8 : IQDebug {}
extension UInt16 : IQDebug {}
extension UInt32 : IQDebug {}
extension UInt64 : IQDebug {}
extension Float : IQDebug {}
extension Double : IQDebug {}
extension String : IQDebug {}
extension NSString : IQDebug {}
extension NSNumber : IQDebug {}
extension URL : IQDebug {}
extension NSURL : IQDebug {}

//
// MARK: Extension IQDebug
//

extension Optional : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        switch self {
        case .none:
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            buffer.append("nil")
            break
        case .some(let value):
            if let debugValue = value as? IQDebug {
                debugValue.debugString(&buffer, 0, indent, footerIndent)
            } else {
                buffer.append("\(value)")
            }
            break
        }
    }

}

extension Bool : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append((self == true) ? "true" : "false")
    }

}

extension Data : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.count) bytes>")
    }

}

extension NSData : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.length) bytes>")
    }

}

extension CGPoint : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGPoint x: \(self.x) y: \(self.y)>")
    }

}

extension CGSize : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGSize width: \(self.width) height: \(self.height)>")
    }

}

extension CGRect : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<CGRect x: \(self.origin.x) y: \(self.origin.y) width: \(self.size.width) height: \(self.size.height)>")
    }

}

#if os(macOS)



#elseif os(iOS)

    extension UIColor : IQDebug {

        public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            if let hexString = self.hexString() {
                buffer.append("<UIColor \(hexString)>")
            } else {
                buffer.append("<UIColor>")
            }
        }

    }

    extension UIImage : IQDebug {

        public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            buffer.append("<UIImage width: \(self.size.width) height: \(self.size.height)>")
        }

    }

#endif

extension NSError : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<NSError domain: \(self.domain) code: \(self.code)>")
    }

}

extension Array : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement = element as? IQDebug {
                debugElement.debugString(&buffer, indent, nextIndent, indent)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
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

extension NSArray : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement = element as? IQDebug {
                debugElement.debugString(&buffer, indent, nextIndent, indent)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
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

extension Dictionary : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey = key as? IQDebug {
                debugKey.debugString(&buffer, indent, nextIndent, 0)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue = value as? IQDebug {
                debugValue.debugString(&buffer, 0, nextIndent, indent)
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

extension NSDictionary : IQDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey = key as? IQDebug {
                debugKey.debugString(&buffer, indent, nextIndent, 0)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue = value as? IQDebug {
                debugValue.debugString(&buffer, 0, nextIndent, indent)
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

