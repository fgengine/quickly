//
//  Quickly
//

import Quickly

class ChoiseRouter: QStackRouter<
    AppRouter,
    AppContainer
> {

    public override func prepareRootViewController() -> UIViewController {
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

extension ChoiseRouter: IButtonViewControllerRouter {

    func presentButtonViewController() {
        let vc: ButtonViewController = ButtonViewController()
        vc.router = self
        self.stackViewController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: ButtonViewController) {
        _ = self.stackViewController.popViewController(animated: true)
    }
    
}

extension ChoiseRouter: ITextFieldViewControllerRouter {

    func presentTextFieldViewController() {
        let vc: TextFieldViewController = TextFieldViewController()
        vc.router = self
        self.stackViewController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: TextFieldViewController) {
        _ = self.stackViewController.popViewController(animated: true)
    }
    
}
