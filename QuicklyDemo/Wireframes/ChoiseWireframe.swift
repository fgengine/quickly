//
//  Quickly
//

import Quickly

class ChoiseWireframe: QStackWireframe<
    AppContext,
    AppWireframe
> {
    
    override func setup() {
        self.viewController.viewControllers = [
            QStackViewController(ChoiseViewController(router: self, context: self.context))
        ]
    }

}

extension ChoiseWireframe : IChoiseViewControllerRouter {

    func presentLabelViewController() {
        let vc = LabelViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentButtonViewController() {
        let vc = ButtonViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentTextFieldViewController() {
        let vc = TextFieldViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentListFieldViewController() {
        let vc = ListFieldViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentDateFieldViewController() {
        let vc = DateFieldViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentImageViewController() {
        let vc = ImageViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }
    
    func presentTableViewController() {
        let vc = TableViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentPageViewController() {
        let vc = PageViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentModalViewController() {
        let vc = ModalViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentDialogViewController() {
        let vc = DialogViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

    func presentPushViewController() {
        let vc = PushViewController(router: self, context: self.context)
        self.pushStack(vc, animated: true)
    }

}

extension ChoiseWireframe : ILabelViewControllerRouter {

    func dismiss(viewController: LabelViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IButtonViewControllerRouter {

    func dismiss(viewController: ButtonViewController) {
        self.popStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : ITextFieldViewControllerRouter {

    func dismiss(viewController: TextFieldViewController) {
        self.popStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IListFieldViewControllerRouter {

    func dismiss(viewController: ListFieldViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IDateFieldViewControllerRouter {

    func dismiss(viewController: DateFieldViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IImageViewControllerRouter {

    func dismiss(viewController: ImageViewController) {
        self.popStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : ITableViewControllerRouter {
    
    func dismiss(viewController: TableViewController) {
        self.popStack(viewController, animated: true)
    }
    
}

extension ChoiseWireframe : IPageViewControllerRouter {

    func dismiss(viewController: PageViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IModalViewControllerRouter {

    func presentConfirmModal() {
        let contentViewController = ConfirmModalViewController(router: self, context: self.context)
        let modalViewController = QModalViewController(contentViewController)
        self.presentModal(modalViewController, animated: true, completion: nil)
    }

    func dismiss(viewController: ModalViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmModalViewControllerRouter {

    func dismiss(viewController: ConfirmModalViewController) {
        guard let modalViewController = viewController.modalViewController else { return }
        self.dismissModal(modalViewController, animated: true, completion: nil)
    }

}

extension ChoiseWireframe : IDialogViewControllerRouter {

    func presentConfirmDialog() {
        let contentViewController = ConfirmDialogViewController(router: self, context: self.context)
        let dialogViewController = QDialogViewController(
            contentViewController,
            widthBehaviour: .fit(min: 160, max: 300),
            heightBehaviour: .fit(min: 240, max: 480)
        )
        self.presentDialog(dialogViewController, animated: true, completion: nil)
    }

    func dismiss(viewController: DialogViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmDialogViewControllerRouter {

    func dismiss(viewController: ConfirmDialogViewController) {
        guard let dialogViewController = viewController.dialogViewController else { return }
        self.dismissDialog(dialogViewController, animated: true, completion: nil)
    }

}

extension ChoiseWireframe : IPushViewControllerRouter {

    func presentConfirmPush() {
        let contentViewController = ConfirmPushViewController(router: self, context: self.context)
        let pushViewController = QPushViewController(contentViewController, displayTime: 7)
        self.presentPush(pushViewController, animated: true, completion: nil)
    }

    func dismiss(viewController: PushViewController) {
        self.popStack(viewController, animated: true)
    }

}

extension ChoiseWireframe : IConfirmPushViewControllerRouter {

    func dismiss(viewController: ConfirmPushViewController) {
        guard let pushViewController = viewController.pushViewController else { return }
        self.dismissPush(pushViewController, animated: true, completion: nil)
    }

}
