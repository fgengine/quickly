//
//  Quickly
//

import UIKit

protocol IQContentViewController : IQViewController {

    var statusBarHidden: Bool { set get }
    var statusBarStyle: UIStatusBarStyle { set get }
    var statusBarAnimation: UIStatusBarAnimation { set get }
    var supportedOrientationMask: UIInterfaceOrientationMask { set get }
    var navigationBarHidden: Bool { set get }
    var toolbarHidden: Bool { set get }

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool)
    func setToolbarHidden(_ hidden: Bool, animated: Bool)

}
