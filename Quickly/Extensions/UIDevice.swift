//
//  Quickly
//

import UIKit

public enum QDeviceDisplaySize : Int {
    case unknown
    case iPad
    case iPad_10_5
    case iPad_12_9
    case iPhone_3_5
    case iPhone_4
    case iPhone_4_7
    case iPhone_5_5
}

public extension UIDevice {

    public var displaySize: QDeviceDisplaySize {
        get {
            let screenSize: CGSize = UIScreen.main.bounds.integral.size
            let screenWidth: CGFloat = max(screenSize.width, screenSize.height)
            let screenHeight: CGFloat = min(screenSize.width, screenSize.height)
            switch self.userInterfaceIdiom {
            case .phone:
                if screenWidth >= 736 && screenHeight >= 414 {
                    return .iPhone_5_5
                } else if screenWidth >= 667 && screenHeight >= 375 {
                    return .iPhone_4_7
                } else if screenWidth >= 568 && screenHeight >= 320 {
                    return .iPhone_4
                } else if screenWidth >= 480 && screenHeight >= 320 {
                    return .iPhone_4
                }
            case .pad:
                if screenWidth >= 1366 && screenHeight >= 1024 {
                    return .iPad_10_5
                } else if screenWidth >= 1112 && screenHeight >= 834 {
                    return .iPad_10_5
                } else if screenWidth >= 1024 && screenHeight >= 768 {
                    return .iPad
                }
            default:
                return .unknown
            }
            return .unknown
        }
    }

}
