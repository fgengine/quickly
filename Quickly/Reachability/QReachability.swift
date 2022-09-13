//
//  Quickly
//

import SystemConfiguration

public enum QReachabilityError : Error {
    case failedToCreateWithAddress(sockaddr_in)
    case failedToCreateWithHostname(String)
    case unableToSetCallback
    case unableToSetDispatchQueue
}

public enum QReachabilityConnection {
    case none
    case wifi
    case cellular
}

public protocol QReachabilityObserver {

    func reachability(_ reachability: QReachability, connection: QReachabilityConnection)

}

public final class QReachability {

    public var allowsCellularConnection: Bool
    public private(set) var isRunning: Bool
    public var connection: QReachabilityConnection {
        get {
            guard self._isReachableFlagSet() else { return .none }
            guard self._isRunningOnDevice() else { return .wifi }
            var connection: QReachabilityConnection = .none
            if self._isConnectionRequiredFlagSet() == true {
                connection = .wifi
            }
            if self._isConnectionOnTrafficOrDemandFlagSet() == true {
                if self._isInterventionRequiredFlagSet() == false {
                    connection = .wifi
                }
            }
            if self._isOnWWANFlagSet() == true {
                if self.allowsCellularConnection == false {
                    connection = .none
                } else {
                    connection = .cellular
                }
            }
            return connection
        }
    }
    public var description: String {
        get {
            let W = self._isRunningOnDevice() ? (self._isOnWWANFlagSet() ? "W" : "-") : "X"
            let R = self._isReachableFlagSet() ? "R" : "-"
            let c = self._isConnectionRequiredFlagSet() ? "c" : "-"
            let t = self._isTransientConnectionFlagSet() ? "t" : "-"
            let i = self._isInterventionRequiredFlagSet() ? "i" : "-"
            let C = self._isConnectionOnTrafficFlagSet() ? "C" : "-"
            let D = self._isConnectionOnDemandFlagSet() ? "D" : "-"
            let l = self._isLocalAddressFlagSet() ? "l" : "-"
            let d = self._isDirectFlagSet() ? "d" : "-"
            return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
        }
    }

    private var _observer: QObserver< QReachabilityObserver >
    private var _reachability: SCNetworkReachability
    private var _currentFlags: SCNetworkReachabilityFlags
    private var _previousFlags: SCNetworkReachabilityFlags?
    private var _queue: DispatchQueue
    
    public required init(reachability: SCNetworkReachability) {
        self.allowsCellularConnection = true
        self.isRunning = false
        self._observer = QObserver< QReachabilityObserver >()
        self._reachability = reachability
        self._currentFlags = SCNetworkReachabilityFlags()
        self._queue = DispatchQueue(label: "org.fgengine.quickly.reachability")
    }
    
    public convenience init?(hostname: String) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else { return nil }
        self.init(reachability: ref)
    }
    
    public convenience init?() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout< sockaddr >.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        guard let ref = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return nil }
        self.init(reachability: ref)
    }
    
    deinit {
        self.stop()
    }

    public func add(observer: QReachabilityObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    public func remove(observer: QReachabilityObserver) {
        self._observer.remove(observer)
    }

    public func start() throws {
        guard self.isRunning == false else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged< QReachability >.passUnretained(self).toOpaque())
        if SCNetworkReachabilitySetCallback(self._reachability, QReachabilityCallback, &context) == false {
            self.stop()
            throw QReachabilityError.unableToSetCallback
        }
        if SCNetworkReachabilitySetDispatchQueue(self._reachability, self._queue) == false {
            self.stop()
            throw QReachabilityError.unableToSetDispatchQueue
        }
        self._queue.async {
            self._changed()
        }
        self.isRunning = true
    }

    public func stop() {
        SCNetworkReachabilitySetCallback(self._reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(self._reachability, nil)
        self.isRunning = false
    }
    
}

// MARK: Private

private extension QReachability {

    func _isRunningOnDevice() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }

    func _isOnWWANFlagSet() -> Bool {
        #if os(iOS)
            return self._currentFlags.contains(.isWWAN)
        #else
            return false
        #endif
    }

    func _isReachableFlagSet() -> Bool {
        return self._currentFlags.contains(.reachable)
    }

    func _isConnectionRequiredFlagSet() -> Bool {
        return self._currentFlags.contains(.connectionRequired)
    }

    func _isInterventionRequiredFlagSet() -> Bool {
        return self._currentFlags.contains(.interventionRequired)
    }

    func _isConnectionOnTrafficFlagSet() -> Bool {
        return self._currentFlags.contains(.connectionOnTraffic)
    }

    func _isConnectionOnDemandFlagSet() -> Bool {
        return self._currentFlags.contains(.connectionOnDemand)
    }

    func _isConnectionOnTrafficOrDemandFlagSet() -> Bool {
        return self._currentFlags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty == false
    }

    func _isTransientConnectionFlagSet() -> Bool {
        return self._currentFlags.contains(.transientConnection)
    }

    func _isLocalAddressFlagSet() -> Bool {
        return self._currentFlags.contains(.isLocalAddress)
    }

    func _isDirectFlagSet() -> Bool {
        return self._currentFlags.contains(.isDirect)
    }

    func _isConnectionRequiredAndTransientFlagSet() -> Bool {
        return self._currentFlags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
        
}

// MARK: Fileprivate

fileprivate extension QReachability {

    func _changed() {
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(self._reachability, &flags) == true {
            if self._previousFlags != flags {
                self._previousFlags = self._currentFlags
                self._currentFlags = flags

                DispatchQueue.main.async {
                    self._observer.notify({ (observer: QReachabilityObserver) in
                        observer.reachability(self, connection: self.connection)
                    })
                }
            }
        }
    }
    
}

private func QReachabilityCallback(
    reachability:SCNetworkReachability,
    flags: SCNetworkReachabilityFlags,
    info: UnsafeMutableRawPointer?
) {
    guard let info = info else { return }
    let reachability = Unmanaged< QReachability >.fromOpaque(info).takeUnretainedValue()
    reachability._changed()
}

