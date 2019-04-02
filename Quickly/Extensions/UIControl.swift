//
//  Quickly
//

public extension UIControl {

    func addTouchUpInside(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }

    func removeTouchUpInside(_ target: Any?, action: Selector) {
        self.removeTarget(target, action: action, for: .touchUpInside)
    }

    func addValueChanged(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .valueChanged)
    }

    func removeValueChanged(_ target: Any?, action: Selector) {
        self.removeTarget(target, action: action, for: .valueChanged)
    }

}
