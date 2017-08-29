//
//  Quickly
//

import Quickly

class AppRouter: QAppRouter<
    AppContainer
> {

    public func presentChoise() {
        self.currentRouter = ChoiseRouter(container: self.container, router: self)
    }

}
