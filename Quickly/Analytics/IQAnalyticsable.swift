//
//  Quickly
//

import Foundation

public protocol IQAnalyticsable {

    associatedtype AnalyticsType

    var analytics: AnalyticsType { get }

}
