//
//  Quickly
//

#if os(iOS)

    public protocol QKeyboardObserver {

        func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)
        func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)

        func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)
        func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo)

    }

    public final class QKeyboardAnimationInfo {

        public let beginFrame: CGRect
        public let endFrame: CGRect
        public let duration: TimeInterval
        public let curve: UIViewAnimationCurve
        public let local: Bool

        public init?(_ userInfo: [ AnyHashable: Any ]) {
            guard
                let beginFrameValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
                let endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
                let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
                let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
                let localValue = userInfo[UIKeyboardIsLocalUserInfoKey] as? NSNumber
                else { return nil }
            self.beginFrame = beginFrameValue.cgRectValue
            self.endFrame = endFrameValue.cgRectValue
            self.duration = TimeInterval(durationValue.doubleValue)
            self.curve = UIViewAnimationCurve(rawValue: curveValue.intValue)!
            self.local = localValue.boolValue
        }

    }

    public final class QKeyboard {

        private var observer: QObserver< QKeyboardObserver >

        public init() {
            self.observer = QObserver< QKeyboardObserver >()
            self.start()
        }

        deinit {
            self.stop()
        }

        public func addObserver(_ observer: QKeyboardObserver) {
            self.observer.add(observer)
        }

        public func removeObserver(_ observer: QKeyboardObserver) {
            self.observer.remove(observer)
        }

        private func start() {
            NotificationCenter.default.addObserver(self, selector: #selector(self.willShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.willHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }

        private func stop() {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }

        @objc
        private func willShow(_ notification: Notification) {
            guard
                let notificationInfo = notification.userInfo,
                let animationInfo = QKeyboardAnimationInfo(notificationInfo)
                else { return }
            self.observer.notify({ (observer: QKeyboardObserver) in
                observer.willShowKeyboard(self, animationInfo: animationInfo)
            })
        }

        @objc
        private func didShow(_ notification: Notification) {
            guard
                let notificationInfo = notification.userInfo,
                let animationInfo = QKeyboardAnimationInfo(notificationInfo)
                else { return }
            self.observer.notify({ (observer: QKeyboardObserver) in
                observer.didShowKeyboard(self, animationInfo: animationInfo)
            })
        }

        @objc
        private func willHide(_ notification: Notification) {
            guard
                let notificationInfo = notification.userInfo,
                let animationInfo = QKeyboardAnimationInfo(notificationInfo)
                else { return }
            self.observer.notify({ (observer: QKeyboardObserver) in
                observer.willHideKeyboard(self, animationInfo: animationInfo)
            })
        }

        @objc
        private func didHide(_ notification: Notification) {
            guard
                let notificationInfo = notification.userInfo,
                let animationInfo = QKeyboardAnimationInfo(notificationInfo)
                else { return }
            self.observer.notify({ (observer: QKeyboardObserver) in
                observer.didHideKeyboard(self, animationInfo: animationInfo)
            })
        }

    }

#endif
