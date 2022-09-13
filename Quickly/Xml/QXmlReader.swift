//
//  Quickly
//

import Foundation

public final class QXmlReader {
    
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
    
}

private extension QXmlReader {
    
    class Delegate : NSObject, XMLParserDelegate {
        
        public var document: QXmlDocument
        private var rootNodes: [QXmlNode]
        private var recurseNodes: [QXmlNode]
        private var trimmingCharacterSet: CharacterSet
        
        public override init() {
            self.document = QXmlDocument()
            self.rootNodes = []
            self.recurseNodes = []
            self.trimmingCharacterSet = CharacterSet.whitespacesAndNewlines
            super.init()
        }
        
        public func parserDidEndDocument(_ parser: XMLParser) {
            self.document.nodes = self.rootNodes
        }
        
        public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            let attributes = attributeDict.compactMap({ (key, value) -> QXmlAttribute in
                return QXmlAttribute(name: key, value: QXmlValue(text: value))
            })
            let node = QXmlNode(name: elementName, attributes: attributes)
            if let parentNode = self.recurseNodes.last {
                parentNode.nodes.append(node)
            } else {
                self.rootNodes.append(node)
            }
            self.recurseNodes.append(node)
        }
        
        public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            guard let node = self.recurseNodes.last else {
                parser.abortParsing()
                return
            }
            if node.name != elementName {
                parser.abortParsing()
            }
            self.recurseNodes.removeLast()
        }
        
        public func parser(_ parser: XMLParser, foundCharacters string: String) {
            let trimString = string.trimmingCharacters(in: self.trimmingCharacterSet)
            if trimString.count > 0 {
                if let node = self.recurseNodes.last {
                    if let value = node.value {
                        value.text.append(trimString)
                    } else {
                        node.value = QXmlValue(text: trimString)
                    }
                } else {
                    parser.abortParsing()
                }
            }
        }
        
    }
    
}
