//
//  Quickly
//

public protocol IQViewControllerRouter: IQRouter {

    typealias ViewControllerType = QPlatformViewController & IQBaseViewController

    var viewController: ViewControllerType { get }
    
}
