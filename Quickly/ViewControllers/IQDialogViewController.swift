//
//  Quickly
//

public protocol IQDialogViewController : IQBaseViewController {

    var dialogContainerViewController: IQDialogContainerViewController? { get }

}

public extension IQDialogViewController {

    public func dismiss(animated: Bool, completion: (() -> Swift.Void)?) {
        guard let dialogContainerViewController: IQDialogContainerViewController = self.dialogContainerViewController else {
            return
        }
        dialogContainerViewController.dismiss(dialogViewController: self, animated: animated, completion: completion)
    }

}
