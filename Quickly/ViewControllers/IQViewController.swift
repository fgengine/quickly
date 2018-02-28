//
//  Quickly
//

public protocol IQBaseViewController : class {

    var isViewLoaded: Bool { get }

    #if os(macOS)
    var view: NSView { set get }
    #elseif os(iOS)
    var view: UIView! { set get }
    #endif

    func setup()

    func willPresent(animated: Bool)
    func didPresent(animated: Bool)

    func willDismiss(animated: Bool)
    func didDismiss(animated: Bool)

}

public protocol IQViewController : IQBaseViewController {

    #if os(iOS)

    var statusBarHidden: Bool { set get }
    var statusBarStyle: UIStatusBarStyle { set get }
    var statusBarAnimation: UIStatusBarAnimation { set get }
    var supportedOrientationMask: UIInterfaceOrientationMask { set get }
    var navigationBarHidden: Bool { set get }
    var toolbarHidden: Bool { set get }

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool)
    func setToolbarHidden(_ hidden: Bool, animated: Bool)

    #endif

}
