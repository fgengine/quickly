//
//  Quickly
//

import Quickly

class AppRouter: QAppRouter<
    AppContainer
> {

    public override init(container: AppContainer) {
        super.init(container: container)

        self.mainViewController.dialogContainerViewController = QDialogContainerViewController()
    }

    public func presentChoise() {
        self.currentRouter = ChoiseRouter(container: self.container, router: self)
    }

    public func presentDialog(_ viewController: IQDialogViewController.ContentViewControllerType) {
        let dialogViewController: QDialogViewController = QDialogViewController(contentViewController: viewController)
        dialogViewController.contentWidthBehaviour = .fit(min: 160, max: 300)
        dialogViewController.contentHeightBehaviour = .fit(min: 240, max: 480)
        self.mainViewController.dialogContainerViewController!.presentDialog(viewController: dialogViewController, animated: true, completion: nil)
    }

    public func dismissDialog(_ viewController: IQDialogViewController.ContentViewControllerType) {
        guard let dialogViewController: IQDialogContentViewController.DialogViewControllerType = viewController.dialogViewController else {
            return
        }
        dialogViewController.dismissDialog(animated: true, completion: nil)
    }

}
