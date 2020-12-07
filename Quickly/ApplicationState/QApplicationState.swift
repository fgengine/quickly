//
//  Quickly
//

public protocol IQApplicationStateObserver {
    
    func didReceiveMemoryWarning(_ applicationState: QApplicationState)
    
    func didFinishLaunching(_ applicationState: QApplicationState)
    
    func didEnterBackground(_ applicationState: QApplicationState)
    func willEnterForeground(_ applicationState: QApplicationState)
    
    func didBecomeActive(_ applicationState: QApplicationState)
    func willResignActive(_ applicationState: QApplicationState)
    
    func willTerminate(_ applicationState: QApplicationState)
    
}

public final class QApplicationState {
    
    private var _observer: QObserver< IQApplicationStateObserver >
    
    public init() {
        self._observer = QObserver< IQApplicationStateObserver >()
        self._subsribe()
    }
    
    deinit {
        self._unsubsribe()
    }
    
    public func add(observer: IQApplicationStateObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQApplicationStateObserver) {
        self._observer.remove(observer)
    }
    
}

private extension QApplicationState {
    
    func _subsribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self._didReceiveMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didFinishLaunching(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    func _unsubsribe() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc
    func _didReceiveMemoryWarning(_ notification: Notification) {
        self._observer.notify({ $0.didReceiveMemoryWarning(self) })
    }
    
    @objc
    func _didFinishLaunching(_ notification: Notification) {
        self._observer.notify({ $0.didFinishLaunching(self) })
    }
    
    @objc
    func _didEnterBackground(_ notification: Notification) {
        self._observer.notify({ $0.didEnterBackground(self) })
    }
    
    @objc
    func _willEnterForeground(_ notification: Notification) {
        self._observer.notify({ $0.willEnterForeground(self) })
    }
    
    @objc
    func _didBecomeActive(_ notification: Notification) {
        self._observer.notify({ $0.didBecomeActive(self) })
    }
    
    @objc
    func _willResignActive(_ notification: Notification) {
        self._observer.notify({ $0.willResignActive(self) })
    }
    
    @objc
    func _willTerminate(_ notification: Notification) {
        self._observer.notify({ $0.willTerminate(self) })
    }
    
}
