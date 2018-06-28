//
//
//  Quickly
//

import Quickly

protocol IDateFieldViewControllerRoutePath : IQRoutePath {

    func dismiss(viewController: DateFieldViewController)
    
}

class DateFieldViewController : QNibViewController, IQRoutable {

    weak var routePath: IDateFieldViewControllerRoutePath!
    weak var routeContext: AppRouteContext!

    @IBOutlet private weak var dateField: QDateField!

    init(_ routePath: IDateFieldViewControllerRoutePath, _ routeContext: AppRouteContext) {
        self.routePath = routePath
        self.routeContext = routeContext
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
        self.dateField.beginEditing()
    }

    override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.view.endEditing(false)
    }

    override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.dateField.beginEditing()
    }

    override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
    }

    override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.view.endEditing(false)
    }

}
