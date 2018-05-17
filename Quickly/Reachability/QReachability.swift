//
//  Quickly
//

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

public class QReachability {

    public var allowsCellularConnection: Bool
    public private(set) var isRunning: Bool
    public var connection: QReachabilityConnection {
        get {
            guard self.isReachableFlagSet() else { return .none }
            guard self.isRunningOnDevice() else { return .wifi }
            var connection: QReachabilityConnection = .none
            if self.isConnectionRequiredFlagSet() == true {
                connection = .wifi
            }
            if self.isConnectionOnTrafficOrDemandFlagSet() == true {
                if self.isInterventionRequiredFlagSet() == false {
                    connection = .wifi
                }
            }
            if self.isOnWWANFlagSet() == true {
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
            let W = self.isRunningOnDevice() ? (self.isOnWWANFlagSet() ? "W" : "-") : "X"
            let R = self.isReachableFlagSet() ? "R" : "-"
            let c = self.isConnectionRequiredFlagSet() ? "c" : "-"
            let t = self.isTransientConnectionFlagSet() ? "t" : "-"
            let i = self.isInterventionRequiredFlagSet() ? "i" : "-"
            let C = self.isConnectionOnTrafficFlagSet() ? "C" : "-"
            let D = self.isConnectionOnDemandFlagSet() ? "D" : "-"
            let l = self.isLocalAddressFlagSet() ? "l" : "-"
            let d = self.isDirectFlagSet() ? "d" : "-"
            return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
        }
    }

    private var observer: QObserver< QReachabilityObserver >
    private var reachability: SCNetworkReachability
    private var currentFlags: SCNetworkReachabilityFlags
    private var previousFlags: SCNetworkReachabilityFlags?
    private var queue: DispatchQueue
    
    public required init(reachability: SCNetworkReachability) {
        self.allowsCellularConnection = true
        self.isRunning = false
        self.observer = QObserver< QReachabilityObserver >()
        self.reachability = reachability
        self.currentFlags = SCNetworkReachabilityFlags()
        self.queue = DispatchQueue(label: "org.fgengine.quickly.reachability")
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

    public func addObserver(_ observer: QReachabilityObserver, priority: UInt) {
        self.observer.add(observer, priority: priority)
    }

    public func removeObserver(_ observer: QReachabilityObserver) {
        self.observer.remove(observer)
    }

    public func start() throws {
        guard self.isRunning == false else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged< QReachability >.passUnretained(self).toOpaque())
        if SCNetworkReachabilitySetCallback(self.reachability, QReachabilityCallback, &context) == false {
            self.stop()
            throw QReachabilityError.unableToSetCallback
        }
        if SCNetworkReachabilitySetDispatchQueue(self.reachability, self.queue) == false {
            self.stop()
            throw QReachabilityError.unableToSetDispatchQueue
        }
        self.queue.async {
            self.changed()
        }
        self.isRunning = true
    }

    public func stop() {
        SCNetworkReachabilitySetCallback(self.reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(self.reachability, nil)
        self.isRunning = false
    }

    private func isRunningOnDevice() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }

    private func isOnWWANFlagSet() -> Bool {
        #if os(iOS)
            return self.currentFlags.contains(.isWWAN)
        #else
            return false
        #endif
    }

    private func isReachableFlagSet() -> Bool {
        return self.currentFlags.contains(.reachable)
    }

    private func isConnectionRequiredFlagSet() -> Bool {
        return self.currentFlags.contains(.connectionRequired)
    }

    private func isInterventionRequiredFlagSet() -> Bool {
        return self.currentFlags.contains(.interventionRequired)
    }

    private func isConnectionOnTrafficFlagSet() -> Bool {
        return self.currentFlags.contains(.connectionOnTraffic)
    }

    private func isConnectionOnDemandFlagSet() -> Bool {
        return self.currentFlags.contains(.connectionOnDemand)
    }

    private func isConnectionOnTrafficOrDemandFlagSet() -> Bool {
        return self.currentFlags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty == false
    }

    private func isTransientConnectionFlagSet() -> Bool {
        return self.currentFlags.contains(.transientConnection)
    }

    private func isLocalAddressFlagSet() -> Bool {
        return self.currentFlags.contains(.isLocalAddress)
    }

    private func isDirectFlagSet() -> Bool {
        return self.currentFlags.contains(.isDirect)
    }

    private func isConnectionRequiredAndTransientFlagSet() -> Bool {
        return self.currentFlags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }

    fileprivate func changed() {
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(self.reachability, &flags) == true {
            if self.previousFlags != flags {
                self.previousFlags = self.currentFlags
                self.currentFlags = flags

                DispatchQueue.main.async {
                    self.observer.notify({ (observer: QReachabilityObserver) in
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
    reachability.changed()
}

