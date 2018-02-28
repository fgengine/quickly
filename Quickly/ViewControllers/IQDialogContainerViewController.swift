//
//  Quickly
//

public protocol IQDialogContainerViewController : class {

    var dialogViewControllers: [IQDialogViewController] { get }

    func present(dialogViewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)
    func dismiss(dialogViewController: IQDialogViewController, animated: Bool, completion: (() -> Swift.Void)?)

}
