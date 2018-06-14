//
//  Quickly
//

public class QPushViewControllerAnimation : IQPushViewControllerFixedAnimation {

    internal var duration: TimeInterval
    internal var viewController: IQPushViewController!

    public init(duration: TimeInterval = 0.2) {
        self.duration = duration
    }

    public func prepare(viewController: IQPushViewController) {
        self.viewController = viewController
    }

    public func update(animated: Bool, complete: @escaping (Bool) -> Void) {
    }

}

public class QPushViewControllerPresentAnimation : QPushViewControllerAnimation {


    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            self.viewController.willPresent(animated: animated)
            self.viewController.view.layoutIfNeeded()
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.pushState = .show
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.didPresent(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.pushState = .show
            self.viewController.willPresent(animated: animated)
            self.viewController.didPresent(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}

public class QPushViewControllerDismissAnimation : QPushViewControllerAnimation {

    public override func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void) {
        if animated == true {
            self.viewController.willDismiss(animated: animated)
            UIView.animate(withDuration: self.duration, animations: {
                self.viewController.pushState = .hide
                self.viewController.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                self.viewController.didDismiss(animated: animated)
                self.viewController = nil
                complete(completed)
            })
        } else {
            self.viewController.pushState = .hide
            self.viewController.willDismiss(animated: animated)
            self.viewController.didDismiss(animated: animated)
            self.viewController = nil
            complete(true)
        }
    }

}
