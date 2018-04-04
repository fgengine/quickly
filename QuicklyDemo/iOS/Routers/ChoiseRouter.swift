//
//  Quickly
//

import Quickly

class ChoiseRouter: QNavigationRouter<
    AppContainer,
    AppRouter
> {

    public override func prepareRootViewController() -> UIViewController {
        let vc = ChoiseViewController(router: self, container: self.container)
        return vc
    }

}

extension ChoiseRouter : IChoiseViewControllerRouter {

    public func presentLabelViewController() {
        let vc = LabelViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentButtonViewController() {
        let vc = ButtonViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentTextFieldViewController() {
        let vc = TextFieldViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentListFieldViewController() {
        let vc = ListFieldViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentDateFieldViewController() {
        let vc = DateFieldViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentImageViewController() {
        let vc = ImageViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentDialogViewController() {
        let vc = DialogViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

    public func presentPushViewController() {
        let vc = PushViewController(router: self, container: self.container)
        self.navigationController.pushViewController(vc, animated: true)
    }

}

extension ChoiseRouter : ILabelViewControllerRouter {

    public func dismiss(viewController: LabelViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter : IButtonViewControllerRouter {

    public func dismiss(viewController: ButtonViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter : ITextFieldViewControllerRouter {

    public func dismiss(viewController: TextFieldViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter : IListFieldViewControllerRouter {

    public func dismiss(viewController: ListFieldViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter : IDateFieldViewControllerRouter {

    public func dismiss(viewController: DateFieldViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter : IImageViewControllerRouter {

    public func dismiss(viewController: ImageViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }
    
}

extension ChoiseRouter : IDialogViewControllerRouter {

    public func presentConfirmDialog() {
        if let router = self.router {
            let vc = ConfirmDialogViewController(router: self, container: self.container)
            router.presentDialog(vc)
        }
    }

    public func dismiss(viewController: DialogViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmDialogViewControllerRouter {

    public func dismiss(viewController: ConfirmDialogViewController) {
        if let router = self.router {
            router.dismissDialog(viewController)
        }
    }

}

extension ChoiseRouter : IPushViewControllerRouter {

    public func presentConfirmPush() {
        if let router = self.router {
            let vc = ConfirmPushViewController(router: self, container: self.container)
            router.presentPush(vc, displayTime: 7)
        }
    }

    public func dismiss(viewController: PushViewController) {
        self.navigationController.removeViewController(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmPushViewControllerRouter {

    public func dismiss(viewController: ConfirmPushViewController) {
        if let router = self.router {
            router.dismissPush(viewController)
        }
    }

}
