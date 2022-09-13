//
//  Quickly
//

import UIKit

open class QFormViewControllerField : IQFormViewControllerField {
    
    public var delegate: IQFormViewControllerFieldDelegate?
    public var view: QDisplayView {
        get {
            self.loadViewIfNeeded()
            return self._view
        }
    }
    open var isValid: Bool {
        get { return false }
    }
    public private(set) var isLoading: Bool = false
    public var isLoaded: Bool {
        get { return (self._view != nil) }
    }
    
    private var _view: QDisplayView!
    
    public init() {
        self.setup()
    }

    open func setup() {
    }

    open func loadViewIfNeeded() {
        if self._view == nil && self.isLoading == false {
            self.isLoading = true
            self._view = QDisplayView()
            self._view.translatesAutoresizingMaskIntoConstraints = false
            self.didLoad()
            self.isLoading = false
        }
    }

    open func didLoad() {
    }
    
    open func beginEditing() {
    }
    
    open func endEditing() {
        self.view.endEditing(false)
    }
    
    open func showError() {
    }
    
}
