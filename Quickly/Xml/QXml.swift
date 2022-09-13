//
//  Quickly
//

import UIKit

// MARK: QXmlError

public enum QXmlError : Error {
    case notXml
}

// MARK: QXmlDocument

public final class QXmlDocument {
    
    public var nodes: [QXmlNode]
    
    public init(nodes: [QXmlNode] = []) {
        self.nodes = nodes
    }
    
    public func first(_ path: String) -> QXmlNode? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    public func first(_ path: Array< String >) -> QXmlNode? {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                let subpath = Array< String >(path.dropFirst())
                return node.first(subpath)
            }
        }
        return nil
    }
    
}

#if DEBUG

extension QXmlDocument : IQDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")
        
        if self.nodes.count > 0 {
            self.nodes.debugString(&buffer, indent, nextIndent, indent)
        }
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif

// MARK: QXmlNode

public final class QXmlNode {
    
    public var name: String
    public var attributes: [QXmlAttribute]
    public var nodes: [QXmlNode]
    public var value: QXmlValue?
    
    public init(name: String, attributes: [QXmlAttribute], nodes: [QXmlNode] = [], value: QXmlValue? = nil) {
        self.name = name
        self.attributes = attributes
        self.nodes = nodes
        self.value = value
    }
    
    public func first(_ path: String) -> QXmlNode? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    public func first(_ path: Array< String >) -> QXmlNode? {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                return node.first(path.dropFirst())
            }
        }
        return nil
    }
    
    public func first(_ path: ArraySlice< String >) -> QXmlNode? {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                return node.first(path.dropFirst())
            }
        }
        return nil
    }
    
}

#if DEBUG

extension QXmlNode : IQDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")
        
        QDebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        if self.attributes.count > 0 {
            let debug = self.attributes.debugString(0, nextIndent, indent)
            QDebugString("Attributes: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.nodes.count > 0 {
            let debug = self.nodes.debugString(0, nextIndent, indent)
            QDebugString("Nodes: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let value = self.value {
            let debug = value.debugString(0, nextIndent, indent)
            QDebugString("Value: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif

// MARK: QXmlAttribute

public final class QXmlAttribute {
    
    public var name: String
    public var value: QXmlValue
    
    public init(name: String, value: QXmlValue) {
        self.name = name
        self.value = value
    }
    
}

#if DEBUG

extension QXmlAttribute : IQDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")
        
        QDebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        let valueDebug = self.value.debugString(0, nextIndent, indent)
        QDebugString("Value: \(valueDebug)\n", &buffer, indent, nextIndent, indent)
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif

// MARK: QXmlValue

public final class QXmlValue {
    
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public func asNumber() -> NSNumber? {
        return NSNumber.number(from: self.text)
    }
    public func asInt() -> Int? {
        guard let number = self.asNumber() else { return nil }
        return number.intValue
    }
    public func asUInt() -> UInt? {
        guard let number = self.asNumber() else { return nil }
        return number.uintValue
    }
    public func asFloat() -> Float? {
        guard let number = self.asNumber() else { return nil }
        return number.floatValue
    }
    public func asDouble() -> Double? {
        guard let number = self.asNumber() else { return nil }
        return number.doubleValue
    }
    public func asDecimalNumber() -> NSDecimalNumber? {
        return NSDecimalNumber.decimalNumber(from: self.text)
    }
    public func asDecimal() -> Decimal? {
        guard let decimalNumber = self.asDecimalNumber() else { return nil }
        return decimalNumber as Decimal
    }
    public func asUrl() -> URL? {
        return URL.init(string: self.text)
    }
    public func asColor() -> UIColor? {
        return UIColor(hexString: self.text)
    }
    
}

#if DEBUG

extension QXmlValue : IQDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")
        
        QDebugString("\(self.text)\n", &buffer, indent, nextIndent, indent)
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
