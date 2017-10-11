//
//  Quickly
//

public class QObserver< T > {

    private var items: Set< UnsafeMutableRawPointer >

    public init() {
        self.items = []
    }

    public func add(_ observer: T) {
        let object: AnyObject = observer as AnyObject
        self.items.insert(Unmanaged.passUnretained(object).toOpaque())
    }

    public func remove(_ observer: T) {
        let object: AnyObject = observer as AnyObject
        self.items.remove(Unmanaged.passUnretained(object).toOpaque())
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        self.items.forEach { (pointer: UnsafeMutableRawPointer) in
            let object: AnyObject = Unmanaged.fromOpaque(pointer).takeUnretainedValue()
            if let observer: T = object as? T {
                closure(observer)
            }
        }
    }

}
