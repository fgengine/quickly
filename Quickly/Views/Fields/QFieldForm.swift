//
//  Quickly
//

public class QFieldForm : IQFieldForm {
    
    public private(set) var fields: [IQField]
    public private(set) var isValid: Bool
    
    private var _observer: QObserver< IQFieldFormObserver >
    
    public init() {
        self.fields = []
        self.isValid = false
        self._observer = QObserver< IQFieldFormObserver >()
    }
    
    public func add(observer: IQFieldFormObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IQFieldFormObserver) {
        self._observer.remove(observer)
    }
    
    public func add(field: IQField) {
        if self.fields.contains(where: { return $0 === field }) == false {
            self.fields.append(field)
        }
    }
    
    public func remove(field: IQField) {
        if let index = self.fields.firstIndex(where: { return $0 === field }) {
            self.fields.remove(at: index)
        }
    }
    
    public func validation() {
        let invalids = self.fields.filter({ return $0.isValid == false })
        let isValid = (self.fields.count > 0) && (invalids.count == 0)
        if self.isValid != isValid {
            self.isValid = isValid
            self._observer.notify({ $0.fieldForm(self, isValid: isValid) })
        }
    }
    
}
