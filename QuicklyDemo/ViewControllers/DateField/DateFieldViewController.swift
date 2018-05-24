//
//
//  Quickly
//

import Quickly

protocol IDateFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: DateFieldViewController)
    
}

class DateFieldViewController: QNibViewController, IQRouted {

    var router: IDateFieldViewControllerRouter
    var container: AppContainer

    @IBOutlet private weak var dateField: QDateField!

    init(router: IDateFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init()
    }

    override func didLoad() {
        super.didLoad()

        self.dateField.formatter = QDateFieldFormatter(dateFormat: "dd.MM.yyyy")
        self.dateField.placeholder = QText("DateField")
        self.dateField.onSelect = { (dateField, date) in
            print("\(NSStringFromClass(dateField.classForCoder)).onSelect(date: \(date)")
        }
    }

    override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.dateField.becomeFirstResponder()
    }

    override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.view.endEditing(false)
    }

    override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.dateField.becomeFirstResponder()
    }

    override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
    }

    override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.view.endEditing(false)
    }

}
