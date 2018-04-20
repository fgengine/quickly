//
//  Quickly
//

public func inheritanceLevel(_ selfClass: AnyClass, _ targetClass: AnyClass) -> UInt? {
    var currentClass: AnyClass = selfClass
    var level: UInt = 0
    while currentClass !== targetClass {
        guard let superclass = currentClass.superclass() else { return nil }
        currentClass = superclass
        level += 1
    }
    return level
}
