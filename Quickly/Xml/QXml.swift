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

// MARK: - QXmlAttribute -

public class QXmlAttribute {
    
    public var name: String
    public var value: QXmlValue
    
    public init(name: String, value: QXmlValue) {
        self.name = name
        self.value = value
    }
    
}

// MARK: - QXmlValue -

public class QXmlValue {
    
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
    
}
