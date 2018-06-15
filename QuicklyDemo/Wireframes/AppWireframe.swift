//
//  Quickly
//

import Quickly

class AppWireframe: QAppWireframe< AppRouteContext > {

    override init(_ routeContext: AppRouteContext) {
        super.init(routeContext)

        self.modalContainerViewController = QModalContainerViewController()

        self.dialogContainerViewController = QDialogContainerViewController()
        self.dialogContainerViewController!.backgroundView = QDialogBlurBackgroundView()

        self.pushContainerViewController = QPushContainerViewController()
    }

    override func launch(_ options: [UIApplicationLaunchOptionsKey : Any]?) {
        self.presentChoise()
    }

    func presentChoise() {
        self.currentWireframe = ChoiseWireframe(self.routeContext, self)
    }

}
