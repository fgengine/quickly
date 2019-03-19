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
        self._start()
    }
    
    deinit {
        self._stop()
    }
    
    public func add(observer: IQApplicationStateObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }
    
    public func remove(observer: IQApplicationStateObserver) {
        self._observer.remove(observer)
    }
    
    private func _start() {
        NotificationCenter.default.addObserver(self, selector: #selector(self._didReceiveMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didFinishLaunching(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func _stop() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
}

extension QApplicationState {
    
    @objc
    private func _didReceiveMemoryWarning(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.didReceiveMemoryWarning(self)
        })
    }
    
    @objc
    private func _didFinishLaunching(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.didFinishLaunching(self)
        })
    }
    
    @objc
    private func _didEnterBackground(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.didEnterBackground(self)
        })
    }
    
    @objc
    private func _willEnterForeground(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.willEnterForeground(self)
        })
    }
    
    @objc
    private func _didBecomeActive(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.didBecomeActive(self)
        })
    }
    
    @objc
    private func _willResignActive(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.willResignActive(self)
        })
    }
    
    @objc
    private func _willTerminate(_ notification: Notification) {
        self._observer.notify({ (observer: IQApplicationStateObserver) in
            observer.willTerminate(self)
        })
    }
    
}
