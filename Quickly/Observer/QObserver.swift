//
//  Quickly
//

public final class QObserver< T > {

    private var items: [Item]
    private var isForeached: Bool
    private var addingItems: [Item]
    private var removingItems: [Item]

    public init() {
        self.items = []
        self.isForeached = false
        self.addingItems = []
        self.removingItems = []
    }

    public func add(_ observer: T, priority: UInt) {
        if self.isForeached == true {
            let item = Item(priority: priority, observer: observer)
            self.addingItems.append(item)
        } else {
            if let index = self._index(observer) {
                self.items[index].priority = priority
            } else {
                self.items.append(Item(priority: priority, observer: observer))
            }
            self._postAdd()
        }
    }

    public func remove(_ observer: T) {
        guard let index = self._index(observer) else { return }
        if self.isForeached == true {
            self.removingItems.append(self.items[index])
        } else {
            self.items.remove(at: index)
        }
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        if self.isForeached == false {
            self.isForeached = true
            self.items.forEach({
                closure($0.observer)
            })
            self.isForeached = false
            self._postNotify()
        } else {
            fatalError("Recursive notify")
        }
    }
    
    public func notify(priorities: [UInt], closure: (_ observer: T) -> Void) {
        if self.isForeached == false {
            self.isForeached = true
            for priority in priorities {
                let items = self.items.filter({ return $0.priority == priority })
                items.forEach({
                    closure($0.observer)
                })
            }
            self.isForeached = false
            self._postNotify()
        } else {
            fatalError("Recursive notify")
        }
    }

    public func reverseNotify(_ closure: (_ observer: T) -> Void) {
        if self.isForeached == false {
            self.isForeached = true
            self.items.reversed().forEach({
                closure($0.observer)
            })
            self.isForeached = false
            self._postNotify()
        } else {
            fatalError("Recursive notify")
        }
    }
    
    public func reverseNotify(priorities: [UInt], closure: (_ observer: T) -> Void) {
        if self.isForeached == false {
            self.isForeached = true
            for priority in priorities {
                let items = self.items.filter({ return $0.priority == priority })
                items.reversed().forEach({
                    closure($0.observer)
                })
            }
            self.isForeached = false
            self._postNotify()
        } else {
            fatalError("Recursive notify")
        }
    }
    
    private func _index(_ observer: T) -> Int? {
        let pointer = Unmanaged.passUnretained(observer as AnyObject).toOpaque()
        return self.items.index(where: { return $0.pointer == pointer })
    }
    
    private func _index(_ item: Item) -> Int? {
        return self.items.index(where: { return $0.pointer == item.pointer })
    }
    
    private func _postNotify() {
        if self.removingItems.count > 0 {
            for item in self.removingItems {
                if let index = self._index(item) {
                    self.items.remove(at: index)
                }
            }
            self.removingItems.removeAll()
        }
        if self.addingItems.count > 0 {
            for item in self.addingItems {
                if let index = self._index(item) {
                    self.items[index].priority = item.priority
                } else {
                    self.items.append(item)
                }
            }
            self.addingItems.removeAll()
            self._postAdd()
        }
    }
    
    private func _postAdd() {
        self.items.sort(by: { return $0.priority < $1.priority })
    }

    private final class Item {

        var priority: UInt
        var pointer: UnsafeMutableRawPointer
        var observer: T {
            get { return Unmanaged< AnyObject >.fromOpaque(self.pointer).takeUnretainedValue() as! T }
        }
        
        init(priority: UInt, observer: T) {
            self.priority = priority
            self.pointer = Unmanaged.passUnretained(observer as AnyObject).toOpaque()
        }

        init(priority: UInt, pointer: UnsafeMutableRawPointer) {
            self.priority = priority
            self.pointer = pointer
        }

    }

}
