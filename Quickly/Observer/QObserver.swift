//
//  Quickly
//

import Foundation

public protocol IQObserver: class {
}

public class QObserver< T: IQObserver > {

    private var items: [WeakRef]

    public init() {
        self.items = []
    }

    public func add(_ observer: T) {
        if self.items.index(where: { $0 === observer }) == nil {
            self.items.append(WeakRef(observer))
        }
    }

    public func remove(_ observer: T) {
        if let index = self.items.index(where: { $0.value === observer }) {
            self.items.remove(at: index)
        }
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        self.items.forEach { (weakRef: WeakRef) in
            if let observer: T = weakRef.value {
                closure(observer)
            }
        }
    }

    public func compact() {
        self.items = self.items.filter { $0.value != nil }
    }

    private class WeakRef {

        public private(set) weak var value: T?

        public init(_ value: T) {
            self.value = value
        }
        
    }

}
