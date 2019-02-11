//
//  Quickly
//

// MARK: - QXmlError -

public enum QXmlError : Error {
    case notXml
}

// MARK: - QXmlDocument -

public class QXmlDocument {
    
    public var nodes: [QXmlNode]
    
    public init(nodes: [QXmlNode] = []) {
        self.nodes = nodes
    }
    
}

#if DEBUG

extension QXmlDocument : IQDebug {
    
    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
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

// MARK: - QXmlNode -

public class QXmlNode {
    
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
    
}

#if DEBUG

extension QXmlNode : IQDebug {
    
    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
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

// MARK: - QXmlAttribute -

public class QXmlAttribute {
    
    public var name: String
    public var value: QXmlValue
    
    public init(name: String, value: QXmlValue) {
        self.name = name
        self.value = value
    }
    
}

#if DEBUG

extension QXmlAttribute : IQDebug {
    
    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
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

// MARK: - QXmlValue -

public class QXmlValue {
    
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
    
}

#if DEBUG

extension QXmlValue : IQDebug {
    
    open func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
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
