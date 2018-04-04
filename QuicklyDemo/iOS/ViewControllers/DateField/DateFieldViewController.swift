//
//
//  Quickly
//

import Quickly

protocol IDateFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: DateFieldViewController)
    
}

class DateFieldViewController: QStaticViewController, IQRouted {

    public var router: IDateFieldViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var dateField: QDateField!

    public init(router: IDateFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateField.formatter = QDateFieldFormatter(dateFormat: "dd.MM.yyyy")
        self.dateField.placeholder = QText("DateField")
        self.dateField.onSelect = { (dateField, date) in
            print("\(NSStringFromClass(dateField.classForCoder)).onSelect(date: \(date)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.dateField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(false)
    }

}
