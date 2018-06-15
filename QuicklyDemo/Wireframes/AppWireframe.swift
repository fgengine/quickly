//
//  Quickly
//

import Quickly

class AppWireframe: QAppWireframe< AppRouteContext > {

    override init(_ routeContext: AppRouteContext) {
        super.init(routeContext)
    }

    override func launch(_ options: [UIApplicationLaunchOptionsKey : Any]?) {
        self.presentChoise()
    }

    func presentChoise() {
        self.currentWireframe = ChoiseWireframe(self.routeContext, self)
    }

    func presentModal(_ viewController: IQModalContentViewController) {
        let pushViewController = QModalViewController(contentViewController: viewController)
        self.modalContainerViewController!.presentModal(viewController: pushViewController, animated: true, completion: nil)
    }

    func dismissModal(_ viewController: IQModalContentViewController) {
        viewController.modalViewController?.dismissModal(animated: true, completion: nil)
    }

    func presentDialog(_ viewController: IQDialogContentViewController) {
        let dialogViewController = QDialogViewController(contentViewController: viewController)
        dialogViewController.dialogWidthBehaviour = .fit(min: 160, max: 300)
        dialogViewController.dialogHeightBehaviour = .fit(min: 240, max: 480)
        self.dialogContainerViewController!.presentDialog(viewController: dialogViewController, animated: true, completion: nil)
    }

    func dismissDialog(_ viewController: IQDialogContentViewController) {
        viewController.dialogViewController?.dismissDialog(animated: true, completion: nil)
    }

    func presentPush(_ viewController: IQPushContentViewController, displayTime: TimeInterval?) {
        let pushViewController = QPushViewController(contentViewController: viewController, displayTime: displayTime)
        self.pushContainerViewController!.presentPush(viewController: pushViewController, animated: true, completion: nil)
    }

    func dismissPush(_ viewController: IQPushContentViewController) {
        viewController.pushViewController?.dismissPush(animated: true, completion: nil)
    }

}
