//
//  Quickly
//

public protocol IQRoutable {

    associatedtype RoutePathType
    associatedtype RouteContextType

    var routePath: RoutePathType { get }
    var routeContext: RouteContextType { get }

}
