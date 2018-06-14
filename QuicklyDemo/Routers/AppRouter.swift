//
//  Quickly
//

import Quickly

class AppRouter: QAppRouter<
    AppContainer
> {

    override init(container: AppContainer) {
        super.init(container: container)

        let modalContainerViewController = QModalContainerViewController()
        self.mainViewController.modalContainerViewController = modalContainerViewController

        let dialogContainerViewController = QDialogContainerViewController()
        dialogContainerViewController.backgroundView = QDialogBackgroundView(backgroundColor: UIColor(white: 0, alpha: 0.9))
        self.mainViewController.dialogContainerViewController = dialogContainerViewController

        let pushContainerViewController = QPushContainerViewController()
        self.mainViewController.pushContainerViewController = pushContainerViewController
    }

    override func launch(_ options: [UIApplicationLaunchOptionsKey : Any]?) {
        self.presentChoise()
    }

    func presentChoise() {
        self.currentRouter = ChoiseRouter(container: self.container, parent: self)
    }

    func presentModal(_ viewController: IQModalContentViewController) {
        let pushViewController = QModalViewController(contentViewController: viewController)
        self.mainViewController.modalContainerViewController!.presentModal(viewController: pushViewController, animated: true, completion: nil)
    }

    func dismissModal(_ viewController: IQModalContentViewController) {
        viewController.modalViewController?.dismissModal(animated: true, completion: nil)
    }

    func presentDialog(_ viewController: IQDialogContentViewController) {
        let dialogViewController = QDialogViewController(contentViewController: viewController)
        dialogViewController.dialogWidthBehaviour = .fit(min: 160, max: 300)
        dialogViewController.dialogHeightBehaviour = .fit(min: 240, max: 480)
        self.mainViewController.dialogContainerViewController!.presentDialog(viewController: dialogViewController, animated: true, completion: nil)
    }

    func dismissDialog(_ viewController: IQDialogContentViewController) {
        viewController.dialogViewController?.dismissDialog(animated: true, completion: nil)
    }

    func presentPush(_ viewController: IQPushContentViewController, displayTime: TimeInterval?) {
        let pushViewController = QPushViewController(contentViewController: viewController, displayTime: displayTime)
        self.mainViewController.pushContainerViewController!.presentPush(viewController: pushViewController, animated: true, completion: nil)
    }

    func dismissPush(_ viewController: IQPushContentViewController) {
        viewController.pushViewController?.dismissPush(animated: true, completion: nil)
    }

}
