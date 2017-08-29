//
//
//  Quickly
//

import Quickly

protocol ILabelViewControllerRouter: IQRouter {

    func presentLabelViewController()
    func dismiss(viewController: LabelViewController)
    
}

class LabelViewController: QStaticViewController, IQRouted {

    public var router: ILabelViewControllerRouter?
    public var container: IQContainer {
        get { return self.router!.container }
    }

}
