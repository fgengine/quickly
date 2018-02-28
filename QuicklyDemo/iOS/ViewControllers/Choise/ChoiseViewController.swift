//
//  Quickly
//

import Quickly

class ChoiseViewController: QTableViewController, IQRouted {

    public var router: ChoiseRouter?
    public var container: AppContainer?
    public var choiseTableController: ChoiseTableController! {
        get { return self.tableController as! ChoiseTableController }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableController = ChoiseTableController(self)
    }
    
}

extension ChoiseViewController: ChoiseTableControllerDelegate {

    public func pressedChoiseSectionRow(_ row: ChoiseSectionTableRow) {
        if let router: ChoiseRouter = self.router {
            switch row.mode {
            case .label: router.presentLabelViewController()
            case .button: router.presentButtonViewController()
            case .textField: router.presentTextFieldViewController()
            case .image: router.presentImageViewController()
            }
        }
    }
    
}
