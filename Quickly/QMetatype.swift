//
//  Quickly
//

public struct QMetatype : Hashable {

    public let base: AnyClass

    public init(_ base: AnyClass) {
        self.base = base
    }

    public init(_ base: Any) {
        self.base = type(of: base) as! AnyClass
    }

    public var hashValue: Int {
        get { return ObjectIdentifier(self.base).hashValue }
    }
    
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self.base).hash(into: &hasher)
    }

    public static func == (lhs: QMetatype, rhs: QMetatype) -> Bool {
        return lhs.base == rhs.base
    }

}
