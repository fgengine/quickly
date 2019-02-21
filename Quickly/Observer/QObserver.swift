//
//  Quickly
//

public final class QObserver< T > {

    private var _items: [Item]
    private var _isForeached: Bool
    private var _addingItems: [Item]
    private var _removingItems: [Item]

    public init() {
        self._items = []
        self._isForeached = false
        self._addingItems = []
        self._removingItems = []
    }

    public func add(_ observer: T, priority: UInt) {
        if self._isForeached == true {
            let item = Item(priority: priority, observer: observer)
            self._addingItems.append(item)
        } else {
            if let index = self._index(observer) {
                self._items[index].priority = priority
            } else {
                self._items.append(Item(priority: priority, observer: observer))
            }
            self._postAdd()
        }
    }

    public func remove(_ observer: T) {
        guard let index = self._index(observer) else { return }
        if self._isForeached == true {
            self._removingItems.append(self._items[index])
        } else {
            self._items.remove(at: index)
        }
    }

    public func notify(_ closure: (_ observer: T) -> Void) {
        if self._isForeached == false {
            self._isForeached = true
            self._items.forEach({
                closure($0.observer)
            })
            self._isForeached = false
            self._postNotify()
        } else {
            self._items.forEach({
                closure($0.observer)
            })
        }
    }
    
    public func notify(priorities: [UInt], closure: (_ observer: T) -> Void) {
        if self._isForeached == false {
            self._isForeached = true
            for priority in priorities {
                let items = self._items.filter({ return $0.priority == priority })
                items.forEach({
                    closure($0.observer)
                })
            }
            self._isForeached = false
            self._postNotify()
        } else {
            for priority in priorities {
                let items = self._items.filter({ return $0.priority == priority })
                items.forEach({
                    closure($0.observer)
                })
            }
        }
    }

    public func reverseNotify(_ closure: (_ observer: T) -> Void) {
        if self._isForeached == false {
            self._isForeached = true
            self._items.reversed().forEach({
                closure($0.observer)
            })
            self._isForeached = false
            self._postNotify()
        } else {
            self._items.reversed().forEach({
                closure($0.observer)
            })
        }
    }
    
    public func reverseNotify(priorities: [UInt], closure: (_ observer: T) -> Void) {
        if self._isForeached == false {
            self._isForeached = true
            for priority in priorities {
                let items = self._items.filter({ return $0.priority == priority })
                items.reversed().forEach({
                    closure($0.observer)
                })
            }
            self._isForeached = false
            self._postNotify()
        } else {
            for priority in priorities {
                let items = self._items.filter({ return $0.priority == priority })
                items.reversed().forEach({
                    closure($0.observer)
                })
            }
        }
    }
    
    private func _index(_ observer: T) -> Int? {
        let pointer = Unmanaged.passUnretained(observer as AnyObject).toOpaque()
        return self._items.index(where: { return $0.pointer == pointer })
    }
    
    private func _index(_ item: Item) -> Int? {
        return self._items.index(where: { return $0.pointer == item.pointer })
    }
    
    private func _postNotify() {
        if self._removingItems.count > 0 {
            for item in self._removingItems {
                if let index = self._index(item) {
                    self._items.remove(at: index)
                }
            }
            self._removingItems.removeAll()
        }
        if self._addingItems.count > 0 {
            for item in self._addingItems {
                if let index = self._index(item) {
                    self._items[index].priority = item.priority
                } else {
                    self._items.append(item)
                }
            }
            self._addingItems.removeAll()
            self._postAdd()
        }
    }
    
    private func _postAdd() {
        self._items.sort(by: { return $0.priority < $1.priority })
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
