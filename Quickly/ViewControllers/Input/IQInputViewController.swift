//
//  Quickly
//

import UIKit

// MARK: IQInputViewController

public protocol IQInputViewController : IQViewController {
    
    var toolbar: QToolbar? { set get }
    var viewController: IQInputContentViewController { get }
    var height: CGFloat { get }

}

// MARK: IQHamburgerContentViewController

public protocol IQInputContentViewController : IQViewController {
    
    var inputViewController: IQInputViewController? { get }
    var inputToolbar: QToolbar? { set get }
    
}

public extension IQInputContentViewController {
    
    var inputViewController: IQInputViewController? {
        get { return self.parentViewControllerOf() }
    }
    var inputToolbar: QToolbar? {
        set(value) { self.inputViewController?.toolbar = value }
        get { return self.inputViewController?.toolbar }
        
    }
    
}
