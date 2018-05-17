//
//  Quickly
//

public final class QObserver< T > {

    private var items: [Item]

    public init() {
        self.items = []
    }

    public func add(_ observer: T, priority: UInt) {
        let pointer = Unmanaged.passUnretained(observer as AnyObject).toOpaque()
        self.items.append(Item(priority: priority, pointer: pointer))
        self.items.sort(by: { return $0.priority < $1.priority })
    }

    public func remove(_ observer: T) {
        let pointer = Unmanaged.passUnretained(observer as AnyObject).toOpaque()
        guard let index = self.items.index(where: { return $0.pointer == pointer }) else { return }
        self.items.remove(at: index)
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        self.items.forEach({ closure($0.observer) })
    }

    private final class Item {

        let priority: UInt
        let pointer: UnsafeMutableRawPointer
        var observer: T {
            get { return Unmanaged< AnyObject >.fromOpaque(self.pointer).takeUnretainedValue() as! T }
        }

        init(priority: UInt, pointer: UnsafeMutableRawPointer) {
            self.priority = priority
            self.pointer = pointer
        }

    }

}
