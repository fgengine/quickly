//
//  Quickly
//

public protocol IQPushViewController : IQBaseViewController {

    var pushContainerViewController: IQPushContainerViewController? { get }

}

public extension IQPushViewController {

    public func dismiss(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let pushContainerViewController: IQPushContainerViewController = self.pushContainerViewController else {
            return
        }
        pushContainerViewController.dismiss(pushViewController: self, animated: animated, completion: completion)
    }

}
