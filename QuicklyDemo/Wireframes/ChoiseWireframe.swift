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
        self.presentStack(vc, animated: true)
    }

    func presentButtonViewController() {
        let vc = ButtonViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentTextFieldViewController() {
        let vc = TextFieldViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentListFieldViewController() {
        let vc = ListFieldViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentDateFieldViewController() {
        let vc = DateFieldViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentImageViewController() {
        let vc = ImageViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentPageViewController() {
        let vc = PageViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentModalViewController() {
        let vc = ModalViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentDialogViewController() {
        let vc = DialogViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

    func presentPushViewController() {
        let vc = PushViewController(self, self.routeContext)
        self.presentStack(vc, animated: true)
    }

}

extension ChoiseWireframe : ILabelViewControllerRoutePath {

    func dismiss(viewController: LabelViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IButtonViewControllerRoutePath {

    func dismiss(viewController: ButtonViewController) {
        self.dismissStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : ITextFieldViewControllerRoutePath {

    func dismiss(viewController: TextFieldViewController) {
        self.dismissStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IListFieldViewControllerRoutePath {

    func dismiss(viewController: ListFieldViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IDateFieldViewControllerRoutePath {

    func dismiss(viewController: DateFieldViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IImageViewControllerRoutePath {

    func dismiss(viewController: ImageViewController) {
        self.dismissStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IPageViewControllerRoutePath {

    func dismiss(viewController: PageViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IModalViewControllerRoutePath {

    func presentConfirmModal() {
        if let wireframe = self.parentWireframe {
            let contentViewController = ConfirmModalViewController(self, self.routeContext)
            let modalViewController = QModalViewController(contentViewController)
            wireframe.presentModal(modalViewController, animated: true, completion: nil)
        }
    }

    func dismiss(viewController: ModalViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmModalViewControllerRoutePath {

    func dismiss(viewController: ConfirmModalViewController) {
        guard let modalViewController = viewController.modalViewController else { return }
        self.dismissModal(modalViewController, animated: true, completion: nil)
    }

}

extension ChoiseWireframe : IDialogViewControllerRoutePath {

    func presentConfirmDialog() {
        if let wireframe = self.parentWireframe {
            let contentViewController = ConfirmDialogViewController(self, self.routeContext)
            let dialogViewController = QDialogViewController(
                contentViewController,
                widthBehaviour: .fit(min: 160, max: 300),
                heightBehaviour: .fit(min: 240, max: 480)
            )
            wireframe.presentDialog(dialogViewController, animated: true, completion: nil)
        }
    }

    func dismiss(viewController: DialogViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmDialogViewControllerRoutePath {

    func dismiss(viewController: ConfirmDialogViewController) {
        guard let dialogViewController = viewController.dialogViewController else { return }
        self.dismissDialog(dialogViewController, animated: true, completion: nil)
    }

}

extension ChoiseWireframe : IPushViewControllerRoutePath {

    func presentConfirmPush() {
        if let wireframe = self.parentWireframe {
            let contentViewController = ConfirmPushViewController(self, self.routeContext)
            let pushViewController = QPushViewController(contentViewController, displayTime: 7)
            wireframe.presentPush(pushViewController, animated: true, completion: nil)
        }
    }

    func dismiss(viewController: PushViewController) {
        self.dismissStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmPushViewControllerRoutePath {

    func dismiss(viewController: ConfirmPushViewController) {
        guard let pushViewController = viewController.pushViewController else { return }
        self.dismissPush(pushViewController, animated: true, completion: nil)
    }

}
