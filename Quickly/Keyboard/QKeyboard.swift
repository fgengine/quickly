//
//  Quickly
//

public protocol IQKeyboardObserver {

    func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)
    func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)

    func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)
    func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)

}

public final class QKeyboardAnimationInfo {

    public let beginFrame: CGRect
    public let endFrame: CGRect
    public let duration: TimeInterval
    public let curve: UIView.AnimationCurve
    public let local: Bool

    public init?(_ userInfo: [ AnyHashable: Any ]) {
        guard
            let beginFrameValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
            let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let localValue = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber
            else { return nil }
        self.beginFrame = beginFrameValue.cgRectValue
        self.endFrame = endFrameValue.cgRectValue
        self.duration = TimeInterval(durationValue.doubleValue)
        self.curve = UIView.AnimationCurve(rawValue: curveValue.intValue) ?? .easeInOut
        self.local = localValue.boolValue
    }
    
    public func animationOptions(_ base: UIView.AnimationOptions) -> UIView.AnimationOptions {
        var options: UIView.AnimationOptions = base
        switch self.curve {
        case .linear: options.insert(.curveLinear)
        case .easeIn: options.insert(.curveEaseIn)
        case .easeOut: options.insert(.curveEaseOut)
        default: options.insert(.curveEaseInOut)
        }
        return options
    }

}

public final class QKeyboard {

    private var _observer: QObserver< IQKeyboardObserver >

    public init() {
        self._observer = QObserver< IQKeyboardObserver >()
        self._start()
    }

    deinit {
        self._stop()
    }

    public func addObserver(_ observer: IQKeyboardObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    public func removeObserver(_ observer: IQKeyboardObserver) {
        self._observer.remove(observer)
    }

    private func _start() {
        NotificationCenter.default.addObserver(self, selector: #selector(self._willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    private func _stop() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc
    private func _willShow(_ notification: Notification) {
        guard
            let notificationInfo = notification.userInfo,
            let animationInfo = QKeyboardAnimationInfo(notificationInfo)
            else { return }
        self._observer.notify({ (observer: IQKeyboardObserver) in
            observer.willShowKeyboard(self, animationInfo: animationInfo)
        })
    }

    @objc
    private func _didShow(_ notification: Notification) {
        guard
            let notificationInfo = notification.userInfo,
            let animationInfo = QKeyboardAnimationInfo(notificationInfo)
            else { return }
        self._observer.notify({ (observer: IQKeyboardObserver) in
            observer.didShowKeyboard(self, animationInfo: animationInfo)
        })
    }

    @objc
    private func _willHide(_ notification: Notification) {
        guard
            let notificationInfo = notification.userInfo,
            let animationInfo = QKeyboardAnimationInfo(notificationInfo)
            else { return }
        self._observer.notify({ (observer: IQKeyboardObserver) in
            observer.willHideKeyboard(self, animationInfo: animationInfo)
        })
    }

    @objc
    private func _didHide(_ notification: Notification) {
        guard
            let notificationInfo = notification.userInfo,
            let animationInfo = QKeyboardAnimationInfo(notificationInfo)
            else { return }
        self._observer.notify({ (observer: IQKeyboardObserver) in
            observer.didHideKeyboard(self, animationInfo: animationInfo)
        })
    }

}
