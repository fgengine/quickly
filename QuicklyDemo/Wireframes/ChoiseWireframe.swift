//
//  Quickly
//

import Quickly

class ChoiseWireframe: QStackWireframe<
    AppRouteContext,
    AppWireframe
> {

    override func prepareRootContentViewController() -> IQStackContentViewController {
        return ChoiseViewController(self, self.routeContext)
    }

}

extension ChoiseWireframe : IChoiseViewControllerRoutePath {

    func presentLabelViewController() {
        let vc = LabelViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentButtonViewController() {
        let vc = ButtonViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentTextFieldViewController() {
        let vc = TextFieldViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentListFieldViewController() {
        let vc = ListFieldViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentDateFieldViewController() {
        let vc = DateFieldViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentImageViewController() {
        let vc = ImageViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentPageViewController() {
        let vc = PageViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentModalViewController() {
        let vc = ModalViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentDialogViewController() {
        let vc = DialogViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

    func presentPushViewController() {
        let vc = PushViewController(self, self.routeContext)
        self.present(vc, animated: true)
    }

}

extension ChoiseWireframe : ILabelViewControllerRoutePath {

    func dismiss(viewController: LabelViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IButtonViewControllerRoutePath {

    func dismiss(viewController: ButtonViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : ITextFieldViewControllerRoutePath {

    func dismiss(viewController: TextFieldViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IListFieldViewControllerRoutePath {

    func dismiss(viewController: ListFieldViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IDateFieldViewControllerRoutePath {

    func dismiss(viewController: DateFieldViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IImageViewControllerRoutePath {

    func dismiss(viewController: ImageViewController) {
        self.dismiss(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IPageViewControllerRoutePath {

    func dismiss(viewController: PageViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IModalViewControllerRoutePath {

    func presentConfirmModal() {
        if let wireframe = self.parentWireframe {
            let vc = ConfirmModalViewController(self, self.routeContext)
            wireframe.presentModal(vc)
        }
    }

    func dismiss(viewController: ModalViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmModalViewControllerRoutePath {

    func dismiss(viewController: ConfirmModalViewController) {
        if let wireframe = self.parentWireframe {
            wireframe.dismissModal(viewController)
        }
    }

}

extension ChoiseWireframe : IDialogViewControllerRoutePath {

    func presentConfirmDialog() {
        if let wireframe = self.parentWireframe {
            let vc = ConfirmDialogViewController(self, self.routeContext)
            wireframe.presentDialog(vc)
        }
    }

    func dismiss(viewController: DialogViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmDialogViewControllerRoutePath {

    func dismiss(viewController: ConfirmDialogViewController) {
        if let wireframe = self.parentWireframe {
            wireframe.dismissDialog(viewController)
        }
    }

}

extension ChoiseWireframe : IPushViewControllerRoutePath {

    func presentConfirmPush() {
        if let wireframe = self.parentWireframe {
            let vc = ConfirmPushViewController(self, self.routeContext)
            wireframe.presentPush(vc, displayTime: 7)
        }
    }

    func dismiss(viewController: PushViewController) {
        self.dismiss(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmPushViewControllerRoutePath {

    func dismiss(viewController: ConfirmPushViewController) {
        if let wireframe = self.parentWireframe {
            wireframe.dismissPush(viewController)
        }
    }

}
