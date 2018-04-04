//
//  Quickly
//

public final class QObserver< T > {

    private var items: Set< UnsafeMutableRawPointer >

    public init() {
        self.items = []
    }

    public func add(_ observer: T) {
        self.items.insert(Unmanaged.passUnretained(observer as AnyObject).toOpaque())
    }

    public func remove(_ observer: T) {
        self.items.remove(Unmanaged.passUnretained(observer as AnyObject).toOpaque())
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        self.items.forEach { (pointer: UnsafeMutableRawPointer) in
            let object: AnyObject = Unmanaged.fromOpaque(pointer).takeUnretainedValue()
            closure(object as! T)
        }
    }

}
