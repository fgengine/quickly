//
//  Quickly
//

public extension UIControl {

    public func addTouchUpInside(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }

    public func removeTouchUpInside(_ target: Any?, action: Selector) {
        self.removeTarget(target, action: action, for: .touchUpInside)
    }

    public func addValueChanged(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .valueChanged)
    }

    public func removeValueChanged(_ target: Any?, action: Selector) {
        self.removeTarget(target, action: action, for: .valueChanged)
    }

}
