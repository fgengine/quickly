//
//
//  Quickly
//

import Quickly

protocol IListFieldViewControllerRouter: IQRouter {

    func dismiss(viewController: ListFieldViewController)
    
}

class ListFieldViewController: QStaticViewController, IQRouted {

    public var router: IListFieldViewControllerRouter
    public var container: AppContainer

    @IBOutlet private weak var listField: QListField!

    public init(router: IListFieldViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.listField.placeholder = QText("ListField")
        self.listField.rows = [
            QListFieldPickerRow(fieldText: QText("#1"), rowText: QText("Row #1")),
            QListFieldPickerRow(fieldText: QText("#2"), rowText: QText("Row #2")),
            QListFieldPickerRow(fieldText: QText("#3"), rowText: QText("Row #3")),
            QListFieldPickerRow(fieldText: QText("#4"), rowText: QText("Row #4")),
            QListFieldPickerRow(fieldText: QText("#5"), rowText: QText("Row #5"))
        ]
        self.listField.onSelect = { (listField, row) in
            print("\(NSStringFromClass(listField.classForCoder)).onSelect(row: \(row.rowText.string)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.listField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(false)
    }

}
