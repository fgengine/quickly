//
//  Quickly
//

public enum QDeviceFamily : Int {
    case unknown
    case iPhone
    case iPad
    case iPod
    case simulator
}

public enum QDeviceDisplaySize : Int {
    case unknown
    case iPad
    case iPad_10_5
    case iPad_12_9
    case iPhone_3_5
    case iPhone_4
    case iPhone_4_7
    case iPhone_5_5
    case iPhone_5_8
}

public extension UIDevice {
    
    public var identifier: String {
        get {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            return machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
    }
    
    public var family: QDeviceFamily {
        get {
            #if targetEnvironment(simulator)
            return .simulator
            #else
            let identifier = self.identifier
            if identifier.hasPrefix("iPhone") {
                return .iPhone
            } else if identifier.hasPrefix("iPad") {
                return .iPad
            } else if identifier.hasPrefix("iPod") {
                return .iPod
            }
            return .unknown
            #endif
        }
    }

    public var displaySize: QDeviceDisplaySize {
        get {
            let screenSize = UIScreen.main.bounds.integral.size
            let screenWidth = min(screenSize.width, screenSize.height)
            let screenHeight = max(screenSize.width, screenSize.height)
            switch self.userInterfaceIdiom {
            case .phone:
                if screenHeight >= 812 && screenWidth >= 375 {
                    return .iPhone_5_8
                } else if screenHeight >= 736 && screenWidth >= 414 {
                    return .iPhone_5_5
                } else if screenHeight >= 667 && screenWidth >= 375 {
                    return .iPhone_4_7
                } else if screenHeight >= 568 && screenWidth >= 320 {
                    return .iPhone_4
                } else if screenHeight >= 480 && screenWidth >= 320 {
                    return .iPhone_3_5
                }
            case .pad:
                if screenHeight >= 1366 && screenWidth >= 1024 {
                    return .iPad_10_5
                } else if screenHeight >= 1112 && screenWidth >= 834 {
                    return .iPad_10_5
                } else if screenHeight >= 1024 && screenWidth >= 768 {
                    return .iPad
                }
            default:
                return .unknown
            }
            return .unknown
        }
    }

}
