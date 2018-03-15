//
//  Quickly
//

import Quickly

class ChoiseRouter: QNavigationRouter<
    AppContainer,
    AppRouter
> {

    public override func prepareRootViewController() -> UIViewController {
        let vc: ChoiseViewController = ChoiseViewController(router: self, container: self.container)
        return vc
    }

}

extension ChoiseRouter: IChoiseViewControllerRouter {

    public func presentLabelViewController() {
        let vc: LabelViewController = LabelViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentButtonViewController() {
        let vc: ButtonViewController = ButtonViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentTextFieldViewController() {
        let vc: TextFieldViewController = TextFieldViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentImageViewController() {
        let vc: ImageViewController = ImageViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentDialogViewController() {
        let vc: DialogViewController = DialogViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentPushViewController() {
        let vc: PushViewController = PushViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

}

extension ChoiseRouter: ILabelViewControllerRouter {

    public func dismiss(viewController: LabelViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter: IButtonViewControllerRouter {

    public func dismiss(viewController: ButtonViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter: ITextFieldViewControllerRouter {

    public func dismiss(viewController: TextFieldViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter: IImageViewControllerRouter {

    public func dismiss(viewController: ImageViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter: IDialogViewControllerRouter {

    public func presentConfirmDialog() {
        if let router: AppRouter = self.router {
            let vc: ConfirmDialogViewController = ConfirmDialogViewController(router: self, container: self.container)
            router.presentDialog(vc)
        }
    }

    public func dismiss(viewController: DialogViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter: IConfirmDialogViewControllerRouter {

    public func dismiss(viewController: ConfirmDialogViewController) {
        if let router: AppRouter = self.router {
            router.dismissDialog(viewController)
        }
    }

}

extension ChoiseRouter: IPushViewControllerRouter {

    public func presentConfirmPush() {
        if let router: AppRouter = self.router {
            let vc: ConfirmPushViewController = ConfirmPushViewController(router: self, container: self.container)
            router.presentPush(vc, displayTime: 7)
        }
    }

    public func dismiss(viewController: PushViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter: IConfirmPushViewControllerRouter {

    public func dismiss(viewController: ConfirmPushViewController) {
        if let router: AppRouter = self.router {
            router.dismissPush(viewController)
        }
    }

}
