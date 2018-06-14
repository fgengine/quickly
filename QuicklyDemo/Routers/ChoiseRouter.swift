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

    func presentPageViewController() {
        let vc = PageViewController(router: self, container: self.container)
        self.present(vc, animated: true)
    }

    func presentModalViewController() {
        let vc = ModalViewController(router: self, container: self.container)
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

extension ChoiseRouter : IPageViewControllerRouter {

    func dismiss(viewController: PageViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IModalViewControllerRouter {

    func presentConfirmModal() {
        if let parent = self.parent {
            let vc = ConfirmModalViewController(router: self, container: self.container)
            parent.presentModal(vc)
        }
    }

    func dismiss(viewController: ModalViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmModalViewControllerRouter {

    func dismiss(viewController: ConfirmModalViewController) {
        if let parent = self.parent {
            parent.dismissModal(viewController)
        }
    }

}

extension ChoiseRouter : IDialogViewControllerRouter {

    func presentConfirmDialog() {
        if let parent = self.parent {
            let vc = ConfirmDialogViewController(router: self, container: self.container)
            parent.presentDialog(vc)
        }
    }

    func dismiss(viewController: DialogViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmDialogViewControllerRouter {

    func dismiss(viewController: ConfirmDialogViewController) {
        if let parent = self.parent {
            parent.dismissDialog(viewController)
        }
    }

}

extension ChoiseRouter : IPushViewControllerRouter {

    func presentConfirmPush() {
        if let parent = self.parent {
            let vc = ConfirmPushViewController(router: self, container: self.container)
            parent.presentPush(vc, displayTime: 7)
        }
    }

    func dismiss(viewController: PushViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseRouter : IConfirmPushViewControllerRouter {

    func dismiss(viewController: ConfirmPushViewController) {
        if let parent = self.parent {
            parent.dismissPush(viewController)
        }
    }

}
