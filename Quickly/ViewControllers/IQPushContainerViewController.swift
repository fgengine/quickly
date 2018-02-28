//
//  Quickly
//

public protocol IQPushContainerViewController : class {

    var pushViewControllers: [IQPushViewController] { get }

    func present(pushViewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(pushViewController: IQPushViewController, animated: Bool, completion: (() -> Swift.Void)?)

}
