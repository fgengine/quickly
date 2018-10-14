//
//  Quickly
//

import Quickly

class AppWireframe: QAppWireframe< AppContext > {

    override init(context: AppContext) {
        super.init(context: context)

        self.modalContainerViewController = QModalContainerViewController()

        self.dialogContainerViewController = QDialogContainerViewController()
        self.dialogContainerViewController!.backgroundView = QDialogBlurBackgroundView()

        self.pushContainerViewController = QPushContainerViewController()
    }

    override func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?) {
        self.presentChoise()
        super.launch(options)
    }

    func presentChoise() {
        self.current = ChoiseWireframe(context: self.context, parent: self)
    }

}
