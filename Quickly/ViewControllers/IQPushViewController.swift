//
//  Quickly
//

public protocol IQPushViewController : IQBaseViewController {

    var pushContainerViewController: IQPushContainerViewController? { get }

}

public extension IQPushViewController where Self: QPlatformViewController {

    public func dismiss(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let pushContainerViewController: IQPushContainerViewController = self.pushContainerViewController else {
            return
        }
        pushContainerViewController.dismiss(pushViewController: self, animated: animated, completion: completion)
    }

}

public protocol IQPushContainerViewController : IQBaseViewController {

    typealias ViewControllerType = QPlatformViewController & IQPushViewController

    var pushViewControllers: [ViewControllerType] { get }

    func present(pushViewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(pushViewController: ViewControllerType, animated: Bool, completion: (() -> Swift.Void)?)

}
