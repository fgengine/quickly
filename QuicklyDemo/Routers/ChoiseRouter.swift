//
//  Quickly
//

import Quickly

class ChoiseRouter: QStackRouter<
    AppContainer,
    AppRouter
> {

    override func prepareRootViewController() -> IQStackContentViewController {
        let vc = ChoiseViewController(router: self, container: self.container)
        return vc
    }

}

extension ChoiseRouter : IChoiseViewControllerRouter {

    func presentLabelViewController() {
        let vc = LabelViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentButtonViewController() {
        let vc = ButtonViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentTextFieldViewController() {
        let vc = TextFieldViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentListFieldViewController() {
        let vc = ListFieldViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentDateFieldViewController() {
        let vc = DateFieldViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentImageViewController() {
        let vc = ImageViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentDialogViewController() {
        let vc = DialogViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentPushViewController() {
        let vc = PushViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

}

extension ChoiseRouter : ILabelViewControllerRouter {

    func dismiss(viewController: LabelViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IButtonViewControllerRouter {

    func dismiss(viewController: ButtonViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseRouter : ITextFieldViewControllerRouter {

    func dismiss(viewController: TextFieldViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseRouter : IListFieldViewControllerRouter {

    func dismiss(viewController: ListFieldViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IDateFieldViewControllerRouter {

    func dismiss(viewController: DateFieldViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IImageViewControllerRouter {

    func dismiss(viewController: ImageViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseRouter : IDialogViewControllerRouter {

    func presentConfirmDialog() {
        if let router = self.router {
            let vc = ConfirmDialogViewController(router: self, container: self.container)
            router.presentDialog(vc)
        }
    }

    func dismiss(viewController: DialogViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmDialogViewControllerRouter {

    func dismiss(viewController: ConfirmDialogViewController) {
        if let router = self.router {
            router.dismissDialog(viewController)
        }
    }

}

extension ChoiseRouter : IPushViewControllerRouter {

    func presentConfirmPush() {
        if let router = self.router {
            let vc = ConfirmPushViewController(router: self, container: self.container)
            router.presentPush(vc, displayTime: 7)
        }
    }

    func dismiss(viewController: PushViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmPushViewControllerRouter {

    func dismiss(viewController: ConfirmPushViewController) {
        if let router = self.router {
            router.dismissPush(viewController)
        }
    }

}
