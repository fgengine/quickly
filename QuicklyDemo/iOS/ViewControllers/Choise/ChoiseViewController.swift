//
//  Quickly
//

import Quickly

protocol IChoiseViewControllerRouter: IQRouter {

    func presentLabelViewController()
    func presentButtonViewController()
    func presentTextFieldViewController()
    func presentImageViewController()
    func presentDialogViewController()
    func presentPushViewController()

}

class ChoiseViewController: QTableViewController, IQRouted {

    public var router: IChoiseViewControllerRouter
    public var container: AppContainer
    public var choiseTableController: ChoiseTableController! {
        get { return self.tableController as! ChoiseTableController }
    }

    public init(router: IChoiseViewControllerRouter, container: AppContainer) {
        self.router = router
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableController = ChoiseTableController(self)
    }
    
}

extension ChoiseViewController: ChoiseTableControllerDelegate {

    public func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        switch row.mode {
        case .label: self.router.presentLabelViewController()
        case .button: self.router.presentButtonViewController()
        case .textField: self.router.presentTextFieldViewController()
        case .image: self.router.presentImageViewController()
        case .dialog: self.router.presentDialogViewController()
        case .push: self.router.presentPushViewController()
        }
    }
    
}