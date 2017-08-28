//
//  Quickly
//

import Quickly

class ChoiseRouter: QStackRouter<
    AppRouter,
    AppContainer,
    ChoiseViewController
> {

    internal override func prepareRootViewController() -> ChoiseViewController {
        let vc: ChoiseViewController = ChoiseViewController()
        vc.router = self
        return vc
    }

}

extension ChoiseRouter: ILabelViewControllerRouter {

    func presentLabelViewController() {
        let vc: LabelViewController = LabelViewController()
        vc.router = self
        self.stackViewController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: LabelViewController) {
        _ = self.stackViewController.popViewController(animated: true)
    }

}
