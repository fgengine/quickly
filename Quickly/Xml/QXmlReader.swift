//
//  Quickly
//

public class QXmlReader {
    
    public var document: QXmlDocument
    
    public init(data: Data) throws {
        let delegate = Delegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        if parser.parse() == true {
            self.document = delegate.document
        } else {
            if let error = parser.parserError {
                throw error
            }
            throw QXmlError.notXml
        }
    }
    
    public convenience init(string: String, encoding: String.Encoding = String.Encoding.utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw QXmlError.notXml
        }
        try self.init(data: data)
    }
    
    private class Delegate : NSObject, XMLParserDelegate {
        
        public var document: QXmlDocument
        private var nodes: [QXmlNode]
        private var currentNode: QXmlNode {
            get { return self.nodes[self.nodes.count - 1] }
        }
        
        public override init() {
            self.document = QXmlDocument()
            self.nodes = []
            super.init()
        }
        
        public func parserDidEndDocument(_ parser: XMLParser) {
            self.document.nodes = self.nodes
        }
        
        public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            let attributes = attributeDict.compactMap({ (key, value) -> QXmlAttribute in
                return QXmlAttribute(name: key, value: QXmlValue(text: value))
            })
            self.nodes.append(QXmlNode(name: elementName, attributes: attributes))
        }
        
        public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            let node = self.currentNode
            if node.name != elementName {
                parser.abortParsing()
            }
            self.nodes.remove(at: self.nodes.count - 1)
        }
        
        public func parser(_ parser: XMLParser, foundCharacters string: String) {
            let node = self.currentNode
            if let value = node.value {
                value.text.append(string)
            } else {
                node.value = QXmlValue(text: string)
            }
        }
        
    }
    
}
