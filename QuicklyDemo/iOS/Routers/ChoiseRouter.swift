//
//  Quickly
//

import Quickly

class ChoiseRouter: QNavigationRouter<
    AppContainer,
    AppRouter
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
        self.navigationController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: LabelViewController) {
        _ = self.navigationController.popViewController(animated: true)
    }

}

extension ChoiseRouter: IButtonViewControllerRouter {

    func presentButtonViewController() {
        let vc: ButtonViewController = ButtonViewController()
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: ButtonViewController) {
        _ = self.navigationController.popViewController(animated: true)
    }
    
}

extension ChoiseRouter: ITextFieldViewControllerRouter {

    func presentTextFieldViewController() {
        let vc: TextFieldViewController = TextFieldViewController()
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: TextFieldViewController) {
        _ = self.navigationController.popViewController(animated: true)
    }
    
}

extension ChoiseRouter: IImageViewControllerRouter {

    func presentImageViewController() {
        let vc: ImageViewController = ImageViewController()
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func dismiss(viewController: ImageViewController) {
        _ = self.navigationController.popViewController(animated: true)
    }
    
}
