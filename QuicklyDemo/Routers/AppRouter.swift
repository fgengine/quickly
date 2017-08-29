//
//  Quickly
//

import Quickly

class AppRouter: QAppRouter {

    public func presentChoise() {
        self.currentRouter = ChoiseRouter(container: self.container, router: self)
    }

}
